import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:user_app/model/sellers.dart';
import 'package:user_app/widget/seller_design.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String sellerNameText = "";
  Future<QuerySnapshot>? resturantDocumentList;
  initSearchResturant(String sellerName) {
    resturantDocumentList = FirebaseFirestore.instance
        .collection("sellers")
        .where("sellerName", isGreaterThanOrEqualTo: sellerName)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
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
          title: TextField(
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              onChanged: (value) {
                setState(() {
                  sellerNameText = value;
                });
                initSearchResturant(value);
              },
              decoration: InputDecoration(
                  hintText: "Search Resturants Here ...",
                  hintStyle: const TextStyle(color: Colors.white),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    onPressed: () {
                      initSearchResturant(sellerNameText);
                    },
                    icon: const Icon(Icons.search),
                    color: Colors.white,
                  ))),
        ),
        body: FutureBuilder(
          future: resturantDocumentList,
          builder: (context, snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    itemBuilder: (context, index) {
                      Sellers sellers = Sellers.fromJson(
                          snapshot.data!.docs[index].data()
                              as Map<String, dynamic>);
                      return SellerDesign(
                        context: context,
                        model: sellers,
                      );
                    },
                    itemCount: snapshot.data!.docs.length,
                  )
                : const Center(
                    child: Text("No Data Found"),
                  );
          },
        ));
  }
}
