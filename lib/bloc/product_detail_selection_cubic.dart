import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class ProductSelectionModel {
  int selectedSizeIndex = 0;
  int? selectedColorIndex;

  copyWith({
    int? selectedSizeIndex,
    int? selectedColorIndex,
  }) {
    if (selectedSizeIndex != null) {
      return ProductSelectionModel()
        ..selectedSizeIndex = selectedSizeIndex
        ..selectedColorIndex = null;
    } else if (selectedColorIndex != null) {
      return ProductSelectionModel()
        ..selectedSizeIndex = this.selectedSizeIndex
        ..selectedColorIndex = selectedColorIndex;
    } else {
      return this;
    }
  }
}

class ProductDetailSelectionCubit extends Cubit<ProductSelectionModel> {
  ProductDetailSelectionCubit() : super(ProductSelectionModel());

  void selectSize(int index) {
    emit(state.copyWith(selectedSizeIndex: index));
  }

  void selectColor(int index) {
    emit(state.copyWith(selectedColorIndex: index));
  }
}
