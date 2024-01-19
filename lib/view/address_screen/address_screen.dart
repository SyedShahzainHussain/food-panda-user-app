import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/global/global.dart';
import 'package:user_app/model/address_model.dart';
import 'package:user_app/view/save_address/save_address_screen.dart';
import 'package:user_app/viewModel/address_changer_view_model/address_changer_view_model.dart';
import 'package:user_app/widget/address_widget.dart';
import 'package:user_app/widget/progress_dialog.dart';

class AddressScreen extends StatelessWidget {
  final double? totalAmount;
  final String? sellerUid;
  const AddressScreen({super.key, this.totalAmount, this.sellerUid});

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
            fontSize: 20,
            color: Colors.white,
            fontFamily: "Signatra",
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const SaveAddressScreen()));
        },
        label: const Text(
          "Add New Location",
          style: TextStyle(color: Colors.white),
        ),
        icon: const Icon(Icons.add_location, color: Colors.white),
        backgroundColor: Colors.cyan,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Select Address",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          Consumer<AddressChanger>(
            builder: (context, value, _) {
              return Flexible(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(sharedPreferences!.getString("uid"))
                        .collection("userAddress")
                        .snapshots(),
                    builder: (context, snapshot) {
                      return !snapshot.hasData
                          ? Center(
                              child: circularProgress(),
                            )
                          : snapshot.data!.docs.isEmpty
                              ? const SizedBox.shrink()
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return AddressDesign(
                                      currentIndex: value.counter,
                                      addressID: snapshot.data!.docs[index].id,
                                      sellerUid: sellerUid,
                                      totalAmount: totalAmount,
                                      value: index,
                                      model: Address.fromJson(
                                          snapshot.data!.docs[index].data()),
                                    );
                                  },
                                  itemCount: snapshot.data!.docs.length,
                                );
                    }),
              );
            },
          )
        ],
      ),
    );
  }
}
