import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/model/item_model.dart';
import 'package:user_app/model/menu_model.dart';
import 'package:user_app/view/cart_screen/cart_screen.dart';
import 'package:user_app/viewModel/add_to_cart_view_model/add_to_cart_view_model.dart';
import 'package:user_app/widget/items_design.dart';
import 'package:user_app/widget/progress_dialog.dart';

class ItemScreen extends StatelessWidget {
  final MenuModel? model;
  const ItemScreen({super.key, this.model});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Colors.cyan,
                  Colors.amber,
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>  CartScreen(sellerUID: model!.sellerId,)));
                  },
                  icon: const Icon(
                    Icons.shopping_cart,
                    color: Colors.cyan,
                  )),
              const Positioned(
                right: 0,
                child: Icon(
                  Icons.brightness_1,
                  size: 20.0,
                  color: Colors.green,
                ),
              ),
              Consumer<AddToCartViewModel>(
                builder: (context, value, _) => Positioned(
                  right: 6,
                  child: Center(
                    child: Text(
                      value.cartCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
        title: const Text(
          "iFood",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontFamily: "Signatra",
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: kToolbarHeight,
              child: Center(
                  child: Text(
                "${model!.menuTitle} Items",
                style: const TextStyle(
                  shadows: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 2.0,
                      offset: Offset(1, 2),
                      spreadRadius: 15.0,
                    )
                  ],
                  fontSize: 20,
                  color: Colors.black,
                  fontFamily: "Lobster",
                ),
              )),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("sellers")
                      .doc(model!.sellerId)
                      .collection("menus")
                      .doc(model!.menuID)
                      .collection("items")
                      .orderBy("publishedDate", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: circularProgress(),
                      );
                    } else {
                      return ListView.builder(
                        itemBuilder: (context, index) {
                          ItemModel menuModel = ItemModel.fromJson(
                              snapshot.data!.docs[index].data()
                                  as Map<String, dynamic>);
                          return ItemDesign(
                            model: menuModel,
                          );
                        },
                        itemCount: snapshot.data!.docs.length,
                      );
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}
