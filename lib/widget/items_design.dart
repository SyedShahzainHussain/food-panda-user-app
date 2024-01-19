import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:user_app/model/item_model.dart';
import 'package:user_app/view/item_detail_screen/item_detail_screen.dart';

class ItemDesign extends StatelessWidget {
  final ItemModel? model;
  final BuildContext? context;
  const ItemDesign({
    Key? key,
    this.model,
    this.context,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ItemDetailScreen(
                      itemModel: model,
                    )));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: CachedNetworkImage(
                progressIndicatorBuilder: (context, value, download) {
                  return const Center(
                    child: SpinKitCircle(
                      color: Colors.black,
                      size: 20,
                    ),
                  );
                },
                imageUrl: model!.thumbnailUrl!,
                height: 220.0,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              model!.itemTitle!,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .copyWith(color: Colors.cyan, fontFamily: "TrainOne"),
            ),
            Text(
              model!.itemInfo!,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .copyWith(color: Colors.cyan, fontFamily: "TrainOne"),
            ),
          ],
        ),
      ),
    );
  }
}
