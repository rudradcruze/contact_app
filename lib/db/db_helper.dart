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

  Future<int> insertContact(ContactModel contactModel) async {
    final db = await _open();
    return db.insert(tblContact, contactModel.toMap());
  }
}
