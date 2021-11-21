part of 'product_bloc.dart';

abstract class ProductState extends Equatable {
  @override
  List<Object> get props => [];
}

class ProductInitialData extends ProductState {}

class ProductLoadInProgress extends ProductState {}

class ProductLoadSuccess extends ProductState {}

class ProductLoadFailure extends ProductState {}

class ProductAddState extends ProductState {}

class ProductEditState extends ProductState {
  final Product product;

  ProductEditState({required this.product});
}

class ProductNewState extends ProductState {}

class ProductMutationState extends ProductState {}
