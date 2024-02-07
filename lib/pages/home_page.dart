import 'package:contact_app/model/contact_model.dart';
import 'package:contact_app/pages/new_contact_page.dart';
import 'package:contact_app/providers/contact_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const String routeName = '/';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool isFirst = true;
  int currentIndex = 0;

  @override
  void didChangeDependencies() {
    if (isFirst) {
      context.read<ContactProvider>().getAllContact();
      isFirst = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, NewContactPage.routeName),
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
        title: const Text('Contact List'),
      ),
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.zero,
        shape: const CircularNotchedRectangle(),
        notchMargin: 10.0,
        clipBehavior: Clip.antiAlias,
        child: BottomNavigationBar(
          backgroundColor: Colors.purple.shade100,
          onTap: (value) {
            setState(() {
              currentIndex = value;
            });
            _loadData();
          },
          currentIndex: currentIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.apps),
              label: 'All',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favourite',
            ),
          ],
        ),
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

  void _loadData() {
    if (currentIndex == 0) {
      context.read<ContactProvider>().getAllContact();
    } else {
      context.read<ContactProvider>().getAllFavouriteContact();
    }
  }
}
