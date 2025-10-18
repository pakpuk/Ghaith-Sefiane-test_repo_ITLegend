import 'package:flutter/material.dart';
import 'package:marketplace_app/Model/product_model.dart';
import 'package:marketplace_app/db/database.dart';

import '../widgets/product_card.dart';

/// Products Page - Main Discovery Page
/// Displays all offers with categories, subcategories, and product grid
/// Loads products dynamically from SQLite database
class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = true;
  String _selectedCategory = 'كل العروض';
  String _selectedSubCategory = 'الكل';

  // Categories with their IDs
  final List<Map<String, dynamic>> _categories = [
    {'name': 'كل العروض', 'id': 0},
    {'name': 'ملابس', 'id': 1},
    {'name': 'أحذية', 'id': 2},
    {'name': 'ساعات', 'id': 3},
    {'name': 'حقائب', 'id': 4},
    {'name': 'إكسسوارات', 'id': 5},
  ];

  // Subcategories
  final List<String> _subCategories = [
    'الكل',
    'ساعات',
    'أحذية',
    'حقائب',
    'إكسسوارات',
    'ملابس',
  ];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  /// Load products from database
  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);

    try {
      debugPrint('🔄 Loading products from database...');
      final products = await _dbHelper.getAllProducts();

      debugPrint('✅ Loaded ${products.length} products');

      setState(() {
        _allProducts = products;
        _filteredProducts = products;
        _isLoading = false;
      });

      if (products.isEmpty) {
        debugPrint('⚠️ No products found in database');
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Error loading products: $e');
      debugPrint('Stack trace: $stackTrace');
      setState(() => _isLoading = false);
    }
  }

  /// Filter products by category
  void _filterByCategory(String categoryName, int categoryId) {
    setState(() {
      _selectedCategory = categoryName;

      if (categoryId == 0) {
        _filteredProducts = _allProducts;
      } else {
        _filteredProducts =
            _allProducts.where((p) => p.categoryId == categoryId).toList();
      }

      debugPrint('🔍 Filtered to ${_filteredProducts.length} products');
    });
  }

  /// Filter products by subcategory
  void _filterBySubCategory(String subCategory) {
    setState(() {
      _selectedSubCategory = subCategory;

      if (subCategory == 'الكل') {
        _filteredProducts = _allProducts;
      } else {
        _filteredProducts =
            _allProducts.where((p) => p.subcategory == subCategory).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          'استخدم فيموزى',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black87),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon:
                const Icon(Icons.notifications_outlined, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Discover All Offers Header
            _buildDiscoverHeader(),

            // Row 2: "الكل" chip + Filter button
            _buildFilterRow(),

            // Horizontal Category Chips
            _buildCategoryChips(),

            // Subcategories ListView (horizontal)
            _buildSubCategoriesRow(),

            // Light Red Info Container
            _buildInfoContainer(),

            // Products Grid
            _isLoading
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                : _filteredProducts.isEmpty
                    ? _buildEmptyState()
                    : _buildProductsGrid(),
          ],
        ),
      ),

      // Bottom Navigation
      bottomNavigationBar: _buildBottomNavBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new ad
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.add, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  /// Row 1: "اكتشف كل العروض" header with icon
  Widget _buildDiscoverHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          Icon(
            Icons.grid_view_rounded,
            color: Colors.blue[700],
            size: 24,
          ),
          const SizedBox(width: 12),
          const Text(
            'اكتشف كل العروض',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  /// Row 2: "الكل" button + Filter button
  Widget _buildFilterRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: Row(
        children: [
          // "الكل" button with icon
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_circle_outline,
                    size: 18, color: Colors.grey[700]),
                const SizedBox(width: 6),
                Text(
                  'الكل',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Filter button
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/filter');
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.filter_list, size: 18, color: Colors.grey[700]),
                    const SizedBox(width: 8),
                    Text(
                      'تصفية حسب',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Horizontal category chips row
  Widget _buildCategoryChips() {
    return Container(
      height: 50,
      color: Colors.white,
      margin: const EdgeInsets.only(top: 1),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category['name'];

          return GestureDetector(
            onTap: () => _filterByCategory(category['name'], category['id']),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF005BFF) : Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  category['name'],
                  style: TextStyle(
                    fontSize: 13,
                    color: isSelected ? Colors.white : Colors.grey[700],
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Subcategories horizontal ListView
  Widget _buildSubCategoriesRow() {
    return Container(
      height: 120,
      color: Colors.white,
      margin: const EdgeInsets.only(top: 1),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        itemCount: _subCategories.length,
        itemBuilder: (context, index) {
          final subCategory = _subCategories[index];
          final isSelected = _selectedSubCategory == subCategory;

          // Get icon based on subcategory
          String getIcon() {
            switch (subCategory) {
              case 'ساعات':
                return '⌚';
              case 'أحذية':
                return '👟';
              case 'حقائب':
                return '👜';
              case 'إكسسوارات':
                return '🕶️';
              case 'ملابس':
                return '👕';
              default:
                return '🛍️';
            }
          }

          return GestureDetector(
            onTap: () => _filterBySubCategory(subCategory),
            child: Container(
              width: 80,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Image/Icon circle
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF005BFF)
                          : Colors.grey[100],
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        getIcon(),
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Subcategory name
                  Text(
                    subCategory,
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected
                          ? const Color(0xFF005BFF)
                          : Colors.grey[700],
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Light red info container with two texts
  Widget _buildInfoContainer() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3F3), // Light red/pink
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.local_offer,
                size: 18,
                color: Colors.red[700],
              ),
              const SizedBox(width: 8),
              Text(
                'عروض مميزة اليوم',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.red[700],
                ),
              ),
            ],
          ),
          Text(
            'شاهد الكل',
            style: TextStyle(
              fontSize: 13,
              color: Colors.red[600],
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }

  /// Products Grid (2 columns)
  Widget _buildProductsGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: _filteredProducts.length,
        itemBuilder: (context, index) {
          return ProductCard(
            product: _filteredProducts[index],
            onFavoriteToggle: () => _toggleFavorite(_filteredProducts[index]),
          );
        },
      ),
    );
  }

  /// Empty state widget
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 80,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              'لا توجد منتجات حالياً',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'جرب تصفية مختلفة أو عد لاحقاً',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Bottom Navigation Bar (5 items + FAB)
  Widget _buildBottomNavBar() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.grid_view, 'العروض', 0, true),
            _buildNavItem(Icons.chat_bubble_outline, 'المحادثات', 1, false),
            const SizedBox(width: 40), // Space for FAB
            _buildNavItem(Icons.library_books_outlined, 'إعلاناتي', 3, false),
            _buildNavItem(Icons.person_outline, 'حسابي', 4, false),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index, bool isActive) {
    return InkWell(
      onTap: () {
        if (index == 4) {
          Navigator.pushNamed(context, '/plans');
        } else if (index == 1) {
          Navigator.pushNamed(context, '/chat');
        } else if (index == 3) {
          Navigator.pushNamed(context, '/myads');
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? const Color(0xFF005BFF) : Colors.grey[600],
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isActive ? const Color(0xFF005BFF) : Colors.grey[600],
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  /// Toggle favorite status
  Future<void> _toggleFavorite(Product product) async {
    try {
      final updatedProduct = product.copyWith(
        isFavorite: !product.isFavorite,
      );
      await _dbHelper.updateProduct(updatedProduct);
      await _loadProducts();
    } catch (e) {
      debugPrint('❌ Error toggling favorite: $e');
    }
  }
}
