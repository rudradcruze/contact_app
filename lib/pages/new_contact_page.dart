import 'package:flutter/material.dart';

class NewContactPage extends StatefulWidget {
  const NewContactPage({super.key});
  static const String routeName = '/new_contact';

  @override
  State<NewContactPage> createState() => _NewContactPageState();
}

class _NewContactPageState extends State<NewContactPage> {
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
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
          ],
        ),
      ),
    );
  }

  void _saveContact() {
    if (formKey.currentState!.validate()) {
      final name = nameController.text;
      final number = mobileController.text;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    mobileController.dispose();
    super.dispose();
  }
}
