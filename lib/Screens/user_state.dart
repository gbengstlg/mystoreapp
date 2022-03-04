import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mystoreapp/Screens/landing_page.dart';
import 'package:mystoreapp/Screens/main_screen.dart';

class UserState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (userSnapshot.connectionState == ConnectionState.active) {
          if (userSnapshot.hasData) {
            print('The user is already logged in');
            return MainScreens();
          } else {
            print('The user didn\'t login yet');
            return LandingPage();
          }
        } else if (userSnapshot.hasError) {
          return Center(
            child: Text('Error occured'),
          );
        }
        return Center(
          child: Text('Unknown error'),
        );
      },
    );
  }
}
