import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:mystoreapp/Screens/Feeds.dart';
import 'package:mystoreapp/Screens/auth/forgot_Password.dart';
import 'package:mystoreapp/Screens/auth/login.dart';
import 'package:mystoreapp/Screens/auth/sign_up.dart';
import 'package:mystoreapp/Screens/bottom_bar.dart';

import 'package:mystoreapp/Screens/user_state.dart';

import 'package:mystoreapp/Screens/wishlist/wishlist.dart';
import 'package:mystoreapp/const/theme_data.dart';
import 'package:mystoreapp/inner_screens/categories_feeds.dart';
import 'package:mystoreapp/inner_screens/product_details.dart';
import 'package:mystoreapp/Screens/upload_product_form.dart';

import 'package:mystoreapp/provider/cart_provider.dart';

import 'package:mystoreapp/provider/dark_theme_provider.dart';
import 'package:mystoreapp/provider/favs_provider.dart';
import 'package:mystoreapp/provider/orders_provider.dart';
import 'package:mystoreapp/provider/products.dart';
import 'package:provider/provider.dart';

import 'Screens/cart/cart.dart';
import 'Screens/orders/orders.dart';
import 'inner_screens/brands_navigation_rail.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreferences.getTheme();
  }

  @override
  // ignore: override_on_non_overriding_member
  void initstate() {
    getCurrentAppTheme();
    super.initState();
  }

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MaterialApp(
              home: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            MaterialApp(
              home: Scaffold(
                body: Center(
                  child: Text("Error occured"),
                ),
              ),
            );
          }

          return MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) {
                  return themeChangeProvider;
                }),
                ChangeNotifierProvider(
                  create: (_) => Products(),
                ),
                ChangeNotifierProvider(
                  create: (_) => CartProvider(),
                ),
                ChangeNotifierProvider(
                  create: (_) => FavsProvider(),
                ),
                ChangeNotifierProvider(
                  create: (_) => OrdersProvider(),
                ),
              ],
              child: Consumer<DarkThemeProvider>(
                  builder: (context, themeData, child) {
                return MaterialApp(
                  title: 'Flutter Demo',
                  debugShowCheckedModeBanner: false,
                  theme:
                      Styles.themeData(themeChangeProvider.darkTheme, context),
                  home: UserState(),
                  routes: {
                    BrandNavigationRailScreen.routeName: (ctx) =>
                        const BrandNavigationRailScreen(),
                    Feeds.routeName: (ctx) => Feeds(),
                    Cart.routeName: (ctx) => Cart(),
                    WishlistScreen.routeName: (ctx) => WishlistScreen(),
                    ProductDetails.routeName: (ctx) => ProductDetails(),
                    CategoriesFeedsScreen.routeName: (ctx) =>
                        CategoriesFeedsScreen(),
                    LoginScreen.routeName: (ctx) => LoginScreen(),
                    SignUpScreen.routeName: (ctx) => SignUpScreen(),
                    BottomBarScreen.routeName: (ctx) => BottomBarScreen(),
                    UploadProductForm.routeName: (ctx) => UploadProductForm(),
                    ForgotPassword.routeName: (ctx) => ForgotPassword(),
                    OrdersScreen.routeName: (ctx) => OrdersScreen(),
                  },
                );
              }));
        });
  }
}
