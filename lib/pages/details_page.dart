import 'dart:io';

import 'package:contact_app/providers/contact_provider.dart';
import 'package:contact_app/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/contact_model.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key});

  static const String routeName = '/details';
  final bool isEmailActivate = true;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final fromEditKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute
        .of(context)!
        .settings
        .arguments as int;
    final contact = context.watch<ContactProvider>().getContactFromCash(id);
    final controller = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
      body: Consumer<ContactProvider>(
        builder: (context, provider, child) =>
            ListView(
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
                              builder: (context) =>
                                  AlertDialog(
                                    title: const Text('Edit Image'),
                                    content: const Text(
                                        'Choose image from camera or gallery!'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
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
                                        },
                                        child: const Icon(Icons.camera_alt),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          updateImage(
                                              context, id, ImageSource.gallery);
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
                            showSingleTextInputDialog(context: context,
                              title: 'Edit Number',
                              hintText: '${contact.number}',
                              iconData: Icons.call,
                              onSave: (value) {
                                Provider.of<ContactProvider>(
                                    context, listen: false)
                                    .updateContactSingleColumn(
                                    id, tblContactColNumber, value);
                              },);
                          },
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            _lunchUrl(context, contact.number, 0);
                          },
                          icon: const Icon(Icons.call),
                        ),
                        IconButton(
                          onPressed: () {
                            _lunchUrl(context, contact.number, 1);
                          },
                          icon: const Icon(Icons.message),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text(contact.email!.isEmpty ? 'Enter email' : contact
                        .email!),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            showSingleTextInputDialog(
                              context: context,
                              title: 'Edit Email',
                              hintText: '${contact.email}',
                              textInputType: TextInputType.emailAddress,
                              iconData: Icons.email,
                              onSave: (value) {
                                Provider.of<ContactProvider>(
                                    context, listen: false)
                                    .updateContactSingleColumn(
                                    id, tblContactColEmail, value);
                              },
                            );
                          },
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            if (contact.email!.isNotEmpty) {
                              _lunchUrl(context, contact.email, 2);
                            } else {
                              _showEmptyWarning(
                                  'Email cannot empty! please fill up it.');
                            }
                          },
                          icon: const Icon(Icons.email),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text(
                        contact.website!.isEmpty ? 'Enter Website' : contact
                            .website!),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            showSingleTextInputDialog(context: context,
                              title: 'Edit Website',
                              hintText: '${contact.website}',
                              iconData: Icons.language,
                              onSave: (value) {
                                Provider.of<ContactProvider>(
                                    context, listen: false)
                                    .updateContactSingleColumn(
                                    id, tblContactColWebsite, value);
                              },);
                          },
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () async {
                            if (contact.website!.isNotEmpty) {
                              _lunchUrl(context, contact.website, 3);
                            } else {
                              _showEmptyWarning(
                                  'Website cannot empty! please fill up it.');
                            }
                          },
                          icon: const Icon(Icons.language),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text(
                        contact.address!.isEmpty ? 'Enter Address' : contact
                            .address!),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            showSingleTextInputDialog(context: context,
                              title: 'Edit Address',
                              hintText: '${contact.address}',
                              iconData: Icons.streetview,
                              onSave: (value) {
                                Provider.of<ContactProvider>(
                                    context, listen: false)
                                    .updateContactSingleColumn(
                                    id, tblContactColAddress, value);
                              },);
                          },
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () async {
                            if (contact.address!.isNotEmpty) {
                              _lunchUrl(context, contact.address, 4);
                            } else {
                              _showEmptyWarning(
                                  'Address cannot empty! please fill up it.');
                            }
                          },
                          icon: const Icon(Icons.streetview),
                        ),
                      ],
                    ),
                  ),
                ),
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
    Navigator.of(context).pop();
  }

  void _lunchUrl(BuildContext context, dynamic data, int num) async {
    // String urlString = '';
    var url;
    switch (num) {
      case 0:
        url = Uri(scheme: 'tel', path: data);
      case 1:
        url = Uri(scheme: 'sms', path: data);
      case 2:
        url = Uri(scheme: 'mailto', path: data);
      case 3:
        url = Uri(scheme: 'https', path: data);
      case 4:
        {
          if (Platform.isAndroid) {
            url = 'geo:0,0?q=$data';
          } else {
            url = 'http://maps.apple.com/?q=$data';
          }
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            showMessage(context, 'Could not perform this operation.');
          }
        }
    }

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      showMessage(context, 'Could not perform this operation.');
    }
  }

/*  void editContact(BuildContext context, String column,
      TextEditingController controller, IconData iconData, dynamic data,
      int id) {
    showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('Edit $column'),
              content: Form(
                key: fromEditKey,
                child: TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                    prefixIcon: Icon(iconData),
                    hintText: data,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field must not be empty';
                    }
                    return null;
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'CANCEL',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // showSingleTextInputDialog(context: context, title: title, hintText: hintText, iconData: iconData, onSave: onSave);
                    // updateContact(fromEditKey, context, id, column, controller);
                  },
                  child: const Text(
                    'UPDATE',
                  ),
                ),
              ],
            ));
  }

  void updateContact(GlobalKey<FormState> fromEditKey, BuildContext context,
      int id, String column, TextEditingController controller) {
    if (fromEditKey.currentState!.validate()) {
      context.read<ContactProvider>().updateContactSingleColumn(
          id, column, controller.text);
    } else {
      debugPrint("Something went wrong");
    }
    Navigator.of(context).pop();
  }*/

  void _showEmptyWarning(String s) {
    showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: const Text('Empty Value'),
              content: Text(s),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text('OKAY'),
                ),
              ],
            ));
  }
}