import 'package:contact_app/model/contact_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DbHelper {
  final String _createTableContact = '''create table $tblContact(
    $tblContactColId integer primary key,
    $tblContactColName text,
    $tblContactColNumber text,
    $tblContactColEmail text,
    $tblContactColAddress text,
    $tblContactColWebsite text,
    $tblContactColFavorite integer)''';

  Future<Database> _open() async {
    final root = await getDatabasesPath();
    final dbPath = path.join(root, 'contact.db');
    return openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        db.execute(_createTableContact);
      },
    );
  }

  // Insert Contact
  Future<int> insertContact(ContactModel contactModel) async {
    final db = await _open();
    return db.insert(tblContact, contactModel.toMap());
  }

  //  Get all contact from table
  Future<List<ContactModel>> getAllContact() async {
    final db = await _open();
    final List<Map<String, dynamic>> mapList = await db.query(tblContact);
    return List.generate(mapList.length, (index) => ContactModel.fromMap(mapList[index]));
  }

  //  Get all favourite contact from table
  Future<List<ContactModel>> getAllFavouriteContact() async {
    final db = await _open();
    final List<Map<String, dynamic>> mapList = await db.query(tblContact, where: '$tblContactColFavorite = ?', whereArgs: [1]);
    return List.generate(mapList.length, (index) => ContactModel.fromMap(mapList[index]));
  }

  // Update table tbl_contact favourite 1 where id = 1
  Future<int> updateTableSingleColumn(int rowId, Map<String, dynamic> map) async {
    final db = await _open();
    return db.update(tblContact, map, where: '$tblContactColId = ?', whereArgs: [rowId]);
  }

  // Delete contact
  Future<int> deleteContact(int rowId) async {
    final db = await _open();
    return db.delete(tblContact, where: '$tblContactColId = ?', whereArgs: [rowId]);
  }
}
