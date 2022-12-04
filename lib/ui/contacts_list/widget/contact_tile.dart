import 'package:my_contacts_app/data/contact.dart';
import 'package:my_contacts_app/ui/contact/contact_edit_page.dart';
import 'package:my_contacts_app/ui/model/contacts_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class ContactTile extends StatelessWidget {
  const ContactTile({
    Key? key,
    required this.contactIndex,
  }) : super(key: key);

  final int contactIndex;

  @override
  Widget build(BuildContext context) {
    final model = ScopedModel.of<ContactsModel>(context);
    final displayedContact = model.contacts[contactIndex];
    return Slidable(
      key: ValueKey(contactIndex),
      startActionPane: ActionPane(
        motion: const BehindMotion(),
        children: [
          SlidableAction(
            backgroundColor: Colors.yellowAccent,
            label: 'Text',
            icon: Icons.chat, // Icons.sms,
            onPressed: (context) => _sendTextMessage(
              context,
              displayedContact.strContactName,
              displayedContact.strContactTelephoneNumber,
            ), // onPressed
          ),
          SlidableAction(
            backgroundColor: Colors.green,
            label: 'Call',
            icon: Icons.phone_in_talk,
            onPressed: (context) => _callTelephoneNumber(
              context,
              displayedContact.strContactName,
              displayedContact.strContactTelephoneNumber,
            ), // onPressed
          ),
          SlidableAction(
            backgroundColor: Colors.blue,
            label: 'Email',
            icon: Icons.mail,
            onPressed: (context) => _sendEmailToContact(
              context,
              displayedContact.strContactName,
              displayedContact.strContactEmailAddress,
            ), // onPressed
          ),
        ], // children
      ),
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        children: [
          SlidableAction(
            backgroundColor: Colors.red,
            label: 'Delete',
            icon: Icons.delete,
            onPressed: (context) {
              model.deleteContact(displayedContact);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Deleted ${displayedContact.strContactName}'),
                ),
              ); // ScaffoldMessenger.of(context).showSnackBar
            }, // onPressed
          ),
        ], // children
      ),
      child: _buildContent(
        displayedContact,
        model,
        context,
      ), // _buildContent
    );
  } // Widget build(BuildContext context)

  Future _sendTextMessage(
    BuildContext context,
    String strContactName,
    String strContactTelephoneNumber,
  ) async {
    final Uri url = Uri(scheme: 'sms', path: strContactTelephoneNumber);
    if (await url_launcher.launchUrl(url)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Texting $strContactName at $strContactTelephoneNumber',
          ),
        ),
      ); // ScaffoldMessenger.of(context).showSnackBar
      await url_launcher.launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to text $strContactName at $strContactTelephoneNumber',
          ),
        ),
      ); // ScaffoldMessenger.of(context).showSnackBar
    } // NOT launched
  } // _sendTextMessage

  Future _callTelephoneNumber(
    BuildContext context,
    String strContactName,
    String strContactTelephoneNumber,
  ) async {
    final Uri url = Uri(scheme: 'tel', path: strContactTelephoneNumber);
    if (await url_launcher.launchUrl(url)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Calling $strContactName at $strContactTelephoneNumber',
          ),
        ),
      ); // ScaffoldMessenger.of(context).showSnackBar
      await url_launcher.launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to call $strContactName at $strContactTelephoneNumber',
          ),
        ),
      ); // ScaffoldMessenger.of(context).showSnackBar
    } // NOT launched
  } // _callTelephoneNumber

  Future _sendEmailToContact(
    BuildContext context,
    String strContactName,
    String strContactEmailAddress,
  ) async {
    final Uri url = Uri(scheme: 'mailto', path: strContactEmailAddress);
    if (await url_launcher.launchUrl(url)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Emailing $strContactName at $strContactEmailAddress',
          ),
        ),
      ); // ScaffoldMessenger.of(context).showSnackBar
      await url_launcher.launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to email $strContactName at $strContactEmailAddress',
          ),
        ),
      ); // ScaffoldMessenger.of(context).showSnackBar
    } // NOT launched
  } // _sendEmailToContact

  ListTile _buildContent(
      Contact displayedContact, ContactsModel model, BuildContext context) {
    String subtitle1 = '';
    String subtitle2 = '';
    if (displayedContact.strContactEmailAddress.isNotEmpty) {
      subtitle1 = displayedContact.strContactEmailAddress;
      subtitle2 = displayedContact.strContactTelephoneNumber;
    } else {
      subtitle1 = displayedContact.strContactTelephoneNumber;
    }
    return ListTile(
      title: Text(displayedContact.strContactName),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subtitle1),
          Text(subtitle2),
        ], // [ ]
      ),
      leading: _buildAnimation(displayedContact),
      trailing: IconButton(
        onPressed: () {
          model.changeFavoriteStatus(displayedContact);
        }, // onPressed
        icon: Icon(
          displayedContact.isFavorite ? Icons.star : Icons.star_border,
          color: displayedContact.isFavorite ? Colors.amber : Colors.grey,
        ),
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ContactEditPage(
              editedContact: displayedContact,
            ),
          ),
        ); // Navigator
      }, // onTap
    );
  } // _buildContent

  Hero _buildAnimation(Contact displayedContact) {
    // Hero widget makes animation possible between routes (pages)
    // The tag needs to be identical AND unique in both routes
    return Hero(
      // hashCode returns an unique integer based on displayedContact
      tag: displayedContact.hashCode,
      child: CircleAvatar(
        child: _buildListTileCircleAvatarContent(displayedContact),
      ),
    );
  } // _buildAnimation

  Widget _buildListTileCircleAvatarContent(Contact displayedContact) {
    if (displayedContact.imageFile == null) {
      return Text(
        displayedContact.strContactName[0],
      ); // Text
    } else {
      return ClipOval(
        child: AspectRatio(
          aspectRatio: 1,
          child: Image.file(
            displayedContact.imageFile!,
            fit: BoxFit.cover,
          ),
        ),
      );
    } // displayedContact.imageFile NOT isNull
  } // _buildListTileCircleAvatarContent
} // class ContactTile
