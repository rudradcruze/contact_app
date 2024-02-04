import 'package:contact_app/db/db_helper.dart';
import 'package:contact_app/model/contact_model.dart';
import 'package:flutter/foundation.dart';

class ContactProvider extends ChangeNotifier {
  List<ContactModel> contactModels = [];
  final db = DbHelper();

  Future<int> addContact(ContactModel contactModel) async {
    return db.insertContact(contactModel);
  }
}