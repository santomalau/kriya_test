import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:kriya/api/models/models.dart';
import 'package:kriya/api/product_api_client.dart';
import 'package:equatable/equatable.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductApiClient _productsApiClient;
  List<Product> _products = [];
  List<Product> _tempProducts = [];
  List<Product> _orders = [];

  ProductBloc({required ProductApiClient productsApiClient})
      : _productsApiClient = productsApiClient,
        super(ProductLoadInProgress());

  final StreamController<List<Product>> _listController =
      StreamController.broadcast();

  Stream<List<Product>> get listStream => _listController.stream;
  StreamSink<List<Product>> get _listSink => _listController.sink;

  @override
  Future<void> close() {
    _listController.close();
    return super.close();
  }

  @override
  Stream<ProductState> mapEventToState(ProductEvent event) async* {
    if (event is ProductFetchStarted) {
      yield* _mapInitialEventToState();
    }
    if (event is ProductIncrementEvent) {
      yield* _increaseProductQuantityToState(product: event.product);
    }
    if (event is ProductDecrementEvent) {
      yield* _decreaseProductQuantityToState(product: event.product);
    }
    if (event is ProductRevertEvent) {
      yield* _mapProductRevertToState();
    }
    if (event is ProductMigrateEvent) {
      yield* _mapProductMigrateToState();
    }
    if (event is ProductOrderClearEvent) {
      yield* _mapProductOrderClearToState();
    }
  }

  // Stream Functions
  Stream<ProductState> _mapInitialEventToState() async* {
    yield ProductLoadInProgress();

    await _getProducts();

    yield ProductLoadSuccess();
  }

  // Helper Functions
  Future<void> _getProducts() async {
    print("Step 5: _getProduct()");

    _products.clear();
    _products = await _productsApiClient.fetchProduct();
    print("Panjang _productNew : " + _products.length.toString());
    _listSink.add(_products);
  }

  Stream<ProductState> _increaseProductQuantityToState(
      {required Product product}) async* {
    // yield ProductLoadInProgress();
    await _increaseProductQuantity(product: product);

    yield ProductLoadSuccess();
  }

  Stream<ProductState> _decreaseProductQuantityToState(
      {required Product product}) async* {
    // yield ProductLoadInProgress();
    await _decreaseProductQuantity(product: product);

    yield ProductLoadSuccess();
  }

  Stream<ProductState> _mapProductMigrateToState() async* {
    yield ProductLoadInProgress();

    await _migrateProductToOrder();

    yield ProductLoadSuccess();
  }

  Stream<ProductState> _mapProductRevertToState() async* {
    yield ProductLoadInProgress();

    await _revertOrderToProduct();

    yield ProductLoadSuccess();
  }

  Stream<ProductState> _mapProductOrderClearToState() async* {
    yield ProductLoadInProgress();

    await _clearOrderProduct();

    yield ProductLoadSuccess();
  }

  Future<void> _increaseProductQuantity({required Product product}) async {
    final index = _products.indexWhere((element) =>
        element.id == product.id && element.userId == product.userId);
    if (index >= 0) {
      // print('Using indexWhere: ${people[index]}');
      _products[index].quantity = (_products[index].quantity ?? 0) + 1;
      _updateList();
    }
  }

  Future<void> _decreaseProductQuantity({required Product product}) async {
    final index = _products.indexWhere((element) =>
        element.id == product.id && element.userId == product.userId);
    if (index >= 0) {
      // print('Using indexWhere: ${people[index]}');
      if ((_products[index].quantity ?? 0) > 0) {
        _products[index].quantity = (_products[index].quantity ?? 0) - 1;
        _updateList();
      }
    }
  }

  Future<void> _revertOrderToProduct() async {
    _listSink.add(_products);
  }

  Future<void> _migrateProductToOrder() async {
    _orders = [];
    _products.forEach((element) {
      if ((element.quantity ?? 0) > 0) {
        _orders.add(element);
      }
    });
    _listSink.add(_orders);
  }

  Future<void> _clearOrderProduct() async {
    _orders.clear();
    _getProducts();
  }

  Future<void> _updateList() async {
    _tempProducts = _products;
    _products = [];
    _products = _tempProducts;
    _listSink.add(_products);
  }
}
