import 'dart:io';
import 'package:marketplace_app/Model/product_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';

// ✅ Import sqflite_common_ffi for desktop platforms
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as ffi;

/// Database Helper Class
/// Manages SQLite database operations for the marketplace app
/// Supports both mobile (Android/iOS) and desktop (Windows/Linux/macOS) platforms
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  static bool _initialized = false;

  DatabaseHelper._init();

  /// Initialize database factory for desktop platforms
  /// Must be called before accessing database on Windows/Linux/macOS
  static void initializeDatabaseFactory() {
    if (_initialized) return;

    // ✅ Check if running on desktop platform
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      debugPrint('🖥️ Desktop platform detected - initializing sqflite_ffi');
      
      // ✅ Initialize FFI for desktop
      ffi.sqfliteFfiInit();
      
      // ✅ Set database factory to FFI
      databaseFactory = ffi.databaseFactoryFfi;
      
      debugPrint('✅ Database factory initialized for desktop');
    } else {
      debugPrint('📱 Mobile platform detected - using default sqflite');
    }

    _initialized = true;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;

    // ✅ Ensure factory is initialized before opening database
    initializeDatabaseFactory();

    _database = await _initDB('marketplace.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    // ✅ Get database path based on platform
    String dbPath;
    
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      // Desktop: Use app directory
      dbPath = await ffi.databaseFactoryFfi.getDatabasesPath();
    } else {
      // Mobile: Use standard path
      dbPath = await getDatabasesPath();
    }

    final path = join(dbPath, filePath);
    debugPrint('📂 Database path: $path');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onOpen: (db) async {
        debugPrint('✅ Database opened successfully');

        // ✅ Check if products table has data
        try {
          final result = await db.rawQuery('SELECT COUNT(*) FROM products');
          final count = Sqflite.firstIntValue(result);

          if (count == null || count == 0) {
            debugPrint('⚠️ No products found — inserting seed data...');
            await _insertSeedData(db);
          } else {
            debugPrint('📦 Products already in DB: $count');
          }
        } catch (e) {
          debugPrint('❌ Error checking product count: $e');
        }
      },
    );
  }

  /// Create database tables
  Future<void> _createDB(Database db, int version) async {
    debugPrint('🔨 Creating database tables...');

    try {
      const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
      const textType = 'TEXT NOT NULL';
      const realType = 'REAL NOT NULL';
      const intType = 'INTEGER NOT NULL';

      // ✅ Create products table
      await db.execute('''
        CREATE TABLE products (
          id $idType,
          name $textType,
          description TEXT,
          price $realType,
          image $textType,
          categoryId $intType,
          subcategory $textType,
          offerType $textType,
          location TEXT DEFAULT 'القاهرة',
          isFavorite INTEGER DEFAULT 0
        )
      ''');
      debugPrint('✅ Products table created');

      // ✅ Create offers table
      await db.execute('''
        CREATE TABLE offers (
          id $idType,
          title $textType,
          description $textType,
          price $realType,
          company $textType,
          type $textType,
          deliveryTime TEXT DEFAULT '3-5 أيام',
          location TEXT DEFAULT 'القاهرة',
          reviewCount INTEGER DEFAULT 0,
          rating REAL DEFAULT 0.0
        )
      ''');
      debugPrint('✅ Offers table created');

      // ✅ Create packs table
      await db.execute('''
        CREATE TABLE packs (
          id $idType,
          name $textType,
          price $realType,
          description $textType,
          features $textType,
          duration TEXT DEFAULT 'شهري',
          isPopular INTEGER DEFAULT 0
        )
      ''');
      debugPrint('✅ Packs table created');

      // ✅ Insert seed data
      await _insertSeedData(db);
    } catch (e, stackTrace) {
      debugPrint('❌ Error creating tables: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Insert default seed data if tables are empty
  Future<void> _insertSeedData(Database db) async {
    try {
      debugPrint('🌱 Checking seed data...');

      // ✅ Prevent duplicate insertion
      final result = await db.rawQuery('SELECT COUNT(*) FROM products');
      final existing = Sqflite.firstIntValue(result);
      
      if (existing != null && existing > 0) {
        debugPrint('⚠️ Seed data already exists ($existing products), skipping insert.');
        return;
      }

      debugPrint('🌱 Inserting seed data...');

    // ---------- PRODUCTS ----------
    final products = [
      {
        'name': 'قميص رسمي بني',
        'description': 'قميص رسمي فاخر',
        'price': 299.0,
        'image': '🎽',
        'categoryId': 1,
        'subcategory': 'ملابس',
        'offerType': 'normal',
        'location': 'القاهرة',
        'isFavorite': 0
      },
      {
        'name': 'جاكيت شتوي أسود',
        'description': 'جاكيت شتوي دافئ',
        'price': 599.0,
        'image': '🧥',
        'categoryId': 1,
        'subcategory': 'ملابس',
        'offerType': 'urgent',
        'location': 'الإسكندرية',
        'isFavorite': 0
      },
      {
        'name': 'حذاء رياضي نايك',
        'description': 'حذاء رياضي أصلي',
        'price': 890.0,
        'image': '👟',
        'categoryId': 2,
        'subcategory': 'أحذية',
        'offerType': 'urgent',
        'location': 'القاهرة',
        'isFavorite': 0
      },
      {
        'name': 'ساعة ذكية',
        'description': 'ساعة ذكية حديثة',
        'price': 1200.0,
        'image': '⌚',
        'categoryId': 3,
        'subcategory': 'ساعات',
        'offerType': 'normal',
        'location': 'الجيزة',
        'isFavorite': 0
      },
      {
        'name': 'حقيبة جلدية',
        'description': 'حقيبة جلد طبيعي',
        'price': 450.0,
        'image': '👜',
        'categoryId': 4,
        'subcategory': 'حقائب',
        'offerType': 'normal',
        'location': 'القاهرة',
        'isFavorite': 0
      },
      {
        'name': 'بنطلون جينز',
        'description': 'بنطلون جينز أزرق',
        'price': 350.0,
        'image': '👖',
        'categoryId': 1,
        'subcategory': 'ملابس',
        'offerType': 'normal',
        'location': 'المنصورة',
        'isFavorite': 0
      },
      {
        'name': 'نظارة شمسية',
        'description': 'نظارة شمسية عصرية',
        'price': 280.0,
        'image': '🕶️',
        'categoryId': 5,
        'subcategory': 'إكسسوارات',
        'offerType': 'urgent',
        'location': 'القاهرة',
        'isFavorite': 0
      },
      {
        'name': 'حذاء كلاسيكي',
        'description': 'حذاء كلاسيكي أنيق',
        'price': 380.0,
        'image': '👞',
        'categoryId': 2,
        'subcategory': 'أحذية',
        'offerType': 'normal',
        'location': 'الإسكندرية',
        'isFavorite': 0
      },
    ];

      // ✅ Insert products using batch for better performance
      final batch = db.batch();
      for (var p in products) {
        batch.insert('products', p);
      }
      await batch.commit(noResult: true);
      debugPrint('✅ Inserted ${products.length} products');

      // ---------- OFFERS ----------
      final offers = [
        {
          'title': 'تصميم موقع إلكتروني',
          'description': 'تصميم موقع احترافي متكامل',
          'price': 5000.0,
          'company': 'شركة التقنية',
          'type': 'urgent',
          'deliveryTime': '5 أيام',
          'reviewCount': 24,
          'rating': 4.5,
        },
        {
          'title': 'تطوير تطبيق موبايل',
          'description': 'تطبيق iOS و Android',
          'price': 8000.0,
          'company': 'المبرمجون',
          'type': 'normal',
          'deliveryTime': '15 يوم',
          'reviewCount': 18,
          'rating': 4.8,
        },
      ];
      
      final offersBatch = db.batch();
      for (var o in offers) {
        offersBatch.insert('offers', o);
      }
      await offersBatch.commit(noResult: true);
      debugPrint('✅ Inserted ${offers.length} offers');

      // ---------- PACKS ----------
      final packs = [
        {
          'name': 'الباقة الأساسية',
          'price': 199.0,
          'description': 'مثالية للأفراد',
          'features': 'دعم فني|استضافة مجانية',
          'duration': 'شهري',
          'isPopular': 0,
        },
        {
          'name': 'الباقة الذهبية',
          'price': 499.0,
          'description': 'الأكثر شعبية',
          'features': 'كل المميزات|تحليلات متقدمة',
          'duration': 'شهري',
          'isPopular': 1,
        },
      ];
      
      final packsBatch = db.batch();
      for (var pk in packs) {
        packsBatch.insert('packs', pk);
      }
      await packsBatch.commit(noResult: true);
      debugPrint('✅ Inserted ${packs.length} packs');
      
      debugPrint('🎉 Seed data insertion completed successfully');
    } catch (e, stackTrace) {
      debugPrint('❌ Error inserting seed data: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  // ==================== PRODUCTS CRUD ====================

  /// Insert a new product into the database
  Future<int> insertProduct(Product product) async {
    try {
      final db = await database;
      final id = await db.insert('products', product.toMap());
      debugPrint('➕ Inserted product: ${product.name} (ID: $id)');
      return id;
    } catch (e) {
      debugPrint('❌ Error inserting product: $e');
      rethrow;
    }
  }

  /// Get all products from the database
  Future<List<Product>> getAllProducts() async {
    try {
      final db = await database;
      final result = await db.query('products', orderBy: 'id DESC');
      final products = result.map((e) => Product.fromMap(e)).toList();
      debugPrint('✅ Loaded ${products.length} products');
      return products;
    } catch (e) {
      debugPrint('❌ Error loading products: $e');
      rethrow;
    }
  }

  /// Update an existing product
  Future<int> updateProduct(Product product) async {
    try {
      final db = await database;
      final count = await db.update(
        'products',
        product.toMap(),
        where: 'id = ?',
        whereArgs: [product.id],
      );
      debugPrint('✏️ Updated product: ${product.name} (ID: ${product.id})');
      return count;
    } catch (e) {
      debugPrint('❌ Error updating product: $e');
      rethrow;
    }
  }

  /// Delete a product by ID
  Future<int> deleteProduct(int id) async {
    try {
      final db = await database;
      final count = await db.delete('products', where: 'id = ?', whereArgs: [id]);
      debugPrint('🗑️ Deleted product (ID: $id)');
      return count;
    } catch (e) {
      debugPrint('❌ Error deleting product: $e');
      rethrow;
    }
  }

  // ==================== OFFERS CRUD ====================

  /// Get all offers from the database
  Future<List<Map<String, dynamic>>> getAllOffers() async {
    try {
      final db = await database;
      final result = await db.query('offers', orderBy: 'id DESC');
      debugPrint('✅ Loaded ${result.length} offers');
      return result;
    } catch (e) {
      debugPrint('❌ Error loading offers: $e');
      rethrow;
    }
  }

  /// Insert a new offer
  Future<int> insertOffer(Map<String, dynamic> offer) async {
    try {
      final db = await database;
      final id = await db.insert('offers', offer);
      debugPrint('➕ Inserted offer (ID: $id)');
      return id;
    } catch (e) {
      debugPrint('❌ Error inserting offer: $e');
      rethrow;
    }
  }

  /// Update an existing offer
  Future<int> updateOffer(int id, Map<String, dynamic> offer) async {
    try {
      final db = await database;
      final count = await db.update('offers', offer, where: 'id = ?', whereArgs: [id]);
      debugPrint('✏️ Updated offer (ID: $id)');
      return count;
    } catch (e) {
      debugPrint('❌ Error updating offer: $e');
      rethrow;
    }
  }

  /// Delete an offer by ID
  Future<int> deleteOffer(int id) async {
    try {
      final db = await database;
      final count = await db.delete('offers', where: 'id = ?', whereArgs: [id]);
      debugPrint('🗑️ Deleted offer (ID: $id)');
      return count;
    } catch (e) {
      debugPrint('❌ Error deleting offer: $e');
      rethrow;
    }
  }

  // ==================== PACKS CRUD ====================

  /// Get all subscription packs from the database
  Future<List<Map<String, dynamic>>> getAllPacks() async {
    try {
      final db = await database;
      final result = await db.query('packs', orderBy: 'id ASC');
      debugPrint('✅ Loaded ${result.length} packs');
      return result;
    } catch (e) {
      debugPrint('❌ Error loading packs: $e');
      rethrow;
    }
  }

  /// Insert a new subscription pack
  Future<int> insertPack(Map<String, dynamic> pack) async {
    try {
      final db = await database;
      final id = await db.insert('packs', pack);
      debugPrint('➕ Inserted pack (ID: $id)');
      return id;
    } catch (e) {
      debugPrint('❌ Error inserting pack: $e');
      rethrow;
    }
  }

  // ==================== DATABASE MANAGEMENT ====================

  /// Reset database (delete and recreate)
  /// ⚠️ WARNING: This will delete all data!
  /// Use only for development/testing
  Future<void> resetDatabase() async {
    try {
      debugPrint('🔄 Resetting database...');

      // ✅ Get database path based on platform
      String dbPath;
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        dbPath = await ffi.databaseFactoryFfi.getDatabasesPath();
      } else {
        dbPath = await getDatabasesPath();
      }

      final path = join(dbPath, 'marketplace.db');

      // ✅ Close existing connection
      if (_database != null) {
        await _database!.close();
        _database = null;
      }

      // ✅ Delete database file
      await deleteDatabase(path);
      debugPrint('🧹 Database deleted: $path');

      // ✅ Reinitialize database
      await database;
      debugPrint('✅ Database reset complete');
    } catch (e, stackTrace) {
      debugPrint('❌ Error resetting database: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Close database connection
  Future<void> close() async {
    try {
      if (_database != null) {
        await _database!.close();
        _database = null;
        debugPrint('✅ Database connection closed');
      }
    } catch (e) {
      debugPrint('❌ Error closing database: $e');
      rethrow;
    }
  }
}
