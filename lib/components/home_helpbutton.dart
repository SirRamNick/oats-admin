import 'package:flutter/material.dart';

FloatingActionButton homeHelpActionButton(BuildContext context) =>
    FloatingActionButton.extended(
      backgroundColor: const Color(0xFFFFD22F),
      label: const Text(
        "Help",
        style: TextStyle(
          color: Colors.black
        ),
      ),
      icon: const Icon(
        Icons.help,
        color: Colors.black,
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => const Dialog(
            backgroundColor: Colors.white,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Welcome to OATS Home Page!",
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                      Divider(),
                      ListTile(
                        title: Text(
                          "This help dialog will guide you through the complexities and features of the OATS Home Page.",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.menu),
                        title: Text(
                          "Sidebar Menu",
                          style: TextStyle(fontSize: 18),
                        ),
                        subtitle: Text(
                          "It is located at the top-left of the screen. When clicked, it displays the navigation menus for the Home Page, 'Add Alumni' Page, Statistics Page, and 'About OATS' Page.",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.search),
                        title: Text(
                          "The Search Bar",
                          style: TextStyle(fontSize: 18),
                        ),
                        subtitle: Text(
                          "This is the rectangle editable text box located just below the main logo. It lets you search alumni using their name, the year they graduate or the program they previously enrol.",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.search),
                        title: Text(
                          "The 'Search By' Button",
                          style: TextStyle(fontSize: 18),
                        ),
                        subtitle: Text(
                          "This is the blue button beside the search bar. It lets you select the search options for the search bar by clicking on this button and selecting one from the pop-up menu. Here are the search options: 'Name', 'Year Graduated', 'Program'.",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.list),
                        title: Text(
                          "Search by name",
                          style: TextStyle(fontSize: 18),
                        ),
                        subtitle: Text(
                          "This lets you search alumni by their name, whether it's their first name or last name.",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.list),
                        title: Text(
                          "Search by year graduated",
                          style: TextStyle(fontSize: 18),
                        ),
                        subtitle: Text(
                          "This lets you search alumni by year they graduated to OLOPSC.",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.list),
                        title: Text(
                          "Search by program",
                          style: TextStyle(fontSize: 18),
                        ),
                        subtitle: Text(
                          "This lets you search alumni by the program they previously enrolled.",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
