import 'package:flutter/material.dart';
import 'package:foodly/providers/cartProvider.dart';
import 'package:foodly/providers/image_upload_provider.dart';
import 'package:foodly/resources/userRepository.dart';
import 'package:foodly/src/home/home.dart';
import 'package:foodly/src/myAccount/myAccount.dart';
import 'package:foodly/src/search/searchScreen.dart';
import 'package:foodly/src/thankyou/thankyou.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => UserRepository.instance()),
        ChangeNotifierProvider(create: (_) => ImageUploadProvider()),
      ],
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "The Foodly",
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/": (_) => Home(),
        "/searchScreen": (_) => SearchScreen(),
        "/myAccount": (_) => MyAccount(),
        "/thankYou": (_) => ThankYou(),
      },
    );
  }
}
