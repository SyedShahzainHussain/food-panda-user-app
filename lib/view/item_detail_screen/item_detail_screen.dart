import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:provider/provider.dart';
import 'package:user_app/model/item_model.dart';
import 'package:user_app/view/cart_screen/cart_screen.dart';
import 'package:user_app/viewModel/add_to_cart_view_model/add_to_cart_view_model.dart';

class ItemDetailScreen extends StatefulWidget {
  final ItemModel? itemModel;
  const ItemDetailScreen({super.key, this.itemModel});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  final counterCountroller = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    counterCountroller.dispose();
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
                tileMode: TileMode.clamp,
              ),
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
                              builder: (context) => CartScreen(
                                    sellerUID: widget.itemModel!.sellerID,
                                  )));
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
          title: Text(
            widget.itemModel!.itemTitle!,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontFamily: "Signatra",
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height -
                  MediaQuery.paddingOf(context).top -
                  kToolbarHeight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CachedNetworkImage(
                    imageUrl: widget.itemModel!.thumbnailUrl!,
                    height: MediaQuery.sizeOf(context).height / 4,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: NumberInputPrefabbed.roundedButtons(
                      controller: counterCountroller,
                      incDecBgColor: Colors.amber,
                      buttonArrangement: ButtonArrangement.incRightDecLeft,
                      min: 1,
                      initialValue: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(widget.itemModel!.itemTitle!,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(widget.itemModel!.itemDescription!,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(fontWeight: FontWeight.normal)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("${widget.itemModel!.price} Rs",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 10),
                  const Spacer(),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        int itemCounter = int.parse(counterCountroller.text);

                        // !!  if cart is alredy exists
                        List<String> separateItemList = context
                            .read<AddToCartViewModel>()
                            .separateItemsIds();

                        separateItemList.contains(widget.itemModel!.itemID)
                            ? Fluttertoast.showToast(
                                msg: "Item is Already in Cart")
                            :

                            // !! add to cart

                            context.read<AddToCartViewModel>().addToCart(
                                  context,
                                  widget.itemModel!.itemID,
                                  itemCounter,
                                );
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.cyan, Colors.amber],
                              begin: FractionalOffset(0.0, 0.0),
                              end: FractionalOffset(1.0, 0.0),
                              stops: [0.0, 1.0],
                              tileMode: TileMode.clamp),
                        ),
                        width: MediaQuery.sizeOf(context).width - 15,
                        height: 50,
                        child: Center(
                            child: Text(
                          "Add To Cart",
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(color: Colors.white),
                        )),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ));
  }
}
