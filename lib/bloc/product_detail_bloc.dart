import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylish_wen/data/product.dart';
import 'package:stylish_wen/model/api_service.dart';
import 'package:stylish_wen/model/request.dart';

abstract class ProductDetailState extends Equatable {}

class Success extends ProductDetailState {
  final Product model;

  Success(this.model);

  @override
  List<Object?> get props => [model];
}

class Initial extends ProductDetailState {
  final Product? model = null;

  Initial();

  @override
  List<Object?> get props => [model];
}

class Failure extends ProductDetailState {
  final String message;

  Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class ProductDetailBloc extends Bloc<int, ProductDetailState> {
  APIServiceProtocol repo;
  ProductDetailBloc({required this.repo}) : super(Initial()) {
    on<int>((productId, emit) async {
      try {
        emit(Initial());
        final model = await repo.fetchRequest(ProductDetailRequest(productId));
        emit(Success(model));
      } catch (e) {
        emit(Failure(e.toString()));
      }
    });
  }
}
