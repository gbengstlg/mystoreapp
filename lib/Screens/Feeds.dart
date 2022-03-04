import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:mystoreapp/Screens/cart/cart.dart';

import 'package:mystoreapp/Screens/wishlist/wishlist.dart';
import 'package:mystoreapp/const/colors.dart';
import 'package:mystoreapp/const/my_icon.dart';

import 'package:mystoreapp/models/products.dart';
import 'package:mystoreapp/provider/cart_provider.dart';
import 'package:mystoreapp/provider/favs_provider.dart';
import 'package:mystoreapp/provider/products.dart';
import 'package:mystoreapp/widgets/feeds_products.dart';

import 'package:provider/provider.dart';

class Feeds extends StatelessWidget {
  static const routeName = '/Feeds';
  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<Products>(context);
    final popular = ModalRoute.of(context)!.settings.arguments;
    List<Product>? productsList = productsProvider.products;

    if (popular == 'popular') {
      productsList = productsProvider.popularProducts;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        title: Text('Feeds'),
        actions: [
          Consumer<FavsProvider>(
            builder: (_, favs, ch) => Badge(
              badgeColor: ColorsConsts.cartBadgeColor,
              animationType: BadgeAnimationType.slide,
              toAnimate: true,
              position: BadgePosition.topEnd(top: 5, end: 7),
              badgeContent: Text(
                favs.getFavsItems.length.toString(),
                style: TextStyle(color: Colors.white),
              ),
              child: IconButton(
                icon: Icon(
                  MyAppIcon.wishlist,
                  color: ColorsConsts.favColor,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(WishlistScreen.routeName);
                },
              ),
            ),
          ),
          Consumer<CartProvider>(
            builder: (_, cart, ch) => Badge(
              badgeColor: ColorsConsts.cartBadgeColor,
              animationType: BadgeAnimationType.slide,
              toAnimate: true,
              position: BadgePosition.topEnd(top: 5, end: 7),
              badgeContent: Text(
                cart.getCartItems.length.toString(),
                style: TextStyle(color: Colors.white),
              ),
              child: IconButton(
                icon: Icon(
                  MyAppIcon.cart,
                  color: ColorsConsts.cartColor,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(Cart.routeName);
                },
              ),
            ),
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 240 / 470,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        children: List.generate(productsList.length, (index) {
          return ChangeNotifierProvider.value(
            value: productsList![index],
            child: FeedProducts(),
          );
        }),
      ),

      // body: StaggeredGridView.countBuilder(
      //   crossAxisCount: 6,
      //   itemCount: 8,
      //   itemBuilder: (BuildContext context, int index) => FeedProducts(

      //   ),
      //   staggeredTileBuilder: (int index) =>
      //       new StaggeredTile.count(3, index.isEven ? 4 : 5),
      //   mainAxisSpacing: 8.0,
      //   crossAxisSpacing: 6.0,
      // ),
    );
  }
}
