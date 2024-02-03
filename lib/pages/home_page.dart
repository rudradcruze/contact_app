import 'package:contact_app/pages/new_contact_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static const String routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, NewContactPage.routeName),
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
    );
  }
}
