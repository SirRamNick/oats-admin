import 'package:admin/components/admin_appbar.dart';
import 'package:admin/components/admin_drawer.dart';
import 'package:admin/services/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final DocumentSnapshot document;

  const ProfilePage({
    super.key,
    required this.document,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  FirestoreService alumniBase = FirestoreService();

  late final DocumentSnapshot doc;
  late final String firstName;
  late final String lastName;
  late final String middleName;
  late final String email;
  late final String sex;
  late final String program;
  late final int yearGraduated;
  late final String employmentStatus;
  late final String occupation;
  late final String dateOfBirth;
  late final String question1;
  late final String question2;
  late final String question3;
  late final String question4;
  late final String question5;
  late final String question6;

  @override
  void initState() {
    super.initState();
    doc = widget.document;
    firstName = doc['first_name'];
    lastName = doc['last_name'];
    middleName = doc['middle_name'];
    email = doc['email'];
    sex = doc['sex'];
    program = doc['degree'];
    yearGraduated = doc['year_graduated'].runtimeType == String
        ? int.tryParse(doc['year_graduated'])
        : doc['year_graduated'];
    employmentStatus = doc['employment_status'];
    occupation = doc['occupation'];
    dateOfBirth = doc['date_of_birth'];
    question1 = doc['question_1'];
    question2 = doc['question_2'];
    question3 = doc['question_3'];
    question4 = doc['question_4'];
    question5 = doc['question_5'];
    question6 = doc['question_6'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: adminAppBar(context),
      drawer: adminDrawer(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.chevron_left,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "Back",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.only(
                        left: 8,
                        top: 10,
                        right: 15,
                        bottom: 10,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                              "Confirm Delete",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          content: Text(
                            "Delete '$firstName $lastName'?",
                            style: const TextStyle(fontSize: 18),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                alumniBase.deleteAlumnus('${doc.id}');
                                Navigator.of(context).pop();
                              },
                              child: const Text("Yes"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("No"),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Padding(
                      padding: EdgeInsets.only(right: 6),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    label: const Text(
                      "Delete",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.only(
                        left: 15,
                        top: 10,
                        right: 18,
                        bottom: 10,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.only(left: 88, right: 88),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Card(
                          elevation: 4,
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                profileFullName(),
                                IntrinsicHeight(
                                  child: Row(
                                    children: [
                                      profileProgram(),
                                      const SizedBox(width: 4),
                                      const VerticalDivider(),
                                      const SizedBox(width: 4),
                                      profileYearGraduated(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Card(
                          elevation: 4,
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Alumni Personal Information',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                const Divider(),
                                const SizedBox(height: 16),
                                profileSex(),
                                const SizedBox(height: 8),
                                profileDateOfBirth(),
                                const SizedBox(height: 8),
                                profileEmployment(),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Card(
                          elevation: 4,
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Alumni Contact Info',
                                  style: TextStyle(fontSize: 18),
                                ),
                                const Divider(),
                                const SizedBox(height: 16),
                                profileEmail(),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Card(
                          elevation: 3,
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Alumni Feedback',
                                  style: TextStyle(fontSize: 18),
                                ),
                                const Divider(),
                                const SizedBox(height: 16),
                                profileQuestion1(),
                                const SizedBox(height: 8),
                                profileQuestion2(),
                                const SizedBox(height: 8),
                                profileQuestion3(),
                                const SizedBox(height: 8),
                                profileQuestion4(),
                                const SizedBox(height: 8),
                                profileQuestion5(),
                                const SizedBox(height: 8),
                                profileQuestion6(),
                                const SizedBox(height: 30),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // floatingActionButton: profileHelpActionButton(context),
    );
  }

  Align profileQuestion6() {
    return Align(
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "You are satisfied with your current job.",
            style: TextStyle(fontSize: 15),
          ),
          Text(
            question6,
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }

  Align profileQuestion5() {
    return Align(
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "The program you took in OLOPSC matches your current job.",
            style: TextStyle(fontSize: 15),
          ),
          Text(
            question5,
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }

  Align profileQuestion4() {
    return Align(
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "How long does it take for you to land your first job after graduation?",
            style: TextStyle(fontSize: 15),
          ),
          Text(
            question4,
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }

  Align profileQuestion3() {
    return Align(
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Your first job aligns with your current job.",
            style: TextStyle(fontSize: 15),
          ),
          Text(
            question3,
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }

  Align profileQuestion2() {
    return Align(
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "The skills you've mentioned helped you in pursuing your career path.",
            style: TextStyle(fontSize: 15),
          ),
          Text(
            question2,
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }

  Align profileQuestion1() {
    return Align(
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "What are the life skills OLOPSC has taught you?",
            style: TextStyle(fontSize: 15),
          ),
          Text(
            question1,
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }

  Align profileEmployment() {
    return Align(
      alignment: Alignment.topLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Employment",
            style: TextStyle(
                fontSize: 18, color: Color.fromARGB(255, 128, 128, 128)),
          ),
          const SizedBox(
            width: 10,
          ),
          const SizedBox(width: 70),
          Text(
            employmentStatus,
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }

  Align profileProgram() {
    return Align(
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Program",
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          Text(
            program,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Align profileYearGraduated() {
    return Align(
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Year Graduated",
            style: TextStyle(fontSize: 14),
          ),
          Text(
            "$yearGraduated",
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Align profileEmail() {
    return Align(
      alignment: Alignment.topLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Email",
            style: TextStyle(
                fontSize: 18, color: Color.fromARGB(255, 128, 128, 128)),
          ),
          const SizedBox(width: 138),
          Text(
            email,
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }

  Align profileDateOfBirth() {
    return Align(
      alignment: Alignment.topLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Date of Birth",
            style: TextStyle(
                fontSize: 18, color: Color.fromARGB(255, 128, 128, 128)),
          ),
          const SizedBox(width: 80),
          Text(
            dateOfBirth,
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }

  Align profileSex() {
    return Align(
      alignment: Alignment.topLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Sex",
            style: TextStyle(
                fontSize: 18, color: Color.fromARGB(255, 128, 128, 128)),
          ),
          const SizedBox(width: 154),
          Text(
            sex,
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }

  Align profileFullName() {
    return Align(
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Full Name",
            style: TextStyle(fontSize: 16),
          ),
          Text(
            '$firstName, $lastName, $middleName',
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
