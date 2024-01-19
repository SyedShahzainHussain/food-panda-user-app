import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:user_app/model/item_model.dart';

class CartItemDesign extends StatelessWidget {
  final ItemModel? itemModel;
  final BuildContext? context;
  final int? separateQuantityList;
  const CartItemDesign({
    super.key,
    required this.itemModel,
    required this.context,
    required this.separateQuantityList,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: SizedBox(
          height: 165,
          width: double.infinity,
          child: Row(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: CachedNetworkImage(
                imageUrl: itemModel!.thumbnailUrl!,
                width: 120,
                height: 100,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(
              width: 6,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(itemModel!.itemTitle!,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Colors.black,
                          fontFamily: "KiwiMaru",
                          fontWeight: FontWeight.bold,
                        )),
                const SizedBox(
                  height: 1,
                ),
                Row(
                  children: [
                    Text("Quantity:",
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontFamily: "KiwiMaru",
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                )),
                    const SizedBox(
                      width: 10,
                    ),  
                    Text(separateQuantityList!.toString(),
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: Colors.black,
                                  fontFamily: "KiwiMaru",
                                  fontWeight: FontWeight.bold,
                                )),
                  ],
                ),
                const SizedBox(
                  height: 1,
                ),
                Row(
                  children: [
                    const Text(
                      "Price:",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: "KiwiMaru",
                      ),
                    ),
                    const SizedBox(
                      width: 1,
                    ),
                    Text(
                      "Rs ${itemModel!.price!}",
                      style: const TextStyle(
                        color: Colors.cyan,
                        fontWeight: FontWeight.bold,
                        fontFamily: "KiwiMaru",
                      ),
                    ),
                  ],
                )
              ],
            )
          ]),
        ),
      ),
    );
  }
}
