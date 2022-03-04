import 'package:carousel_nullsafety/carousel_nullsafety.dart';
import 'package:flutter/material.dart';
import 'package:backdrop/backdrop.dart';
import 'package:flutter_swiper_tv/flutter_swiper.dart';
import 'package:mystoreapp/Screens/Feeds.dart';
import 'package:mystoreapp/const/colors.dart';
import 'package:mystoreapp/inner_screens/brands_navigation_rail.dart';
import 'package:mystoreapp/provider/products.dart';
import 'package:mystoreapp/widgets/backlayer.dart';

import 'package:mystoreapp/widgets/cartegories.dart';
import 'package:mystoreapp/widgets/popularProduct.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _carouselImages = [
    'assets/images/carousel1.jpg',
    'assets/images/carousel2.jpg',
    'assets/images/carousel3.jpg',
    'assets/images/carousel4.jpg',
  ];
  List _brandImages = [
    'assets/images/adidas.png',
    'assets/images/apple-logo.png',
    'assets/images/channel.jpg',
    'assets/images/ebay.png',
  ];
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final popularItems = productsData.popularProducts;
    productsData.fetchProducts();
    return Scaffold(
      body: Center(
        child: BackdropScaffold(
          frontLayerBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
          headerHeight: MediaQuery.of(context).size.height * 0.25,
          appBar: BackdropAppBar(
            title: Text("Home"),
            leading: BackdropToggleButton(
              icon: AnimatedIcons.menu_home,
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                ColorsConsts.starterColor,
                ColorsConsts.endColor
              ])),
            ),
            actions: <Widget>[
              IconButton(
                iconSize: 15.0,
                padding: EdgeInsets.all(10),
                icon: CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 13,
                    backgroundImage: NetworkImage(
                        'https://cdn1.vectorstock.com/i/thumb-large/62/60/default-avatar-photo-placeholder-profile-image-vector-21666260.jpg'),
                  ),
                ),
                onPressed: () {},
              )
            ],
          ),
          backLayer: BackLayerMenu(),
          frontLayer: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 200.0,
                        width: double.infinity,
                        child: Carousel(
                          boxFit: BoxFit.fitHeight,
                          autoplay: true,
                          animationCurve: Curves.fastOutSlowIn,
                          animationDuration: Duration(milliseconds: 1000),
                          dotSize: 5.0,
                          dotIncreasedColor: Colors.purple,
                          dotBgColor: Colors.black.withOpacity(0.2),
                          dotPosition: DotPosition.bottomCenter,
                          showIndicator: true,
                          indicatorBgPadding: 5.0,
                          images: [
                            ExactAssetImage(_carouselImages[0]),
                            ExactAssetImage(_carouselImages[1]),
                            ExactAssetImage(_carouselImages[2]),
                            ExactAssetImage(_carouselImages[3]),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Categories',
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 20),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 180,
                        child: ListView.builder(
                          itemCount: 7,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext ctx, int index) {
                            return CategoryWidget(
                              index: index,
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Popular Brands',
                                style: TextStyle(
                                    fontWeight: FontWeight.w800, fontSize: 20),
                              ),
                            ),
                            Spacer(),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                  BrandNavigationRailScreen.routeName,
                                  arguments: {
                                    7,
                                  },
                                );
                              },
                              child: Text(
                                'View All',
                                style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                    color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 210,
                        width: MediaQuery.of(context).size.width * 0.95,
                        child: Swiper(
                          itemCount: _brandImages.length,
                          autoplay: true,
                          viewportFraction: 0.8,
                          scale: 0.9,
                          // onTap: (index) {
                          //   Navigator.push(
                          //       context,
                          //       new MaterialPageRoute(
                          //           builder: (context) => ));
                          // },
                          onTap: (index) {
                            Navigator.of(context).pushNamed(
                              BrandNavigationRailScreen.routeName,
                              arguments: {
                                index,
                              },
                            );
                          },
                          itemBuilder: (BuildContext ctx, int index) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                color: Colors.blueGrey,
                                child: Image.asset(
                                  _brandImages[index],
                                  fit: BoxFit.fill,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Popular products',
                                style: TextStyle(
                                    fontWeight: FontWeight.w800, fontSize: 20),
                              ),
                            ),
                            Spacer(),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed(Feeds.routeName,
                                    arguments: 'popular');
                              },
                              child: Text(
                                'View All',
                                style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                    color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 285,
                  margin: EdgeInsets.symmetric(horizontal: 3),
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: popularItems.length,
                      itemBuilder: (BuildContext ctx, int index) {
                        return ChangeNotifierProvider.value(
                            value: popularItems[index],
                            child: PopularProducts());
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
