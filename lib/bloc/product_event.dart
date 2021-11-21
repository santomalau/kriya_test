part of 'product_bloc.dart';

class ProductEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ProductFetchStarted extends ProductEvent {}

class ProductIncrementEvent extends ProductEvent {
  final Product product;

  ProductIncrementEvent({required this.product});
}

class ProductDecrementEvent extends ProductEvent {
  final Product product;

  ProductDecrementEvent({required this.product});
}

class ProductRevertEvent extends ProductEvent {}

class ProductMigrateEvent extends ProductEvent {}

class ProductOrderClearEvent extends ProductEvent {}
