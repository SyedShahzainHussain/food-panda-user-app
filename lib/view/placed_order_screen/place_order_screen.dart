import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:user_app/global/global.dart';
import 'package:user_app/view/home_screen/home_screen.dart';
import 'package:user_app/viewModel/add_to_cart_view_model/add_to_cart_view_model.dart';
import 'package:provider/provider.dart';

class PlaceOrderScreen extends StatefulWidget {
  final String? addressID;
  final double? totalAmount;
  final String? sellerUID;

  const PlaceOrderScreen(
      {this.sellerUID, this.totalAmount, this.addressID, super.key});

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  String orderId = DateTime.now().toIso8601String();

  addOrderDetails(BuildContext context) {
    writeOrderDetailForUser({
      "addressID": widget.addressID,
      "orderTime": orderId,
      "totalAmount": widget.totalAmount,
      "orderBy": sharedPreferences!.getString("uid"),
      "productsIDs": sharedPreferences!.getStringList("userCart"),
      "paymentDetails": "Cash on Delivery",
      "isSuccess": true,
      "sellerUID": widget.sellerUID,
      "riderUID": "",
      "status": "normal",
      "orderId": orderId,
    });
    writeOrderDetail({
      "addressID": widget.addressID,
      "orderTime": orderId,
      "totalAmount": widget.totalAmount,
      "orderBy": sharedPreferences!.getString("uid"),
      "productsIDs": sharedPreferences!.getStringList("userCart"),
      "paymentDetails": "Cash on Delivery",
      "isSuccess": true,
      "sellerUID": widget.sellerUID,
      "riderUID": "",
      "status": "normal",
      "orderId": orderId,
    }).whenComplete(() {
      context.read<AddToCartViewModel>().deleteCart();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
      Fluttertoast.showToast(
          msg: "Congratulations, Order has been placed successfully.");
    });
  }

  Future writeOrderDetailForUser(Map<String, dynamic> data) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(sharedPreferences!.getString("uid"))
        .collection("orders")
        .doc(orderId)
        .set(data);
  }

  Future writeOrderDetail(Map<String, dynamic> data) async {
    await FirebaseFirestore.instance
        .collection("orders")
        .doc(orderId)
        .set(data);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Colors.cyan,
            Colors.amber,
          ],
          begin: FractionalOffset(0.0, 0.0),
          end: FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        )),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/images/delivery.jpg"),
              const SizedBox(
                height: 12,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                ),
                onPressed: () {
                  addOrderDetails(context);
                },
                child: Text(
                  "Place Order",
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: Colors.white),
                ),
              ),
            ]),
      ),
    );
  }
}
