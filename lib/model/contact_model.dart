const String tblContact = 'tbl_contact';
const String tblContactColId = 'id';
const String tblContactColName = 'name';
const String tblContactColEmail = 'email';
const String tblContactColNumber = 'number';
const String tblContactColAddress = 'address';
const String tblContactColWebsite = 'website';
const String tblContactColFavorite = 'favorite';

class ContactModel {
  int? id;
  String name;
  String number;
  String? email;
  String? address;
  String? website;
  bool favorite = false;

  ContactModel(
      {this.id,
      required this.name,
      required this.number,
      this.email,
      this.address,
      this.website,
      this.favorite = false});

  factory ContactModel.fromMap(Map<String, dynamic> map) => ContactModel(
        id: map[tblContactColId],
        name: map[tblContactColName],
        number: map[tblContactColNumber],
        email: map[tblContactColEmail],
        address: map[tblContactColAddress],
        website: map[tblContactColWebsite],
        favorite: map[tblContactColFavorite] == 1 ? true : false,
      );

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      tblContactColName: name,
      tblContactColNumber: number,
      tblContactColEmail: email,
      tblContactColAddress: address,
      tblContactColWebsite: website,
      tblContactColFavorite: favorite ? 1 : 0,
    };

    if (id != null) {
      map[tblContactColId] = id;
    }

    return map;
  }
}
