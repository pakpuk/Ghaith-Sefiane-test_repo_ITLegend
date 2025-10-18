
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketplace_app/cubit/app_cubit.dart';
import 'package:marketplace_app/cubit/app_state.dart';
import 'package:marketplace_app/cubit/cubits/offers_cubit.dart';
import 'package:marketplace_app/cubit/cubits/plans_cubit.dart';
import 'package:marketplace_app/cubit/cubits/products_cubit.dart';
import 'package:marketplace_app/db/database.dart';
import 'package:marketplace_app/view/screens/filter_screen.dart';
import 'package:marketplace_app/view/screens/offerscreen.dart';
import 'package:marketplace_app/view/screens/palce_holde_pages.dart';
import 'package:marketplace_app/view/screens/plans_selected_screen.dart';
import 'package:marketplace_app/view/screens/product_screen.dart';

/// Main entry point
/// Ensures Flutter bindings and database factory are initialized before app starts
void main() {
  // ✅ Initialize Flutter bindings
  WidgetsFlutterBinding.ensureInitialized();
  
  // ✅ Initialize database factory for desktop platforms (Windows/Linux/macOS)
  DatabaseHelper.initializeDatabaseFactory();
  
  // ✅ Run the app
  runApp(const MarketplaceApp());
}

/// Main Application Widget with Cubit Providers
/// Entry point with RTL support and Arabic localization
/// Uses AppCubit to ensure database is initialized before UI renders
class MarketplaceApp extends StatelessWidget {
  const MarketplaceApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ✅ Provide all Cubits at the root level
    return MultiBlocProvider(
      providers: [
        // ✅ AppCubit - Manages global app state and initialization
        BlocProvider(
          create: (context) => AppCubit(DatabaseHelper.instance)..initialize(),
        ),

        // ✅ Products Cubit - Manages product listing and filtering
        BlocProvider(
          create: (context) => ProductsCubit(DatabaseHelper.instance),
        ),

        // ✅ Offers Cubit - Manages service offers
        BlocProvider(
          create: (context) => OffersCubit(DatabaseHelper.instance),
        ),

        // ✅ Plans Cubit - Manages subscription plans selection
        BlocProvider(
          create: (context) => PlansCubit(),
        ),
      ],
      child: const AppView(),
    );
  }
}

/// AppView - Renders the MaterialApp after initialization
/// Waits for AppCubit to complete database initialization
class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ✅ Listen to AppCubit state to ensure DB is ready
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        // Show loading screen while initializing
        if (state is AppLoading || state is AppInitial) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Directionality(
              textDirection: TextDirection.rtl,
              child: _LoadingScreen(),
            ),
          );
        }

        // Show error screen if initialization failed
        if (state is AppError) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Directionality(
              textDirection: TextDirection.rtl,
              child: _ErrorScreen(message: state.message),
            ),
          );
        }

        // ✅ App is ready - render the main app
        return MaterialApp(
      title: 'Marketplace App',
      debugShowCheckedModeBanner: false,
      
      // Localization Configuration
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', 'EG'),
        Locale('en', 'US'),
      ],
      locale: const Locale('ar', 'EG'),
      
      // Theme Configuration
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF005BFF), // Primary blue
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        
        // Typography with Cairo font for Arabic
        textTheme: GoogleFonts.cairoTextTheme(
          ThemeData.light().textTheme,
        ),
        
        // AppBar Theme
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black87),
          titleTextStyle: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        // Card Theme
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        
        // Input Decoration Theme
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF005BFF), width: 2),
          ),
        ),
        
        // Button Theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
      
      // Routes with RTL wrapper
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: ProductsPage(),
      ),
      // ✅ Named routes with RTL wrapper
          routes: {
            '/filter': (context) => const Directionality(
                  textDirection: TextDirection.rtl,
                  child: FilterPage(),
                ),
            '/offers': (context) => const Directionality(
                  textDirection: TextDirection.rtl,
                  child: OffersPage(),
                ),
            '/plans': (context) => const Directionality(
                  textDirection: TextDirection.rtl,
                  child: PlansPage(),
                ),
            '/chat': (context) => const Directionality(
                  textDirection: TextDirection.rtl,
                  child: PlaceholderChatPage(),
                ),
            '/myads': (context) => const Directionality(
                  textDirection: TextDirection.rtl,
                  child: MyAdsPage(),
                ),
          },
        );
      },
    );
  }
}

// ==================== HELPER SCREENS ====================

/// Loading Screen - Shown during app initialization
class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo or icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF005BFF).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_bag_rounded,
                size: 40,
                color: Color(0xFF005BFF),
              ),
            ),
            const SizedBox(height: 24),
            // Loading indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF005BFF)),
            ),
            const SizedBox(height: 16),
            // Loading text
            Text(
              'جاري تحميل التطبيق...',
              style: GoogleFonts.cairo(
                fontSize: 16,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Error Screen - Shown if initialization fails
class _ErrorScreen extends StatelessWidget {
  final String message;

  const _ErrorScreen({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Error icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline,
                  size: 40,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 24),
              // Error title
              Text(
                'حدث خطأ',
                style: GoogleFonts.cairo(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              // Error message
              Text(
                message,
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              // Retry button
              ElevatedButton(
                onPressed: () {
                  // Retry initialization
                  context.read<AppCubit>().initialize();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF005BFF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'إعادة المحاولة',
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}