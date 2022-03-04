import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:list_tile_switch/list_tile_switch.dart';
import 'package:mystoreapp/Screens/cart/cart.dart';
import 'package:mystoreapp/Screens/orders/orders.dart';

import 'package:mystoreapp/Screens/wishlist/wishlist.dart';
import 'package:mystoreapp/const/colors.dart';
import 'package:mystoreapp/const/my_icon.dart';
import 'package:mystoreapp/provider/dark_theme_provider.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class UserInfo extends StatefulWidget {
  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  late ScrollController _scrollController;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var top = 0.0;

  String? _uid;
  String? _name;
  String? _email;
  String? _joinedAt;
  int? _phoneNumber;
  String? _userImageUrl;
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      setState(() {});
    });
    getData();
  }

  void getData() async {
    User? user = _auth.currentUser;
    _uid = user!.uid;

    print('user.displayName ${user.displayName}');
    print('user.photoUrl ${user.photoURL}');
    if (user.isAnonymous)
      return;
    else {
      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(_uid).get();
      if (userDoc == null) {
        return null;
      } else {
        setState(() {
          _name = userDoc.get('name');
          _email = user.email;
          _joinedAt = userDoc.get('joinedAt');
          _phoneNumber = userDoc.get('phoneNumber');
          _userImageUrl = userDoc.get('imageUrl');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
        body: Stack(
      children: [
        CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: false,
              elevation: 4,
              expandedHeight: 200,
              pinned: true,
              flexibleSpace: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                top = constraints.biggest.height;
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          ColorsConsts.starterColor,
                          ColorsConsts.endColor,
                        ],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(1.0, 0.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  child: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    centerTitle: true,
                    title: Row(
                      //  mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AnimatedOpacity(
                          duration: Duration(milliseconds: 300),
                          opacity: top <= 110.0 ? 1.0 : 0,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 12,
                              ),
                              Container(
                                height: kToolbarHeight / 1.8,
                                width: kToolbarHeight / 3.0,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white,
                                      blurRadius: 1.0,
                                    ),
                                  ],
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.none,
                                    image: NetworkImage(_userImageUrl ??
                                        'https://cdn1.vectorstock.com/i/thumb-large/62/60/default-avatar-photo-placeholder-profile-image-vector-21666260.jpg'),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Text(
                                // 'top.toString()',
                                _name ?? 'Guest',
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    background: Image(
                      image: NetworkImage(_userImageUrl ??
                          'https://cdn1.vectorstock.com/i/thumb-large/62/60/default-avatar-photo-placeholder-profile-image-vector-21666260.jpg'),
                      fit: BoxFit.fill,
                    ),
                  ),
                );
              }),
            ),
            SliverToBoxAdapter(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: userTitle("User Bag"),
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.grey,
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: Theme.of(context).splashColor,
                      child: ListTile(
                        onTap: () => Navigator.of(context)
                            .pushNamed(WishlistScreen.routeName),
                        title: Text('WishList'),
                        trailing: FaIcon(FontAwesomeIcons.chevronRight),
                        leading: Icon(MyAppIcon.wishlist),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: Theme.of(context).splashColor,
                      child: ListTile(
                        onTap: () =>
                            Navigator.of(context).pushNamed(Cart.routeName),
                        title: Text('Cart'),
                        trailing: FaIcon(FontAwesomeIcons.chevronRight),
                        leading: Icon(MyAppIcon.cart),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: Theme.of(context).splashColor,
                      child: ListTile(
                        onTap: () => Navigator.of(context)
                            .pushNamed(OrdersScreen.routeName),
                        title: Text('Orders'),
                        trailing: FaIcon(FontAwesomeIcons.chevronRight),
                        leading: Icon(MyAppIcon.cart),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: userTitle("User Information"),
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.grey,
                  ),
                  userListTile('Email', _email ?? '', 0, context),
                  userListTile(
                      'Phone Number', _phoneNumber.toString(), 1, context),
                  userListTile('Shipping address', 'address', 2, context),
                  userListTile('Joined Date', _joinedAt ?? '', 3, context),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: userTitle("User Settings"),
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.grey,
                  ),
                  ListTileSwitch(
                    value: themeChange.darkTheme,
                    leading: FaIcon(FontAwesomeIcons.moon),
                    onChanged: (value) {
                      setState(() {
                        themeChange.darkTheme = value;
                      });
                    },
                    visualDensity: VisualDensity.comfortable,
                    switchType: SwitchType.cupertino,
                    switchActiveColor: Colors.indigo,
                    title: Text('Dark Theme'),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: Theme.of(context).splashColor,
                      child: ListTile(
                        onTap: () async {
                          // Navigator.canPop(context)
                          //     ? Navigator.pop(context)
                          //     // ignore: unnecessary_statements
                          //     : null;
                          showDialog(
                              context: context,
                              builder: (BuildContext ctx) {
                                return AlertDialog(
                                  title: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 6.0),
                                        child: Image.network(
                                          'https://image.flaticon.com/icons/png/128/564/564619.png',
                                          height: 20,
                                          width: 20,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('Sign Out'),
                                      ),
                                    ],
                                  ),
                                  content: Text(
                                      'Are you sure you want to sign out?'),
                                  actions: [
                                    TextButton(
                                        onPressed: () async {
                                          Navigator.pop(context);
                                        },
                                        child: Text('cancel')),
                                    TextButton(
                                        onPressed: () async {
                                          await _auth.signOut().then(
                                                (value) =>
                                                    Navigator.pop(context),
                                              );
                                        },
                                        child: Text(
                                          'Ok',
                                          style: TextStyle(color: Colors.red),
                                        ))
                                  ],
                                );
                              });
                        },
                        title: Text("Log Out"),
                        leading: Icon(Icons.exit_to_app_rounded),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        _buildFab()
      ],
    ));
  }

  Widget _buildFab() {
    //starting fab position
    final double defaultTopMargin = 200.0 - 4.0;
    //pixels from top where scaling should start
    final double scaleStart = 160.0;
    //pixels from top where scaling should end
    final double scaleEnd = scaleStart / 2;

    double top = defaultTopMargin;
    double scale = 1.0;
    if (_scrollController.hasClients) {
      double offset = _scrollController.offset;
      top -= offset;
      if (offset < defaultTopMargin - scaleStart) {
        //offset small => don't scale down
        scale = 1.0;
      } else if (offset < defaultTopMargin - scaleEnd) {
        //offset between scaleStart and scaleEnd => scale down
        scale = (defaultTopMargin - scaleEnd - offset) / scaleEnd;
      } else {
        //offset passed scaleEnd => hide fab
        scale = 0.0;
      }
    }

    return Positioned(
      top: top,
      right: 16.0,
      child: Transform(
        transform: Matrix4.identity()..scale(scale),
        alignment: Alignment.center,
        child: FloatingActionButton(
          backgroundColor: Colors.purple,
          heroTag: "btn1",
          onPressed: () {},
          child: Icon(Icons.camera_alt_outlined),
        ),
      ),
    );
  }

  List<IconData> _userTileIcons = [
    Icons.email,
    Icons.phone,
    Icons.local_shipping,
    Icons.watch_later,
    Icons.exit_to_app_rounded,
  ];

  Widget userListTile(
      String title, String subTitle, int index, BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Theme.of(context).splashColor,
        child: ListTile(
          onTap: () {},
          title: Text(title),
          subtitle: Text(subTitle),
          leading: Icon(_userTileIcons[index]),
        ),
      ),
    );
  }

  Widget userTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
      ),
    );
  }
}
