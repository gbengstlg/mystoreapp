import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';

import 'package:mystoreapp/const/key.dart';

class MakePayment {
  MakePayment({
    required this.ctx,
    required this.totalAmount,
    required this.email,
  });

  BuildContext ctx;

  int totalAmount;

  String email;

  PaystackPlugin paystack = PaystackPlugin();

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  PaymentCard _getCardUI() {
    return PaymentCard(number: '', cvc: '', expiryMonth: 0, expiryYear: 0);
  }

  Future initializePlugin() async {
    await paystack.initialize(publicKey: ConstantKey.PAYSTACK_KEY);
  }

  chargeCardAndMakePayment() async {
    initializePlugin().then((_) async {
      Charge charge = Charge()
        ..amount = this.totalAmount * 100
        ..email = this.email
        ..reference = _getReference()
        ..card = _getCardUI();

      CheckoutResponse response = await paystack.checkout(ctx,
          charge: charge,
          method: CheckoutMethod.card,
          fullscreen: false,
          logo: FlutterLogo(
            size: 24,
          ));

      print("Response $response");
      if (response.status == true) {
        print("Transaction Successful");
      } else
        print("Transaction Failed");
    });
  }
}
