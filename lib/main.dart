/*
Hello World! My name is Frank Giordano. I am a developer. I love writing code
as much as cracking code. This is my first app. I followed the lessons taught
by Matej Resetar -- an instructor at https://academy.zenva.com. I enrolled in
his course online at https://alison.com and successfully completed the course
and earned a certificate. Matej is the best instructor ever. The title of the
course is Introduction to Mobile App Development with Flutter. In this course
Matej teaches how to develop a contact app using Flutter and Dart. I followed
along line by line. However, there were many changes I needed to make because
the course is outdated since it was released in 2019 (Flutter v1.2.1). Tweaks
had to be made while I debugged the code and fixed the errors thrown in order
to get the app updated to the latest version (Flutter v3.3.9 / Dart v2.18.5).
I used Visual Studio Code as the code editor to build my app. I tested my app
on an Android emulator, Chrome web browser and macOS desktop simulator during
development in addition to running my app on a real physical device such as a
Google Pixel 6 Pro. Once I get my contact app published on Google Play Store,
I am planning to add a new feature to group contacts by different categories.
I chose Google Flutter to develop my first app because it's no doubt the best
cross-platform for making awesome natively compiled apps for desktop, mobile,
and web from one codebase. Widgets are also wicked cool! Dart is awesome too.
It's now become one of my favorite programming languages.

The source code for my app is available on GitHub. I'm open to suggestions on
refactoring in addition to adding new features. The link to my Git repository
is https://github.com/tekgrad/my_contacts_app.

Visit my website for more updates at www.tekgrad.com.

Thank you! :)
*/

import 'package:my_contacts_app/ui/contacts_list/contacts_list_page.dart';
import 'package:my_contacts_app/ui/model/contacts_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

void main() {
  runApp(const MyApp());
} // main

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // The ScopedModel widget makes sure ContactModel is accessible anywhere
    // down the widget tree. This is possible b/c of Flutter's InheritedWidget
    return ScopedModel(
      // This is a cascading operator ..
      model: ContactsModel()..loadContacts(),
      child: MaterialApp(
        title: 'Contacts',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const ContactsListPage(),
      ),
    );
  } // Widget build(BuildContext context)
} // class MyApp
