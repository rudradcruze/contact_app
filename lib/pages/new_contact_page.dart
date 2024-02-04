import 'package:contact_app/model/contact_model.dart';
import 'package:contact_app/providers/contact_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewContactPage extends StatefulWidget {
  const NewContactPage({super.key});
  static const String routeName = '/new_contact';

  @override
  State<NewContactPage> createState() => _NewContactPageState();
}

class _NewContactPageState extends State<NewContactPage> {
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final webController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Contact'),
        actions: [
          IconButton(
              onPressed: _saveContact,
              icon: const Icon(Icons.save)
          )
        ],
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Contact Name',
                  filled: true,
                    prefixIcon: Icon(Icons.person)
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field must not be empty';
                  }
                  if (value.length >= 25) {
                    return 'Name should be less then 25 characters';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: mobileController,
                decoration: const InputDecoration(
                  labelText: 'Mobile Number',
                  filled: true,
                  prefixIcon: Icon(Icons.call)
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field must not be empty';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  filled: true,
                  prefixIcon: Icon(Icons.email)
                ),
                validator: (value) {
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: TextFormField(
                keyboardType: TextInputType.streetAddress,
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: 'Street Address',
                  filled: true,
                  prefixIcon: Icon(Icons.streetview)
                ),
                validator: (value) {
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: TextFormField(
                controller: webController,
                decoration: const InputDecoration(
                  labelText: 'Website',
                  filled: true,
                  prefixIcon: Icon(Icons.link)
                ),
                validator: (value) {
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveContact() {
    if (formKey.currentState!.validate()) {
      final name = nameController.text;
      final number = mobileController.text;
      final email = emailController.text;
      final address = addressController.text;
      final web = webController.text;

      final contact = ContactModel(
        name: name,
        number: number,
        email: email,
        address: address,
        website: web
      );

      context.read<ContactProvider>()
          .addContact(contact)
          .then((rowId) => Navigator.pop(context))
          .catchError((onError) {
            print(onError.toString());
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    mobileController.dispose();
    super.dispose();
  }
}
