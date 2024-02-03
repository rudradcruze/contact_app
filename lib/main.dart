import 'package:contact_app/pages/details_page.dart';
import 'package:contact_app/pages/home_page.dart';
import 'package:contact_app/pages/new_contact_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName : (context) => const HomePage(),
        NewContactPage.routeName : (context) => const NewContactPage(),
        DetailsPage.routeName : (context) => const DetailsPage()
      },
    );
  }
}