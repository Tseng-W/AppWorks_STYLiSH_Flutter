import 'package:flutter_bloc/flutter_bloc.dart';

enum LoadingStatus { loading, loaded }

class LoadingCubit extends Cubit<bool> {
  LoadingCubit() : super(false);
  void startLoading() => emit(true);
  void endLoading() => emit(false);
}
