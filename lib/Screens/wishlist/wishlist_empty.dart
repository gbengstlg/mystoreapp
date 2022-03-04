import 'package:flutter/material.dart';
import 'package:mystoreapp/Screens/Feeds.dart';
import 'package:mystoreapp/const/colors.dart';
import 'package:mystoreapp/provider/dark_theme_provider.dart';
import 'package:provider/provider.dart';

class WishlistEmpty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 80),
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.4,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage('assets/images/emptyWishlist.jpg'),
            ),
          ),
        ),
        Text(
          'Your WishList Is Empty',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Theme.of(context).primaryColorLight,
              fontSize: 36,
              fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          'Explore more and shotlist some items',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: themeChange.darkTheme
                  ? Theme.of(context).disabledColor
                  : ColorsConsts.subTitle,
              fontSize: 20,
              fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: 30,
        ),
        Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.06,
            child: TextButton(
              onPressed: () =>
                  {Navigator.of(context).pushNamed(Feeds.routeName)},
              style: TextButton.styleFrom(
                primary: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.red),
                ),
              ),
              child: Text(
                'Add a Wish'.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).primaryColorLight,
                    fontSize: 20,
                    fontWeight: FontWeight.w400),
              ),
            )),
      ],
    );
  }
}
