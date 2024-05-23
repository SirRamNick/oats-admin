import 'dart:js' as js;
import 'package:admin/components/page_transition.dart';
import 'package:admin/pages/analytics_page.dart';
import 'package:admin/pages/home_page.dart';
import 'package:flutter/material.dart';

Drawer adminDrawer(BuildContext context) => Drawer(
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
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    shape: const LinearBorder(),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(
                        context, instantTransitionTo(const HomePage()));
                  },
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Home"),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    shape: const LinearBorder(),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    js.context.callMethod(
                      'open',
                      [
                        'https://olopsc-alumni-tracking-system.web.app/',
                        '_blank'
                      ],
                    );
                  },
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Add Alumni"),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    shape: const LinearBorder(),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(
                        context, instantTransitionTo(const AnalyticsPage()));
                  },
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Analytics"),
                  ),
                ),
                TextButton(
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
                                "(c) OLOPSC Computer Society 2024",
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
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("About OATS"),
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
