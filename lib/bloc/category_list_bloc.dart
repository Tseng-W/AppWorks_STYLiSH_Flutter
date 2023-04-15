import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylish_wen/data/category_model.dart';
import 'package:stylish_wen/model/api_service.dart';

abstract class CategoryListState extends Equatable {}

class Success extends CategoryListState {
  final List<CategoryData> list;

  Success(this.list);

  @override
  List<Object?> get props => [list];
}

class Initial extends CategoryListState {
  final List<CategoryData> list = [];

  Initial();

  @override
  List<Object?> get props => [list];
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
  CategoryListBloc({required this.repo}) : super(Initial()) {
    on<CategoryListEvent>((event, emit) async {
      if (event == CategoryListEvent.fetch) {
        try {
          final list = await repo.fetchCategoryList();
          emit(Success(list));
        } catch (e) {
          emit(Failure(e.toString()));
        }
      }
    });
  }
}
