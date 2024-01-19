import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/maps/maps.dart';
import 'package:user_app/model/address_model.dart';
import 'package:user_app/view/placed_order_screen/place_order_screen.dart';
import 'package:user_app/viewModel/address_changer_view_model/address_changer_view_model.dart';

class AddressDesign extends StatelessWidget {
  final Address? model;
  final int? currentIndex;
  final int? value;
  final String? addressID;
  final double? totalAmount;
  final String? sellerUid;
  const AddressDesign({
    super.key,
    this.model,
    this.currentIndex,
    this.value,
    this.addressID,
    this.totalAmount,
    this.sellerUid,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {},
        child: Card(
          color: Colors.cyan.withOpacity(0.4),
          child: Column(children: [
            Row(
              children: [
                Radio(
                    value: value,
                    groupValue: currentIndex,
                    onChanged: (value) {
                      context
                          .read<AddressChanger>()
                          .displayCounterResult(value!);
                    }),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: MediaQuery.sizeOf(context).width * .8,
                      child: Table(
                        children: [
                          TableRow(
                            children: [
                              Text(
                                "Name:",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                model?.name ?? "",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              Text(
                                "Phone Number:",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                model?.phone ?? "",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              Text(
                                "Flat Number:",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                model?.flatNumber ?? "",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              Text(
                                "State:",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                model?.state ?? "",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              Text(
                                "Full Address:",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                model?.fulladdress ?? "",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
            // ! button
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black54),
              onPressed: () {
                MapsUtils.openMap(model!.fulladdress!);
              },
              child: Text(
                "Check on Maps",
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .copyWith(color: Colors.white),
              ),
            ),

            value == context.read<AddressChanger>().counter
                ? ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PlaceOrderScreen(
                                    addressID: addressID,
                                    sellerUID: sellerUid,
                                    totalAmount: totalAmount,
                                  )));
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: Text(
                      "Process",
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium!
                          .copyWith(color: Colors.white),
                    ),
                  )
                : const SizedBox.shrink()
          ]),
        ));
  }
}
