import 'package:equatable/equatable.dart';
import 'package:marketplace_app/Model/product_model.dart';

/// Products State - Manages product listing and filtering states
abstract class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any data is loaded
class ProductsInitial extends ProductsState {
  const ProductsInitial();
}

/// Loading state while fetching products
class ProductsLoading extends ProductsState {
  const ProductsLoading();
}

/// Success state with loaded products
class ProductsLoaded extends ProductsState {
  final List<Product> products;
  final List<Product> filteredProducts;
  final String? selectedCategory;
  final int? selectedCategoryId;
  final String? selectedSubCategory;

  const ProductsLoaded({
    required this.products,
    required this.filteredProducts,
    this.selectedCategory,
    this.selectedCategoryId,
    this.selectedSubCategory,
  });

  ProductsLoaded copyWith({
    List<Product>? products,
    List<Product>? filteredProducts,
    String? selectedCategory,
    int? selectedCategoryId,
    String? selectedSubCategory,
  }) {
    return ProductsLoaded(
      products: products ?? this.products,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      selectedSubCategory: selectedSubCategory ?? this.selectedSubCategory,
    );
  }

  @override
  List<Object?> get props => [
        products,
        filteredProducts,
        selectedCategory,
        selectedCategoryId,
        selectedSubCategory,
      ];
}

/// Error state when product loading fails
class ProductsError extends ProductsState {
  final String message;

  const ProductsError(this.message);

  @override
  List<Object> get props => [message];
}

/// Empty state when no products are available
class ProductsEmpty extends ProductsState {
  const ProductsEmpty();
}
