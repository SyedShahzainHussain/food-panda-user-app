import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:user_app/global/global.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddToCartViewModel with ChangeNotifier {
  double _totalAmount = 0;
  double get tAmount => _totalAmount;

  displayTotalAmount(double number) async {
    _totalAmount = number;
    Future.delayed(const Duration(milliseconds: 100), () {
      notifyListeners();
    });
  }

// ! separated order items quantity
  separateOrderQuantity(separateOrderItemList) {
    List<String> defaultQuantityList = [];
    List<String> separateQuantityList = [];

    defaultQuantityList = List<String>.from(separateOrderItemList);
    int i = 1;
    for (i; i < defaultQuantityList.length; i++) {
      String quantity = defaultQuantityList[i].toString();
      List<String> listQuantity = quantity.split(":").toList();
      int quantityNumber = int.parse(listQuantity.last.toString());
      separateQuantityList.add(quantityNumber.toString());
    }
    return separateQuantityList;
  }

  // ! separated Order Item List
  separateOrderItemsIds(separateOrderItemList) {
    List<String> separateItemList = [], defaultItemList = [];
    int i = 0;
    defaultItemList = List<String>.from(separateOrderItemList);

    for (i; i < defaultItemList.length; i++) {
      String item = defaultItemList[i].toString();
      var pos = item.lastIndexOf(":");
      String getItemId = (pos != -1) ? item.substring(0, pos) : item;
      separateItemList.add(getItemId.trim());
    }

    return separateItemList;
  }

  int cartListItemCounter =
      sharedPreferences!.getStringList("userCart")!.length - 1;
  int get cartCount => cartListItemCounter;

  // ! updateItemCounter
  updateItemCoutner() async {
    cartListItemCounter =
        sharedPreferences!.getStringList("userCart")!.length - 1;
    await Future.delayed(const Duration(milliseconds: 100), () {
      notifyListeners();
    });
  }

  // ! separated item Ids

  separateItemsIds() {
    List<String> separateItemList = [], defaultItemList = [];
    int i = 0;
    defaultItemList = sharedPreferences!.getStringList("userCart")!;

    for (i; i < defaultItemList.length; i++) {
      String item = defaultItemList[i].toString();
      var pos = item.lastIndexOf(":");
      String getItemId = (pos != -1) ? item.substring(0, pos) : item;
      separateItemList.add(getItemId.trim());
    }

    return separateItemList;
  }

  // ! sepated quantity
  separateQuantity() {
    List<String> defaultQuantityList = [];
    List<int> separateQuantityList = [];

    defaultQuantityList = sharedPreferences!.getStringList("userCart")!;
    int i = 1;
    for (i; i < defaultQuantityList.length; i++) {
      String quantity = defaultQuantityList[i].toString();
      List<String> listQuantity = quantity.split(":").toList();
      int quantityNumber = int.parse(listQuantity.last.toString());
      separateQuantityList.add(quantityNumber);
    }
    return separateQuantityList;
  }

  // ! add to cart
  addToCart(
    BuildContext context,
    String? foodId,
    int itemCounter,
  ) async {
    final List<String>? tempList = sharedPreferences!.getStringList("userCart");

    tempList!.add("$foodId:$itemCounter");

    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      "userCart": tempList,
    }).then((value) {
      Fluttertoast.showToast(msg: "Item Added Successfully");
      sharedPreferences!.setStringList("userCart", tempList);
      updateItemCoutner();
    });
  }

  // ! delete cart
  Future<void> deleteCart() async {
    await sharedPreferences!.setStringList(
      "userCart",
      ["garbageValue"],
    );
    final List<String>? emptyList =
        sharedPreferences!.getStringList("userCart");
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"userCart": emptyList}).then((value) async {});
    await sharedPreferences!.setStringList("userCart", emptyList!);
    updateItemCoutner();
  }
}
