import 'dart:js' as js;
import 'package:admin/components/page_transition.dart';
import 'package:admin/components/two_option_dialog.dart';
import 'package:admin/pages/analytics_page.dart';
import 'package:admin/auth_gate.dart';
import 'package:admin/pages/home_page.dart';
import 'package:admin/services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

AuthenticationService _auth = AuthenticationService();

Drawer adminDrawer(BuildContext context, GenerativeModel model) => Drawer(
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                  child: DrawerHeader(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            SizedBox.square(
                              dimension: 50,
                              child: Image.network(
                                'https://lh3.googleusercontent.com/d/1O2POF0-t3i3tnRK0rp7MQ06PhGAgUZ8T',
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Our Lady of Perpetual Succor College",
                                  style: TextStyle(fontSize: 11),
                                ),
                                Text(
                                  "Alumni Tracking System",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.home),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    shape: const LinearBorder(),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(
                        context,
                        normalTransitionTo(HomePage(
                          model: model,
                        )));
                  },
                  label: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Home"),
                  ),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.add),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    shape: const LinearBorder(),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    js.context.callMethod(
                      'open',
                      ['https://olopsc-forms.web.app/', '_blank'],
                    );
                  },
                  label: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Add Alumni"),
                  ),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.analytics),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    shape: const LinearBorder(),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(context,
                        normalTransitionTo(AnalyticsPage(model: model)));
                  },
                  label: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Analytics"),
                  ),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.code),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    shape: const LinearBorder(),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    showAboutDialog(
                        context: context,
                        applicationName:
                            'OLOPSC Alumni Tracking System (Admin Site)',
                        children: [
                          const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Team Adviser/Developer",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                "Rame Nicholas Tiongson",
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "System Analyst/Developer",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "Rovic Xavier Aliman",
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Documentations Specialist",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "Amparito Orticio",
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Documentations Associates",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "Jaydee Moles",
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                "Marvin Uneta",
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 15),
                              Text(
                                "© OLOPSC Computer Society 2025",
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                "All rights reserved",
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ]);
                  },
                  label: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("About OATS"),
                  ),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.logout),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    shape: const LinearBorder(),
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => TwoOptionDialog(
                              title: "Confirm Sign-out",
                              content: "Are you sure you wanted to sign out?",
                              firstOptionText: "Yes",
                              secondOptionText: "No",
                              onFirstOptionPressed: () {
                                _auth.signOut();
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AuthGate(model: model)));
                              },
                            ));
                  },
                  label: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Sign-out"),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 12,
              ),
              child: Column(
                children: [
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Developed by:",
                        style: TextStyle(fontSize: 10),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                        ),
                        child: Image.network(
                          height: 30,
                          width: 30,
                          'https://lh3.googleusercontent.com/d/1sq-wq-6VWSD6zMVU5QC6Uv1aT9mVbm-E',
                        ),
                      ),
                      const Text(
                        "OLOPSC Computer Society",
                        style: TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
