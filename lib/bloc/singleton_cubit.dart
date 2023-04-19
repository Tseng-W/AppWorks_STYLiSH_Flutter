import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylish_wen/model/api_service.dart';

class SingletonModels {
  APIServiceProtocol apiService = APIService();
}

class SingletonCubit extends Cubit<SingletonModels> {
  SingletonCubit() : super(SingletonModels());
}
