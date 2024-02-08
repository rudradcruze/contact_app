import 'dart:io';

import 'package:contact_app/providers/contact_provider.dart';
import 'package:contact_app/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../model/contact_model.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  static const String routeName = '/details';

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as int;
    final contact = context.watch<ContactProvider>().getContactFromCash(id);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
      body: Consumer<ContactProvider>(
        builder: (context, provider, child) => ListView(
          children: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Center(
                    child: contact.image == null || contact.image!.isEmpty
                        ? CircleAvatar(
                            radius: 60.0,
                            backgroundColor: Colors.purple.shade300,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: ClipOval(
                                child: SizedBox.fromSize(
                                  size: const Size.fromRadius(52),
                                  child: Image.asset(
                                    'images/placeholder.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : CircleAvatar(
                            radius: 60.0,
                            backgroundColor: Colors.purple.shade300,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: ClipOval(
                                child: SizedBox.fromSize(
                                  size: const Size.fromRadius(52),
                                  child: Image.file(
                                    File(
                                      contact.image!,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 140,
                  child: FloatingActionButton.small(
                    backgroundColor: Colors.purple.shade100,
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Text('Edit Image'),
                                content: const Text(
                                    'Choose image from camera or gallery!'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, false);
                                    },
                                    child: const Text(
                                      'CANCEL',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      updateImage(
                                          context, id, ImageSource.camera);
                                      Navigator.pop(context, true);
                                    },
                                    child: const Icon(Icons.camera_alt),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      updateImage(
                                          context, id, ImageSource.gallery);
                                      Navigator.pop(context, true);
                                    },
                                    child: const Icon(Icons.photo_library),
                                  ),
                                ],
                              ));
                    },
                    shape: const CircleBorder(),
                    child: const Icon(
                      Icons.edit,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: Text(contact.number),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        _callContact(context, contact.number);
                      },
                      icon: const Icon(Icons.call),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.message),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void updateImage(BuildContext context, int id, ImageSource source) async {
    final xFile = await ImagePicker().pickImage(source: source);
    if (xFile != null) {
      final path = xFile.path;
      context
          .read<ContactProvider>()
          .updateContactSingleColumn(id, tblContactColImage, path);
    }
  }

  void _callContact(BuildContext context, String number) async {
    final urlString = 'tel:$number';
    if (await canLaunchUrlString(urlString)) {
      await launchUrlString(urlString);
    } else {
      showMessage(context, 'Could not perform this operation.');
    }
  }

/*FutureBuilder<ContactModel> buildFutureBuilder(ContactProvider provider, int id) {
    return FutureBuilder<ContactModel>(
        future: provider.getContactById(id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final contact = snapshot.data!;
            return ListView(
              children: [
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Center(
                        child:
                            contact.image == "null" || contact.image!.isEmpty
                                ? CircleAvatar(
                                    radius: 60.0,
                                    backgroundColor: Colors.purple.shade300,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: ClipOval(
                                        child: SizedBox.fromSize(
                                          size: const Size.fromRadius(52),
                                          child: Image.asset(
                                            'images/placeholder.png',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: 60.0,
                                    backgroundColor: Colors.purple.shade300,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: ClipOval(
                                        child: SizedBox.fromSize(
                                          size: const Size.fromRadius(52),
                                          child: Image.file(
                                            contact.image as File,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 140,
                      child: FloatingActionButton.small(
                        backgroundColor: Colors.purple.shade100,
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Edit Image'),
                                content: const Text('Choose image from camera or gallery!'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, false);
                                    },
                                    child: const Text('CANCEL', style: TextStyle(color: Colors.red),),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      updateImage(ImageSource.camera);
                                    },
                                    child: const Icon(Icons.camera_alt),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, false);
                                    },
                                    child: const Icon(Icons.photo_library),
                                  ),
                                ],
                              ));
                        },
                        shape: const CircleBorder(),
                        child: const Icon(
                          Icons.edit,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
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
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );
  }*/
}
