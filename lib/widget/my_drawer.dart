import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:user_app/global/global.dart';
import 'package:user_app/view/home_screen/home_screen.dart';
import 'package:user_app/view/my_splash_screen/my_splash_screen.dart';
import 'package:user_app/view/order_screen/order_screen.dart';
import 'package:user_app/view/search_screen/search_screen.dart';

import '../view/history_screen/history_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 25, bottom: 10),
            child: Column(
              children: [
                Material(
                  borderRadius: const BorderRadius.all(Radius.circular(80)),
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: SizedBox(
                      height: 160,
                      width: 160,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            sharedPreferences!.getString("photoUrl")!),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  sharedPreferences!.getString("name")!,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(fontFamily: "TrainOne"),
                )
              ],
            ),
          ),
          // * body Drawer
          const SizedBox(
            height: 12,
          ),
          Container(
            padding: const EdgeInsets.only(top: 1.0),
            child: Column(children: [
              const Divider(
                height: 10,
                color: Colors.grey,
                thickness: 2,
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()));
                },
                leading: const Icon(Icons.home, color: Colors.black),
                title: const Text("Home"),
              ),
              const Divider(
                height: 10,
                color: Colors.grey,
                thickness: 2,
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const OrderScreen()));
                },
                leading: const Icon(Icons.reorder, color: Colors.black),
                title: const Text("My Orders"),
              ),
              const Divider(
                height: 10,
                color: Colors.grey,
                thickness: 2,
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HistoryScreen()));
                },
                leading: const Icon(Icons.access_time, color: Colors.black),
                title: const Text("History"),
              ),
              const Divider(
                height: 10,
                color: Colors.grey,
                thickness: 2,
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SearchScreen()));
                },
                leading: const Icon(Icons.search, color: Colors.black),
                title: const Text("Search"),
              ),
              const Divider(
                height: 10,
                color: Colors.grey,
                thickness: 2,
              ),
              ListTile(
                onTap: () {},
                leading: const Icon(Icons.add_location, color: Colors.black),
                title: const Text("Add New Address"),
              ),
              const Divider(
                height: 10,
                color: Colors.grey,
                thickness: 2,
              ),
              ListTile(
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SplashScreen()),
                      (route) => false);
                },
                leading: const Icon(Icons.exit_to_app, color: Colors.black),
                title: const Text("Sign Out"),
              ),
              const Divider(
                height: 10,
                color: Colors.grey,
                thickness: 2,
              ),
            ]),
          )
        ],
      ),
    );
  }
}
