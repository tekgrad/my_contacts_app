import 'package:my_contacts_app/data/contact.dart';
import 'package:my_contacts_app/data/db/app_database.dart';
import 'package:sembast/sembast.dart';

// Contact Data Access Object
class ContactDao {
  static const String contactStoreName = 'contacts';
  // SEMBAST Store contains int keys AND Map<String, dynamic> values
  // This converts Contact objects to Map
  final _contactStore = intMapStoreFactory.store(contactStoreName);

  // This is a getter property for shorthand
  Future<Database> get _db async => await AppDatabase.instance.database;

  Future insert(Contact contact) async {
    await _contactStore.add(
      await _db,
      contact.toMap(),
    ); // _contactStore.add
  } // Future insert

  Future update(Contact contact) async {
    final finder = Finder(filter: Filter.byKey(contact.id));
    await _contactStore.update(
      await _db,
      contact.toMap(),
      finder: finder,
    ); // _contactStore.update
  } // Future update

  Future delete(Contact contact) async {
    final finder = Finder(filter: Filter.byKey(contact.id));
    await _contactStore.delete(
      await _db,
      finder: finder,
    ); // _contactStore.delete
  } // Future delete

  Future<List<Contact>> getAllInSortedOrder() async {
    // The finder object can also enable sorting
    final finder = Finder(
      sortOrders: [
        // false indicates that isFavorite will be sorted in descending order
        // isFavorite false is displayed after contacts marked true
        // ERROR CHECK HERE
        SortOrder('kIsFavorite', false),
        SortOrder('kContactName'),
      ], // sortOrders
    );

    // This calls contact store to find contacts in database
    final recordSnapshots = await _contactStore.find(await _db, finder: finder);

    // This makes the snapshots key to contact.id
    // Map iterates over the whole list and provides access to every item
    // it also returns a new list w/ different values (i.e., Contact objects)
    return recordSnapshots.map((snapshot) {
      final contact = Contact.fromMap(snapshot.value);
      contact.id = snapshot.key;
      return contact;
    }).toList();
  } // Future<List<Contact>> getAllInSortedOrder()
} // class ContactDao
