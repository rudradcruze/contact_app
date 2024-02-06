import 'package:contact_app/model/contact_model.dart';
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
      body: Consumer<ContactProvider>(
        builder: (context, provider, child) => provider.contactList.isEmpty
            ? const Center(
                child: Text('No Contact Found'),
              )
            : ListView.builder(
                itemCount: provider.contactList.length,
                itemBuilder: (context, index) {
                  final contact = provider.contactList[index];
                  return Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      child: const Icon(
                        Icons.delete,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                    confirmDismiss: (_) {
                      return showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Text('Delete Contact?'),
                                content: Text(
                                    'Are you sure to delete contact ${contact.name}'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, false);
                                    },
                                    child: const Text('CANCEL'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, true);
                                    },
                                    child: const Text('YES'),
                                  ),
                                ],
                              ));
                    },
                    onDismissed: (_) {
                      context
                          .read<ContactProvider>()
                          .deleteContact(contact.id!);
                    },
                    child: ListTile(
                      title: Text(contact.name),
                      trailing: IconButton(
                        onPressed: () {
                          final value = contact.favorite ? 0 : 1;
                          context
                              .read<ContactProvider>()
                              .updateContactSingleColumn(
                                  contact.id!, tblContactColFavorite, value);
                        },
                        icon: Icon(
                          contact.favorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
