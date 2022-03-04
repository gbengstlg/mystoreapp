import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:mystoreapp/provider/orders_provider.dart';
import 'package:mystoreapp/services/global_method.dart';
import 'package:provider/provider.dart';

import 'orders_empty.dart';
import 'orders_full.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/OrdersScreen';

  @override
  _OrdersScreensState createState() => _OrdersScreensState();
}

class _OrdersScreensState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    GlobalMethods globalMethods = GlobalMethods();
    final orderProvider = Provider.of<OrdersProvider>(context);
    //final orderAttrProvider = Provider.of<OrdersAttr>(context);

    return FutureBuilder(
        future: orderProvider.fetchOrders(),
        builder: (context, snapshot) {
          return orderProvider.getOrders.isEmpty
              ? Scaffold(body: OrdersEmpty())
              : Scaffold(
                  appBar: AppBar(
                    backgroundColor: Theme.of(context).backgroundColor,
                    title: Text(
                      '${orderProvider.getOrders.length}',
                    ),
                    actions: [
                      IconButton(
                        onPressed: () {
                          // globalMethods.showDialogg(
                          //     'Remove item!',
                          //     'Order will be deleted!',
                          //     () => FirebaseFirestore.instance
                          //         .collection('order')
                          //         .doc(orderAttrProvider.orderId)
                          //         .delete(),
                          //     context);
                        },
                        icon: FaIcon(FontAwesomeIcons.trash),
                      )
                    ],
                  ),
                  body: Container(
                    margin: EdgeInsets.only(bottom: 60),
                    child: ListView.builder(
                        itemCount: orderProvider.getOrders.length,
                        itemBuilder: (BuildContext ctx, int index) {
                          return ChangeNotifierProvider.value(
                              value: orderProvider.getOrders[index],
                              child: OrdersFull());
                        }),
                  ));
        });
  }
}
