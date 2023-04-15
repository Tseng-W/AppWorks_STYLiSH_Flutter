import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylish_wen/data/product_detail_model.dart';
import 'package:stylish_wen/model/api_service.dart';

abstract class ProductDetailState extends Equatable {}

class Success extends ProductDetailState {
  final ProductDetailModel model;

  Success(this.model);

  @override
  List<Object?> get props => [model];
}

class Initial extends ProductDetailState {
  final ProductDetailModel? model = null;

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

class ProductDetailBloc extends Bloc<String, ProductDetailState> {
  ProductDetailAPIServiceProtocol repo;
  ProductDetailBloc({required this.repo}) : super(Initial()) {
    on<String>((event, emit) async {
      try {
        final model = await repo.fetchProductDetail(event);
        emit(Success(model));
        emit(Initial());
      } catch (e) {
        emit(Failure(e.toString()));
      }
    });
  }
}
