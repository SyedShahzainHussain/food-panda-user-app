import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:user_app/global/global.dart';
import 'package:user_app/model/address_model.dart';
import 'package:user_app/widget/text_widget.dart';

class SaveAddressScreen extends StatefulWidget {
  const SaveAddressScreen({super.key});

  @override
  State<SaveAddressScreen> createState() => _SaveAddressScreenState();
}

class _SaveAddressScreenState extends State<SaveAddressScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController addresslineController = TextEditingController();
  TextEditingController completeAddressController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  List<Placemark>? placemarks;
  Position? position;

  getCurrentLocationAddress() async {
    await Geolocator.requestPermission();
    Position positioned = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    position = positioned;
    placemarks = await placemarkFromCoordinates(
        positioned.latitude, positioned.longitude);

    Placemark placemark = placemarks![0];

    String fullAddress =
        "${placemark.subThoroughfare} ${placemark.thoroughfare} ${placemark.subAdministrativeArea} ${placemark.administrativeArea} ${placemark.locality} ${placemark.subLocality}";

    locationController.text = fullAddress;
    cityController.text =
        "${placemark.subAdministrativeArea} ${placemark.administrativeArea}";
    stateController.text = "${placemark.country}";
    addresslineController.text =
        "${placemark.subThoroughfare} ${placemark.thoroughfare} ${placemark.subAdministrativeArea} ${placemark.administrativeArea}";
    completeAddressController.text = fullAddress;
    setState(() {});
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
      floatingActionButton: FloatingActionButton.extended(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          backgroundColor: Colors.cyan,
          onPressed: () {
            if (_form.currentState!.validate() &&
                completeAddressController.text.isNotEmpty) {
              final model = Address(
                name: nameController.text.toString(),
                state: stateController.text.toString(),
                city: cityController.text.toString(),
                flatNumber: addresslineController.text.toString(),
                fulladdress: completeAddressController.text.toString(),
                lat: position!.latitude,
                lng: position!.longitude,
                phone: phoneController.text.toString(),
              ).toJson();

              FirebaseFirestore.instance
                  .collection("users")
                  .doc(sharedPreferences!.getString("uid"))
                  .collection("userAddress")
                  .doc(DateTime.now().toIso8601String())
                  .set(model)
                  .then((value) async {
                await Fluttertoast.showToast(
                        msg: "New Address has been saved successfully")
                    .then((value) {
                  Navigator.pop(context);
                });
              });
            }
          },
          label: const Text("Save Now", style: TextStyle(color: Colors.white)),
          icon: const Icon(
            Icons.save,
            color: Colors.white,
          )),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Save Address",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.person_pin_circle_rounded,
                color: Colors.black,
                size: 35,
              ),
              title: TextField(
                controller: locationController,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                    hintText: "What's your Address?",
                    hintStyle: TextStyle(color: Colors.black)),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            ElevatedButton.icon(
              onPressed: () {
                getCurrentLocationAddress();
              },
              icon: const Icon(
                Icons.location_on_outlined,
                color: Colors.white,
              ),
              label: const Text(
                "Get my location",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22.0))),
            ),
            Form(
              key: _form,
              child: Column(
                children: [
                  TextWidget(
                    hint: "Name",
                    textEditingController: nameController,
                  ),
                  TextWidget(
                    keyboardType: TextInputType.phone,
                    hint: "Phone Number",
                    textEditingController: phoneController,
                  ),
                  TextWidget(
                    hint: "City",
                    textEditingController: cityController,
                  ),
                  TextWidget(
                    hint: "State / Country",
                    textEditingController: stateController,
                  ),
                  TextWidget(
                    hint: "Address Line",
                    textEditingController: addresslineController,
                  ),
                  TextWidget(
                    hint: "Complete Address",
                    textEditingController: completeAddressController,
                  ),
                ],
              ),
            )
          ]),
    );
  }
}
