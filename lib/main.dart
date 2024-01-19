import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_app/firebase_options.dart';
import 'package:user_app/global/global.dart';
import 'package:user_app/view/my_splash_screen/my_splash_screen.dart';
import 'package:user_app/viewModel/address_changer_view_model/address_changer_view_model.dart';
import 'package:user_app/viewModel/add_to_cart_view_model/add_to_cart_view_model.dart';
import 'package:user_app/viewModel/auth_view_model/login_view_model.dart';
import 'package:user_app/viewModel/auth_view_model/sign_up_view_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=> LoginViewModel()),
        ChangeNotifierProvider(create: (context)=> SignUpViewModel()),
        ChangeNotifierProvider(create: (context)=> AddToCartViewModel()),
        ChangeNotifierProvider(create: (context)=>AddressChanger()),
      ],
      child: MaterialApp(
        title: 'Users App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
  