import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylish_wen/data/hot_product_model.dart';
import 'package:stylish_wen/model/api_service.dart';

abstract class HotProductState extends Equatable {}

class Success extends HotProductState {
  final List<HotProductModel> list;

  Success(this.list);

  @override
  List<Object?> get props => [list];
}

class Initial extends HotProductState {
  final List<HotProductModel> list = [];

  Initial();

  @override
  List<Object?> get props => [list];
}

class Failure extends HotProductState {
  final String message;

  Failure(this.message);

  @override
  List<Object?> get props => [message];
}

enum HotProductEvent { fetch }

class HotProductBloc extends Bloc<HotProductEvent, HotProductState> {
  HotProductAPIServiceProtocol repo;
  HotProductBloc({required this.repo}) : super(Initial()) {
    on<HotProductEvent>((event, emit) async {
      if (event == HotProductEvent.fetch) {
        try {
          final list = await repo.fetchHotProductList();
          emit(Success(list));
        } catch (e) {
          emit(Failure(e.toString()));
        }
      }
    });
  }
}
