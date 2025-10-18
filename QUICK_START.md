# 🚀 Quick Start Guide - Marketplace App

## Running the App

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Run the App
```bash
flutter run
```

### 3. What You'll See
1. **Loading Screen** (2-3 seconds) - "جاري تحميل التطبيق..."
2. **ProductsPage** - Home screen with product grid
3. **8 Sample Products** - Pre-loaded from database

---

## 📱 App Navigation

### Home Screen (ProductsPage)
- **Top Bar**: Menu, Title, Notifications
- **Categories**: Horizontal scrollable chips
- **Subcategories**: Icon-based horizontal list
- **Products Grid**: 2-column layout
- **Bottom Nav**: 5 items + FAB

### Bottom Navigation Routes:
1. **العروض** (Offers) - ProductsPage (current)
2. **المحادثات** (Chat) - `/chat` → PlaceholderChatPage
3. **[FAB]** - Add new ad (floating button)
4. **إعلاناتي** (My Ads) - `/myads` → MyAdsPage
5. **حسابي** (Account) - `/plans` → PlansPage

### Other Routes:
- **Filter** - `/filter` → FilterPage
- **Offers** - `/offers` → OffersPage

---

## 🗄️ Database

### Location
- **Android**: `/data/data/com.example.marketplace_app/databases/marketplace.db`
- **iOS**: `Library/Application Support/marketplace.db`

### Tables
1. **products** - 8 sample products (shirts, shoes, watches, etc.)
2. **offers** - 2 sample service offers
3. **packs** - 2 subscription plans

### Seed Data
- Automatically inserted on first launch
- Persists between app restarts
- Won't be duplicated

---

## 🎨 Theme

### Colors
- **Primary**: `#005BFF` (Blue)
- **Background**: `#FAFAFA` (Light Grey)
- **Cards**: White with 2px elevation
- **Border Radius**: 12px everywhere

### Typography
- **Font**: Cairo (Google Fonts)
- **Direction**: RTL (Right-to-Left)
- **Locale**: Arabic (ar_EG)

---

## 🧩 State Management

### Cubits Available

#### 1. AppCubit
```dart
context.read<AppCubit>().initialize();
```
- Manages app initialization
- Ensures database is ready

#### 2. ProductsCubit
```dart
context.read<ProductsCubit>().loadProducts();
context.read<ProductsCubit>().filterByCategory('ملابس', 1);
context.read<ProductsCubit>().toggleFavorite(product);
```

#### 3. OffersCubit
```dart
context.read<OffersCubit>().loadOffers();
context.read<OffersCubit>().filterOffers('urgent');
```

#### 4. PlansCubit
```dart
context.read<PlansCubit>().initialize();
context.read<PlansCubit>().togglePlan(1);
context.read<PlansCubit>().clearSelection();
```

---

## 🔧 Common Tasks

### Add a New Screen

1. Create screen file:
```dart
// lib/view/screens/my_new_screen.dart
class MyNewScreen extends StatelessWidget {
  const MyNewScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('شاشة جديدة')),
      body: const Center(child: Text('محتوى الشاشة')),
    );
  }
}
```

2. Add route in main.dart:
```dart
routes: {
  '/mynew': (context) => const Directionality(
    textDirection: TextDirection.rtl,
    child: MyNewScreen(),
  ),
  // ... other routes
}
```

3. Navigate to it:
```dart
Navigator.pushNamed(context, '/mynew');
```

### Add a New Product

```dart
final newProduct = Product(
  name: 'منتج جديد',
  description: 'وصف المنتج',
  price: 299.0,
  image: '🎁',
  categoryId: 1,
  subcategory: 'ملابس',
  offerType: 'normal',
  location: 'القاهرة',
);

await DatabaseHelper.instance.insertProduct(newProduct);
```

### Reset Database (Development Only)

```dart
// In your code:
await DatabaseHelper.instance.resetDatabase();

// Or via AppCubit:
context.read<AppCubit>().reset();
```

---

## 🐛 Troubleshooting

### App Stuck on Loading Screen
- Check console for database errors
- Ensure `sqflite` package is installed
- Try: `flutter clean && flutter pub get`

### Products Not Showing
- Check if database initialized: Look for "✅ Database opened successfully" in console
- Verify seed data: Look for "✅ Inserted 8 products"
- Check ProductsPage is calling `_loadProducts()`

### RTL Not Working
- Ensure all routes wrapped in `Directionality(textDirection: TextDirection.rtl)`
- Check locale is set to `Locale('ar', 'EG')`

### Theme Not Applied
- Verify `google_fonts` package installed
- Check `GoogleFonts.cairoTextTheme()` in main.dart
- Ensure Material 3 enabled: `useMaterial3: true`

---

## 📦 Dependencies

```yaml
dependencies:
  flutter_bloc: ^8.1.3      # State management
  equatable: ^2.0.5         # Value equality
  sqflite: ^2.3.0           # SQLite database
  path_provider: ^2.1.1     # File paths
  google_fonts: ^6.1.0      # Cairo font
```

---

## 🎯 Next Features to Build

### Easy (1-2 hours)
- [ ] Search bar in ProductsPage
- [ ] Product detail page
- [ ] Favorite products list
- [ ] Sort products (price, date)

### Medium (3-5 hours)
- [ ] User authentication (login/register)
- [ ] Add/Edit product form
- [ ] Image picker for products
- [ ] Settings page

### Advanced (1-2 days)
- [ ] API integration (replace SQLite)
- [ ] Real-time chat
- [ ] Push notifications
- [ ] Payment integration

---

## 📞 Support

If you encounter issues:
1. Check console logs (look for 🔄, ✅, ❌ emojis)
2. Read `ARCHITECTURE_CHANGES.md` for details
3. Verify all files exist in correct locations
4. Run `flutter doctor` to check setup

**Happy coding!** 🎉
