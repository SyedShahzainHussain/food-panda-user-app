import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:user_app/model/sellers.dart';
import 'package:user_app/view/menus_screen/menus_screen.dart';

class SellerDesign extends StatelessWidget {
  final Sellers? model;
  final BuildContext? context;
  const SellerDesign({Key? key, this.model, this.context}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MenusScreen(
                      model: model,
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
                imageUrl: model!.sellerAvatarUrl!,
                height: 220.0,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              model!.sellerName!,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .copyWith(color: Colors.cyan, fontFamily: "TrainOne"),
            ),
            Text(
              model!.email!,
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
