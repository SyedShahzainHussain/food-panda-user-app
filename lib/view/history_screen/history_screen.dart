import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/global/global.dart';
import 'package:user_app/viewModel/add_to_cart_view_model/add_to_cart_view_model.dart';
import 'package:user_app/widget/order_card_widget.dart';
import 'package:user_app/widget/progress_dialog.dart';

import '../../widget/my_drawer.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.cyan, Colors.amber],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
        ),
        title: const Text(
          "Order",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontFamily: "Signatra",
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(sharedPreferences!.getString("uid"))
              .collection("orders")
              .where("status", isEqualTo: "ended")
              .orderBy("orderTime", descending: true)
              .snapshots(),
          builder: (c, snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    itemBuilder: (context, index) {
                      return FutureBuilder<QuerySnapshot>(
                          future: FirebaseFirestore.instance
                              .collection("items")
                              .where("itemID",
                                  whereIn: context
                                      .read<AddToCartViewModel>()
                                      .separateOrderItemsIds(snapshot
                                          .data!.docs[index]
                                          .data()["productsIDs"]))
                              .where("orderBy",
                                  whereIn: (snapshot.data!.docs[index]
                                      .data())["userId"])
                              .orderBy("publishedDate", descending: true)
                              .get(),
                          builder: (context, snapshot2) {
                            return snapshot2.hasData
                                ? OrderWidget(
                                    itemCount: snapshot2.data!.docs.length,
                                    orderId: snapshot.data!.docs[index].id,
                                    data: snapshot2.data!.docs,
                                    separateQuantitiesList: context
                                        .read<AddToCartViewModel>()
                                        .separateOrderQuantity(snapshot
                                            .data!.docs[index]
                                            .data()["productsIDs"]),
                                  )
                                : const SizedBox.shrink();
                          });
                    },
                    itemCount: snapshot.data!.docs.length,
                  )
                : Center(
                    child: circularProgress(),
                  );
          }),
    );
  }
}
