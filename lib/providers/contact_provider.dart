import 'package:contact_app/db/db_helper.dart';
import 'package:contact_app/model/contact_model.dart';
import 'package:flutter/foundation.dart';

class ContactProvider extends ChangeNotifier {
  List<ContactModel> contactList = [];
  final db = DbHelper();

  Future<int> addContact(ContactModel contactModel) async {
    var rowId = db.insertContact(contactModel);
    getAllContact();
    return rowId;
  }

  Future<void> getAllContact() async {
    contactList =  await db.getAllContact();
    notifyListeners();
  }

  Future<void> getAllFavouriteContact() async {
    contactList =  await db.getAllFavouriteContact();
    notifyListeners();
  }

  Future<int> updateContactSingleColumn(int rowId, String column, dynamic value) async {
    final id = db.updateTableSingleColumn(rowId, {column: value});
    await getAllContact();
    return id;
  }

  Future<int> deleteContact(int rowId) async {
    var id = db.deleteContact(rowId);
    await getAllContact();
    return  id;
  }
}