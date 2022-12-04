import 'dart:async';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class AppDatabase {
  // The only available instance of the AppDatabase class
  // is stored in this private field
  static final AppDatabase _singleton = AppDatabase._();

  // This getter is the only way for classes to access the AppDatabase instance
  static AppDatabase get instance => _singleton;

  // Completer is used for transforming synchronous code into asynchronous code
  Completer<Database>? _dbOpenCompleter;

  // Singleton Pattern makes classes limited to only one instance
  // This way, only one database instance is opened at all times
  // which means it makes sure the same database will be accessed

  // This is a private constructor
  AppDatabase._();

  Future<Database> get database async {
    // If completer isNull THEN database is NOT yet opened
    if (_dbOpenCompleter == null) {
      _dbOpenCompleter = Completer();
      // Calling _openDatabase() will also complete the Completer
      // w/ database instance
      _openDatabase();
    } // if (_dbOpenCompleter == null)
    // If the database is already opened THEN return immediately
    // otherwise wait until complete() is called on the Completer
    // in _openDatabase()
    return _dbOpenCompleter!.future;
  } // Future

  // This returns database w/ path as /platform-specific directory/contacts.db
  // where persistent app data may be stored
  Future _openDatabase() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final dbPath = join(appDocDir.path, 'contacts.db');
    final database = await databaseFactoryIo.openDatabase(dbPath);
    _dbOpenCompleter!.complete(database);
  } // Future
} // class AppDatabase
