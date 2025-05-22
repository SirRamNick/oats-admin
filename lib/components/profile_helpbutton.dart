import 'package:flutter/material.dart';

FloatingActionButton profileHelpActionButton(BuildContext context) =>
    FloatingActionButton.extended(
      backgroundColor: const Color(0xFFFFD22F),
      foregroundColor: Colors.black,
      label: const Text("Help"),
      icon: const Icon(Icons.help),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Close"),
              ),
            ],
            content: const SingleChildScrollView(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Welcome to OATS Profile Page!",
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      "This help dialog will guide you through the complexities and features of the OATS Profile Page.",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.edit),
                    title: Text(
                      "Edit Alumni",
                      style: TextStyle(fontSize: 18),
                    ),
                    subtitle: Text(
                      "This is located at the top-right corner of the screen. It lets you edit the information of the alumnus/alumna.",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
