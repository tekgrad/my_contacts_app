import 'package:my_contacts_app/data/contact.dart';
import 'package:my_contacts_app/data/db/contact_dao.dart';
import 'package:scoped_model/scoped_model.dart';

class ContactsModel extends Model {
  // If an advanced app is needed THEN ContactDao would NOT be instantiated
  // directly in ContactModel class, instead dependency injection should be
  // used as a design pattern
  final ContactDao _contactDao = ContactDao();

  // _contacts is a private field
  // _underscore prefix acts as a private access modifier
  late List<Contact> _contacts;

  // This is a getter property
  List<Contact> get contacts => _contacts;

  // This is the progress bar that's displayed while waiting
  // for the data to load
  bool _isLoading = true;

  // This is a getter property
  bool get isLoading => _isLoading;

  Future loadContacts() async {
    // This sets load indictator ON
    _isLoading = true;
    notifyListeners();

    // This loads contact DAO (Data Access Objects)
    _contacts = await _contactDao.getAllInSortedOrder();

    // This sets load indictator OFF
    _isLoading = false;
    notifyListeners();
  }

  // These are CRUD (create, read, update, delete)
  Future addContact(Contact contact) async {
    await _contactDao.insert(contact);
    await loadContacts();
    notifyListeners();
  } // addContact

  Future updateContact(Contact contact) async {
    await _contactDao.update(contact);
    await loadContacts();
    notifyListeners();
  } // updateContact

  Future deleteContact(Contact contact) async {
    await _contactDao.delete(contact);
    await loadContacts();
    notifyListeners();
  } // deleteContact

  Future changeFavoriteStatus(Contact contact) async {
    contact.isFavorite = !contact.isFavorite;
    await _contactDao.update(contact);
    _contacts = await _contactDao.getAllInSortedOrder();
    notifyListeners();
  } // changeFavoriteStatus
} // class ContactsModel
