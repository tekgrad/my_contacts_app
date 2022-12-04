import 'package:my_contacts_app/ui/contact/contact_create_page.dart';
import 'package:my_contacts_app/ui/contacts_list/widget/contact_tile.dart';
import 'package:my_contacts_app/ui/model/contacts_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ContactsListPage extends StatefulWidget {
  const ContactsListPage({super.key});

  @override
  State<ContactsListPage> createState() => _ContactsListPageState();
} // class ContactsListPage

class _ContactsListPageState extends State<ContactsListPage> {
  // This runs when the state changes
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
      ),
      body: ScopedModelDescendant<ContactsModel>(
        // The builder runs on every change
        // when notifyListeners() is called from the contacts model
        builder: (context, child, model) {
          if (model.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              itemCount: model.contacts.length,
              // The itemBuilder runs and builds every list item
              itemBuilder: (BuildContext context, int index) {
                return ContactTile(
                  contactIndex: index,
                );
              }, // itemBuilder
            );
          } // NOT isLoading
        }, // builder: (context, child, model)
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.person_add),
        onPressed: () {
          // Navigator is an inherited widget
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ContactCreatePage(),
            ),
          ); // Navigator
        }, // onPressed
      ),
    );
  } // Widget build(BuildContext context)
} // class _ContactsListPageState
