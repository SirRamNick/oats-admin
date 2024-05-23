import 'package:flutter/material.dart';

FloatingActionButton homeHelpActionButton(BuildContext context) =>
    FloatingActionButton.extended(
      backgroundColor: Theme.of(context).primaryColor,
      label: Text(
        "Help",
        style: Theme.of(context).primaryTextTheme.bodyMedium,
      ),
      icon: Icon(
        Icons.help,
        color: Theme.of(context).primaryTextTheme.bodyMedium?.color,
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => Dialog(
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView(
                children: const [
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
                      "It is located at the top-left of the screen. When clicked, it displays the navigation menus for the Homepage, 'Add Alumni' Page, Statistics Page, and 'About OATS' Page.",
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
                      "This is the square field at the top of the screen. It lets you search alumni using their name, the year they graduate or the program they previously enrol",
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
                      "The Alumni List",
                      style: TextStyle(fontSize: 18),
                    ),
                    subtitle: Text(
                      "This is the list located below the search bar. It displays all the names of the alumni that answered the alumni registration site",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.sort),
                    title: Text(
                      "Sort by Name",
                      style: TextStyle(fontSize: 18),
                    ),
                    subtitle: Text(
                      "It is located at the top row of the alumni list with the 'Name' text. It sorts the displayed alumni list by surname. By clicking on it, the list will be sorted by surname in alphabetical order. Clicking on it again will sort the list in reverse alphabetical order. And clicking on it again will go back to its default sorting method.",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.sort),
                    title: Text(
                      "Sort by Year Graduated",
                      style: TextStyle(fontSize: 18),
                    ),
                    subtitle: Text(
                      "It is located at the top row of the alumni list with the 'Year Graduated' text. It sorts the displayed alumni list by the year they have graduated. It functions almost the same as the 'Sort by Name' button, but it sorts by year graduated.",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text(
                      "Alumni Entry",
                      style: TextStyle(fontSize: 18),
                    ),
                    subtitle: Text(
                      "You can click on an entry from the list to check its profile.",
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
