import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:user_app/model/item_model.dart';
import 'package:user_app/view/address_screen/address_screen.dart';
import 'package:user_app/viewModel/add_to_cart_view_model/add_to_cart_view_model.dart';
import 'package:user_app/widget/cart_item_design.dart';

class CartScreen extends StatefulWidget {
  final String? sellerUID;

  const CartScreen({this.sellerUID, super.key});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<int> separatedQuantity;
  double totalAmount = 0;

  @override
  void initState() {
    super.initState();
    context.read<AddToCartViewModel>().displayTotalAmount(0);
    separatedQuantity = context.read<AddToCartViewModel>().separateQuantity();
  }

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
        floatingActionButton: Consumer<AddToCartViewModel>(
          builder: (context, value, _) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 10,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: FloatingActionButton.extended(
                  heroTag: "Clear Cart",
                  onPressed: value.separateQuantity().isEmpty
                      ? null
                      : () {
                          value.deleteCart().then((value) {
                            Navigator.pop(context);
                            Fluttertoast.showToast(msg: "Cart Clear");
                          });
                        },
                  backgroundColor: Colors.cyan,
                  icon: const Icon(
                    Icons.clear_all,
                    color: Colors.white,
                  ),
                  label: const Text("Clear Cart",
                      style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: FloatingActionButton.extended(
                  heroTag: "Check Out",
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddressScreen(
                                  totalAmount: value.tAmount,
                                  sellerUid: widget.sellerUID,
                                )));
                  },
                  backgroundColor: Colors.cyan,
                  icon: const Icon(
                    Icons.navigate_next,
                    color: Colors.white,
                  ),
                  label: const Text("Check Out",
                      style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Consumer<AddToCartViewModel>(
              builder: (context, value, _) => value.cartCount == 0
                  ? const SizedBox.shrink()
                  : SizedBox(
                      width: double.infinity,
                      height: kToolbarHeight,
                      child: Center(
                          child: Text(
                        "Total Amount = ${value.tAmount.toStringAsFixed(1)}",
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
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("items")
                  .where("itemID",
                      whereIn:
                          context.read<AddToCartViewModel>().separateItemsIds())
                  .orderBy("publishedDate", descending: false)
                  .snapshots(),
              builder: (context, value) {
                if (!value.hasData) {
                  return const Center(
                    child: SpinKitChasingDots(color: Colors.amber),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: value.data!.docs.length,
                  itemBuilder: (context, index) {
                    final itemModel =
                        ItemModel.fromJson(value.data!.docs[index].data());
                    if (index == 0) {
                      totalAmount = 0;
                      totalAmount +=
                          itemModel.price! * separatedQuantity[index];
                    } else {
                      totalAmount +=
                          itemModel.price! * separatedQuantity[index];
                    }

                    if (value.data!.docs.length - 1 == index) {
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        context
                            .read<AddToCartViewModel>()
                            .displayTotalAmount(totalAmount);
                      });
                    }

                    return CartItemDesign(
                        context: context,
                        itemModel: itemModel,
                        separateQuantityList: separatedQuantity[index]);
                  },
                );
              },
            ),
          ],
        ));
  }
}
