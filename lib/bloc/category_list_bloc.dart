import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylish_wen/data/category_model.dart';
import 'package:stylish_wen/data/product.dart';
import 'package:stylish_wen/model/api_service.dart';
import 'package:stylish_wen/model/request.dart';

abstract class CategoryListState extends Equatable {}

class Success extends CategoryListState {
  final PagedProduct list;

  Success({required this.list});

  @override
  List<Object?> get props => [list];
}

class Initial extends CategoryListState {
  final PagedProduct list = PagedProduct([], 0);

  @override
  List<Object?> get props => [list];
}

class Loading extends CategoryListState {
  Loading();

  @override
  List<Object?> get props => [];
}

class Failure extends CategoryListState {
  final String message;

  Failure(this.message);

  @override
  List<Object?> get props => [message];
}

enum CategoryListEvent { fetch }

class CategoryListBloc extends Bloc<CategoryListEvent, CategoryListState> {
  CategoryListAPIServiceProtocol repo;
  ProductListType type;

  CategoryListState get initialState => Initial();

  CategoryListBloc({required this.repo, required this.type})
      : super(Initial()) {
    on<CategoryListEvent>((event, emit) async {
      if (event == CategoryListEvent.fetch) {
        emit(Loading());
        try {
          state;
          final list = await repo.fetchCategoryList(type);
          emit(Success(list: list));
        } catch (e) {
          emit(Failure(e.toString()));
        }
      }
    });
  }
}
