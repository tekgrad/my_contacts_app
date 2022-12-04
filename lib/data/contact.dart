import 'dart:io';

class Contact {
  // This is the database id (key)
  int? id;

  String strContactName;
  String strContactEmailAddress;
  String strContactTelephoneNumber;
  bool isFavorite;
  File? imageFile;

  // This is a constructor w/ optional named parameters inside {}
  Contact({
    required this.strContactName,
    required this.strContactEmailAddress,
    required this.strContactTelephoneNumber,
    this.isFavorite = false,
    this.imageFile,
  }); // constructor

  // This function returns a Map (i.e., converts contacts to maps)
  // Map contains key-value pairs like JSON
  // key is String AND value is dynamic
  Map<String, dynamic> toMap() {
    // Map literals are created w/ curly braces {}
    return {
      'kContactName': strContactName,
      'kContactEmail': strContactEmailAddress,
      'kContactTelephoneNumber': strContactTelephoneNumber,
      'kIsFavorite': isFavorite ? 1 : 0,
      'kImageFilePath': imageFile?.path
    }; // return
  } // Map

  // This is a static function to create objects from Map
  // by converting maps to contacts
  static Contact fromMap(Map<String, dynamic> map) {
    return Contact(
      strContactName: map['kContactName'],
      strContactEmailAddress: map['kContactEmail'],
      strContactTelephoneNumber: map['kContactTelephoneNumber'],
      isFavorite: map['kIsFavorite'] == 1 ? true : false,
      imageFile:
          map['kImageFilePath'] != null ? File(map['kImageFilePath']) : null,
    );
  } // static
} // class Contact
