import 'package:contact_app/pages/new_contact_page.dart';
import 'package:contact_app/providers/contact_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static const String routeName = '/';

  @override
  Widget build(BuildContext context) {
    context.read<ContactProvider>().getAllContact();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, NewContactPage.routeName),
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Contact List'),
      ),
      body: Consumer<ContactProvider> (
        builder: (context, provider, child) => ListView.builder(
          itemCount: provider.contactList.length,
          itemBuilder: (context, index) {
            final contact = provider.contactList[index];
            return ListTile(
              title: Text(contact.name),
              trailing: Icon(contact.favorite ? Icons.favorite : Icons.favorite_border),
            );
          },
        ),
      ),
    );
  }
}
