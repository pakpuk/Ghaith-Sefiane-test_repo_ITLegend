import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:marketplace_app/Model/product_model.dart';
import 'package:marketplace_app/cubit/state/products_state.dart';
import 'package:marketplace_app/db/database.dart';

/// Products Cubit
/// Manages products state and business logic
class ProductsCubit extends Cubit<ProductsState> {
  final DatabaseHelper _dbHelper;

  ProductsCubit(this._dbHelper) : super(const ProductsInitial());

  /// Load all products from database
  Future<void> loadProducts() async {
    try {
      emit(const ProductsLoading());

      debugPrint('🔄 [ProductsCubit] Loading products...');

      final products = await _dbHelper.getAllProducts();

      debugPrint('✅ [ProductsCubit] Loaded ${products.length} products');

      if (products.isEmpty) {
        emit(const ProductsEmpty());
      } else {
        emit(ProductsLoaded(
          products: products,
          filteredProducts: products,
        ));
      }
    } catch (e, stackTrace) {
      debugPrint('❌ [ProductsCubit] Error loading products: $e');
      debugPrint('Stack trace: $stackTrace');
      emit(ProductsError('فشل تحميل المنتجات: $e'));
    }
  }

  /// Filter products by category
  Future<void> filterByCategory(String categoryName, int categoryId) async {
    if (state is! ProductsLoaded) return;

    final currentState = state as ProductsLoaded;

    debugPrint(
        '🔍 [ProductsCubit] Filtering by category: $categoryName (ID: $categoryId)');

    List<Product> filtered;

    if (categoryId == 0) {
      // Show all products
      filtered = currentState.products;
    } else {
      // Filter by specific category
      filtered = currentState.products
          .where((p) => p.categoryId == categoryId)
          .toList();
    }

    debugPrint('✅ [ProductsCubit] Filtered to ${filtered.length} products');

    emit(currentState.copyWith(
      filteredProducts: filtered,
      selectedCategory: categoryName,
      selectedCategoryId: categoryId,
      selectedSubCategory: 'الكل', // Reset subcategory
    ));
  }

  /// Filter products by subcategory
  Future<void> filterBySubCategory(String subCategory) async {
    if (state is! ProductsLoaded) return;

    final currentState = state as ProductsLoaded;

    debugPrint('🔍 [ProductsCubit] Filtering by subcategory: $subCategory');

    List<Product> filtered;

    if (subCategory == 'الكل') {
      // Reset to category filter or all
      if (currentState.selectedCategoryId == null ||
          currentState.selectedCategoryId == 0) {
        filtered = currentState.products;
      } else {
        filtered = currentState.products
            .where((p) => p.categoryId == currentState.selectedCategoryId)
            .toList();
      }
    } else {
      // Filter by subcategory
      filtered = currentState.products
          .where((p) => p.subcategory == subCategory)
          .toList();
    }

    debugPrint('✅ [ProductsCubit] Filtered to ${filtered.length} products');

    emit(currentState.copyWith(
      filteredProducts: filtered,
      selectedSubCategory: subCategory,
    ));
  }

  /// Toggle favorite status of a product
  Future<void> toggleFavorite(Product product) async {
    try {
      debugPrint('❤️ [ProductsCubit] Toggling favorite for: ${product.name}');

      final updatedProduct = product.copyWith(
        isFavorite: !product.isFavorite,
      );

      await _dbHelper.updateProduct(updatedProduct);

      // Reload products to reflect changes
      await loadProducts();

      debugPrint('✅ [ProductsCubit] Favorite toggled successfully');
    } catch (e) {
      debugPrint('❌ [ProductsCubit] Error toggling favorite: $e');
      // Don't emit error, just log it
    }
  }

  /// Refresh products (pull to refresh)
  Future<void> refreshProducts() async {
    debugPrint('🔄 [ProductsCubit] Refreshing products...');
    await loadProducts();
  }

  /// Reset database and reload
  Future<void> resetDatabase() async {
    try {
      emit(const ProductsLoading());

      debugPrint('🔄 [ProductsCubit] Resetting database...');

      await _dbHelper.resetDatabase();

      debugPrint('✅ [ProductsCubit] Database reset complete');

      await loadProducts();
    } catch (e) {
      debugPrint('❌ [ProductsCubit] Error resetting database: $e');
      emit(ProductsError('فشل إعادة تعيين قاعدة البيانات: $e'));
    }
  }

  /// Get favorite products
  List<Product> getFavorites() {
    if (state is ProductsLoaded) {
      final currentState = state as ProductsLoaded;
      return currentState.products.where((p) => p.isFavorite).toList();
    }
    return [];
  }
}
