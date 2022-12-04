import 'dart:io';

import 'package:my_contacts_app/data/contact.dart';
import 'package:my_contacts_app/ui/model/contacts_model.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';

class ContactForm extends StatefulWidget {
  final Contact? editedContact;

  const ContactForm({
    Key? key,
    this.editedContact,
  }) : super(key: key);

  @override
  State<ContactForm> createState() => _ContactFormState();
} // class ContactForm

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();

  late String tmpName;
  late String tmpEmailAddress;
  late String tmpTelephoneNumber;
  File? contactImageFile;

  bool get isEditMode => widget.editedContact != null;
  bool get hasSelectedContactImage => contactImageFile != null;

  @override
  void initState() {
    super.initState();
    contactImageFile = widget.editedContact?.imageFile;
  } // initState

  @override
  Widget build(BuildContext context) {
    return Form(
      // Keys allow access to the form from a different place in the code
      // and retrieve the values entered in the form
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          const SizedBox(height: 10),
          _buildContactPhoto(),
          const SizedBox(height: 10),
          TextFormField(
            // onSaved is a callback function
            onSaved: (value) => tmpName = value!,
            validator: _validateName,
            initialValue: widget.editedContact?.strContactName,
            decoration: InputDecoration(
              labelText: 'Contact Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            // onSaved is a callback function
            onSaved: (value) => tmpEmailAddress = value!,
            validator: _validateEmail,
            initialValue: widget.editedContact?.strContactEmailAddress,
            decoration: InputDecoration(
              labelText: 'Contact Email',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            // onSaved is a callback function
            onSaved: (value) => tmpTelephoneNumber = value!,
            validator: _validateTelephoneNumber,
            initialValue: widget.editedContact?.strContactTelephoneNumber,
            decoration: InputDecoration(
              labelText: 'Contact Telephone Number',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: onSaveContactButtonPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
            ), // style
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Text(
                  'SAVE CONTACT',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                Icon(
                  Icons.person,
                  size: 18,
                ),
              ],
            ),
          )
        ],
      ),
    );
  } // Widget build(BuildContext context)

  // This function returns a widget
  Widget _buildContactPhoto() {
    final quarterSizeOfScreen = MediaQuery.of(context).size.width / 8;
    return Hero(
      // If there are no matching tags found between both routes
      // Hero animation won't happen
      tag: widget.editedContact?.hashCode ?? 0,
      child: GestureDetector(
        onTap: _onContactPhotoTapped,
        child: CircleAvatar(
          radius: quarterSizeOfScreen,
          child: _buildContactFormCircleAvatarContent(quarterSizeOfScreen),
        ),
      ),
    );
  } // _buildContactPhoto

  void _onContactPhotoTapped() async {
    if (!kIsWeb) {
      final imageFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (imageFile != null) {
        setState(() {
          contactImageFile = File(imageFile.path);
        }); // setState
      } // imageFile != null
    } // !kIsWeb
  } // _onContactPhotoTapped

  Widget _buildContactFormCircleAvatarContent(double quarterSizeOfScreen) {
    if (isEditMode || hasSelectedContactImage) {
      return _buildEditModeCircleAvatarContent(quarterSizeOfScreen);
    } else {
      return Icon(
        Icons.person,
        size: quarterSizeOfScreen,
      ); // Icon
    } // NOT (isEditMode)
  } // _buildContactFormCircleAvatarContent

  Widget _buildEditModeCircleAvatarContent(double quarterSizeOfScreen) {
    if (contactImageFile == null) {
      return Text(
        widget.editedContact!.strContactName[0],
        style: TextStyle(fontSize: quarterSizeOfScreen),
      );
    } else {
      return ClipOval(
        child: AspectRatio(
          aspectRatio: 1,
          child: Image.file(
            contactImageFile!,
            fit: BoxFit.cover,
          ),
        ),
      );
    } // contactImageFile NOT isNull
  } // _buildEditModeCircleAvatarContent

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter contact name';
    } // if (value == null || value.isEmpty)
    return null;
  } // _validateName

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return null; // 'Enter contact email (optional)';
    } else if (!EmailValidator.validate(value)) {
      return 'Enter a valid email address';
    } // !EmailValidator.validate(value)
    return null;
  } // _validateEmail

  String? _validateTelephoneNumber(String? value) {
    final telephoneRegEx = RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]');
    if (value == null || value.isEmpty) {
      return 'Enter contact number';
    } else if (!telephoneRegEx.hasMatch(value)) {
      return 'Enter a valid telephone number';
    } // !telephoneRegEx.hasMatch(value)
    return null;
  } // _validateTelephoneNumber

  void onSaveContactButtonPressed() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final myContact = Contact(
        strContactName: tmpName,
        strContactEmailAddress: tmpEmailAddress,
        strContactTelephoneNumber: tmpTelephoneNumber,
        // Elvis operator ?. prevents throwing a NULL pointer exception b/c
        // the expression will instead return NULL if editedContact is NULL
        // ?? is the NULL coalescing operator, which returns the right side
        // if the left side is NULL
        isFavorite: widget.editedContact?.isFavorite ?? false,
        imageFile: contactImageFile,
      ); // Contact
      if (isEditMode) {
        // The database id doesn't change after updating other Contact fields
        myContact.id = widget.editedContact!.id;
        ScopedModel.of<ContactsModel>(context).updateContact(
          myContact,
        ); // updateContact
      } else {
        ScopedModel.of<ContactsModel>(context).addContact(myContact);
      } // NOT (isEditMode)
      // This pops the current page off the stack (i.e., contact form)
      // and returns to the contact list page
      Navigator.of(context).pop();
    } // if (_formKey.currentState!.validate())
  } // onSaveContactButtonPressed
} // class _ContactFormState
