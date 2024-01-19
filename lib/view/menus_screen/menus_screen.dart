import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/model/menu_model.dart';
import 'package:user_app/model/sellers.dart';
import 'package:user_app/viewModel/add_to_cart_view_model/add_to_cart_view_model.dart';
import 'package:user_app/widget/menu_design.dart';
import 'package:user_app/widget/progress_dialog.dart';

class MenusScreen extends StatelessWidget {
  final Sellers? model;
  const MenusScreen({
    super.key,
    this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          "iFood",
          style: TextStyle(
            fontSize: 22,
            color: Colors.white,
            fontFamily: "Signatra",
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<AddToCartViewModel>(
        builder: (context, value, _) => WillPopScope(
          onWillPop: value.cartCount == 0
              ? () {
                  return Future.delayed(const Duration(milliseconds: 1), () {
                    return true;
                  });
                }
              : () async {
                  // Show your dialog here
                  bool pop = await showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Confirmation"),
                        content: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Do you really want to go back?"),
                            Text("Your Cart will be clear."),
                          ],
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: const Text("No"),
                          ),
                          TextButton(
                            onPressed: () {
                              context.read<AddToCartViewModel>().deleteCart();
                              Navigator.of(context).pop(true);
                            },
                            child: const Text("Yes"),
                          ),
                        ],
                      );
                    },
                  );

                  // Return false to prevent the screen from being popped
                  return pop;
                },
          child: SafeArea(
            child: Column(children: [
              SizedBox(
                width: double.infinity,
                height: kToolbarHeight,
                child: Center(
                    child: Text(
                  "${model!.sellerName} Menus",
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
                        .doc(model!.sellerUid)
                        .collection("menus")
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
                            MenuModel menuModel = MenuModel.fromJSon(
                                snapshot.data!.docs[index].data()
                                    as Map<String, dynamic>);
                            return MenuDesign(
                              model: menuModel,
                            );
                          },
                          itemCount: snapshot.data!.docs.length,
                        );
                      }
                    }),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
