import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:user_app/global/global.dart';
import 'package:user_app/model/address_model.dart';
import 'package:user_app/view/home_screen/home_screen.dart';
import 'package:user_app/widget/shipping_details_widget.dart';
import 'package:user_app/widget/progress_dialog.dart';
import 'package:user_app/widget/status_banner_widget.dart';

class OrderDetailScreen extends StatelessWidget {
  final String? orderId;
  const OrderDetailScreen({super.key, this.orderId});

  @override
  Widget build(BuildContext context) {
    String orderStatus = "";

    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false,
          );
          return true;
        },
        child: SingleChildScrollView(
          child: FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection("users")
                  .doc(sharedPreferences!.getString("uid"))
                  .collection("orders")
                  .doc(orderId)
                  .get(),
              builder: (context, snapshot) {
                Map? dataMap;
                if (snapshot.hasData) {
                  dataMap = snapshot.data!.data()!;
                  orderStatus = dataMap["status"];
                }
                return snapshot.hasData
                    ? Column(
                        children: [
                          StatusBanner(
                            orderStatus: orderStatus,
                            status: dataMap!["isSuccess"],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Rs ${dataMap["totalAmount"]}",
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Text(
                            "Order Id = $orderId",
                            style: const TextStyle(
                              fontSize: 14,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "Order at: ${DateFormat("dd MMMM, yyyy - hh:mm aa").format(DateTime.parse(dataMap["orderTime"]))}",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Divider(
                            thickness: 4,
                          ),
                          orderStatus == "ended"
                              ? Image.asset("assets/images/delivered.jpg")
                              : Image.asset("assets/images/state.jpg"),
                          const Divider(
                            thickness: 4,
                          ),
                          FutureBuilder(
                              future: FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(sharedPreferences!.getString("uid"))
                                  .collection("userAddress")
                                  .doc(dataMap["addressID"])
                                  .get(),
                              builder: (context, snapshot) {
                                return snapshot.hasData
                                    ? ShippingDetailsWidget(
                                        address: Address.fromJson(
                                            snapshot.data!.data()!),
                                      )
                                    : Center(
                                        child: circularProgress(),
                                      );
                              })
                        ],
                      )
                    : const SizedBox.shrink();
              }),
        ),
      ),
    );
  }
}
