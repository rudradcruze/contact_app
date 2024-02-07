import 'package:contact_app/model/contact_model.dart';
import 'package:contact_app/providers/contact_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});
  static const String routeName = '/details';

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
      body: Consumer<ContactProvider>(
        builder:(context, provider, child) => FutureBuilder<ContactModel>(
          future: provider.getContactById(id!),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final contact = snapshot.data!;
              return ListView(
                children: [
                  ListTile(
                    title: Text(contact.number),
                  )
                ],
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            return const Center(child: CircularProgressIndicator(),);
          },
        ),
      ),
    );
  }
}
