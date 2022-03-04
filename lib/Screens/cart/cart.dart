import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mystoreapp/Screens/cart/cart_empty.dart';
import 'package:mystoreapp/Screens/cart/cart_full.dart';

import 'package:mystoreapp/provider/cart_provider.dart';
import 'package:mystoreapp/services/global_method.dart';
import 'package:mystoreapp/services/payment.dart';
import 'package:mystoreapp/services/paystackPayments.dart';

import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class Cart extends StatefulWidget {
  static const routeName = '/Cart';

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  String? email = "gbengs.tlg@gmail.com";
  final plugin = PaystackPlugin();

  @override
  void initState() {
    super.initState();

    StripeService.init();
  }

  void payWithCard({int? amount}) async {
    ProgressDialog dialog = ProgressDialog(context);
    dialog.style(message: 'Please wait...');
    await dialog.show();
    var response = await StripeService.payWithNewCard(
        currency: 'USD', amount: amount.toString());
    await dialog.hide();
    print('response : ${response.message}');
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(response.message),
      duration: Duration(milliseconds: response.success == true ? 1200 : 3000),
    ));
  }

  GlobalMethods globalMethods = GlobalMethods();
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final subTotal = cartProvider.totalAmount;

    // ignore: prefer_is_not_empty
    return cartProvider.getCartItems.isEmpty
        ? Scaffold(body: CartEmpty())
        : Scaffold(
            bottomSheet: checkoutSection(context, cartProvider.totalAmount),
            appBar: AppBar(
              backgroundColor: Theme.of(context).backgroundColor,
              title: Text('Cart (${cartProvider.getCartItems.length})'),
              actions: [
                IconButton(
                  onPressed: () {
                    globalMethods.showDialogg(
                        'Remove item!',
                        'All items will be removed from the cart!',
                        () => cartProvider.clearCart(),
                        context);
                  },
                  icon: FaIcon(FontAwesomeIcons.trash),
                )
              ],
            ),
            body: Container(
              margin: EdgeInsets.only(bottom: 60),
              child: ListView.builder(
                  itemCount: cartProvider.getCartItems.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    return ChangeNotifierProvider.value(
                      value: cartProvider.getCartItems.values.toList()[index],
                      child: CartFull(
                        productId:
                            cartProvider.getCartItems.keys.toList()[index],
                        // id: cartProvider.getCartItems.values.toList()[index].id,
                        // productId: cartProvider.getCartItems.keys.toList()[index],
                        // price: cartProvider.getCartItems.values
                        //     .toList()[index]
                        //     .price,
                        // title: cartProvider.getCartItems.values
                        //     .toList()[index]
                        //     .title,
                        // imageUrl: cartProvider.getCartItems.values
                        //     .toList()[index]
                        //     .imageUrl,
                        // quatity: cartProvider.getCartItems.values
                        //     .toList()[index]
                        //     .quantity,
                      ),
                    );
                  }),
            ));
  }

  Widget checkoutSection(BuildContext ctx, double subtotal) {
    var uuid = Uuid();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final cartProvider = Provider.of<CartProvider>(context);
    //final response = plugin.chargeCard(context, charge: Charge());

    return Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey, width: 0.5),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            /// mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Material(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.red,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () async {
                      MakePayment(
                              ctx: context,
                              totalAmount: subtotal.toInt(),
                              email: email!)
                          .chargeCardAndMakePayment();
                      // double amountInCents = subtotal * 1000;
                      // int intengerAmount = (amountInCents / 10).ceil();
                      // payWithCard(amount: intengerAmount);

                      if (CheckoutResponse.defaults().status = true) {
                        User? user = _auth.currentUser;
                        final _uid = user!.uid;
                        cartProvider.getCartItems
                            .forEach((key, orderValue) async {
                          final orderId = uuid.v4();
                          try {
                            await FirebaseFirestore.instance
                                .collection('order')
                                .doc(orderId)
                                .set({
                              'orderId': orderId,
                              'userId': _uid,
                              'productId': orderValue.productId,
                              'title': orderValue.title,
                              'price': orderValue.price * orderValue.quantity,
                              'imageUrl': orderValue.imageUrl,
                              'quantity': orderValue.quantity,
                              'orderDate': Timestamp.now(),
                            });
                          } catch (err) {
                            print("error occured  $err");
                          }
                        });
                      } else {
                        globalMethods.authErrorHandle(
                            "Please enter your true information", context);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Checkout',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(ctx).primaryColorDark,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ),
              Spacer(),
              Text(
                'Total:',
                style: TextStyle(
                    color: Theme.of(ctx).primaryColorDark,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                'US ${subtotal.toStringAsFixed(3)}',
                //textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ));
  }
}
