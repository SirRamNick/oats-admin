import 'package:admin/components/admin_appbar.dart';
import 'package:admin/components/admin_drawer.dart';
import 'package:admin/components/page_transition.dart';
import 'package:admin/components/results_helpbutton.dart';
import 'package:admin/constants.dart';
import 'package:admin/pages/profile_page.dart';
import 'package:admin/services/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ResultsPage extends StatefulWidget {
  final GenerativeModel model;
  final String searchText;
  final SearchBy searchParameter;
  const ResultsPage({
    super.key,
    required this.searchText,
    required this.searchParameter,
    required this.model,
  });

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  FirestoreService alumniBase = FirestoreService();
  late final TextEditingController searchController;
  late String searchStringQuery = widget.searchText;
  late SearchBy searchParam = widget.searchParameter;
  int? alumniCount;

  int pageSize = 10;
  int currentPage = 1;
  DocumentSnapshot? lastDocument;
  bool hasNextPage = true;
  bool hasPreviousPage = false;
  List<DocumentSnapshot> currentPageData = [];
  List<DocumentSnapshot> previousPageLastDocuments = [];

  PopupMenuItem degreePopupMenuItem(
          String degree, String searchStringForDegree) =>
      PopupMenuItem(
        child: Text(degree),
        onTap: () {
          setState(() {
            searchStringQuery = searchController.text = searchStringForDegree;
          });
        },
      );

  Query getAlumniQuery(SearchBy selected) {
    Query alumniQuery = alumniBase.alumni.limit(pageSize);

    // TODO: This conflicts with search querying
    if (lastDocument != null) {
      alumniQuery = alumniQuery.startAfterDocument(lastDocument!);
    }

    if (searchStringQuery != '') {
      if (selected == SearchBy.name) {
        return alumniQuery.where('searchable_name',
            arrayContains: searchStringQuery);
      } else if (selected == SearchBy.yearGraduated) {
        return alumniQuery.where('year_graduated',
            isEqualTo: searchStringQuery);
      } else if (selected == SearchBy.program) {
        return alumniQuery.where('degree', isEqualTo: searchStringQuery);
      }
    }
    return alumniQuery;
  }

  Future<void> loadNextPage() async {
    if (!hasNextPage) return;

    Query query = getAlumniQuery(searchParam);
    QuerySnapshot querySnapshot = await query.get();

    if (querySnapshot.docs.isNotEmpty) {
      setState(() {
        lastDocument = querySnapshot.docs.last;
        previousPageLastDocuments.add(lastDocument!);
        currentPageData = querySnapshot.docs;
        currentPage++;
        hasNextPage = querySnapshot.docs.length == pageSize;
        hasPreviousPage = true;
      });
    } else {
      setState(() {
        hasNextPage = false;
      });
    }
  }

  Future<void> loadPreviousPage() async {
    if (!hasPreviousPage) return;

    setState(() {
      currentPage--;
      if (currentPage == 1) {
        hasPreviousPage = false;
        lastDocument = null;
      } else {
        lastDocument = previousPageLastDocuments.removeLast();
      }
      hasNextPage = true;
    });

    Query query = getAlumniQuery(searchParam);
    QuerySnapshot querySnapshot = await query.get();

    if (querySnapshot.docs.isNotEmpty) {
      setState(() {
        currentPageData = querySnapshot.docs;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController(text: searchStringQuery);
    searchStringQuery = widget.searchText;
    searchParam = widget.searchParameter;
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    Query query = getAlumniQuery(searchParam);
    QuerySnapshot querySnapshot = await query.get();

    if (querySnapshot.docs.isNotEmpty) {
      setState(() {
        currentPageData = querySnapshot.docs;
        lastDocument = querySnapshot.docs.last;
        hasNextPage = querySnapshot.docs.length == pageSize;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    // final double screenHeight = MediaQuery.of(context).size.height;
    final searchByPopupMenu = GlobalKey<PopupMenuButtonState>();
    final degreePopupMenu = GlobalKey<PopupMenuButtonState>();

    return Scaffold(
      appBar: adminAppBar(context),
      drawer: adminDrawer(context, widget.model),
      body: ListView(
        children: [
          // Search Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Search field
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 17,
                    top: 17,
                    right: 8.5,
                    bottom: 8.5,
                  ),
                  child: TextField(
                    controller: searchController,
                    enabled: true,
                    decoration: InputDecoration(
                      hintText: searchParam == SearchBy.name
                          ? "Search alumni"
                          : searchParam == SearchBy.yearGraduated
                              ? "Search by graduation year"
                              : searchParam == SearchBy.program
                                  ? "Search by degree"
                                  : "Search",
                      fillColor: Colors.white,
                      border: const OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF1D4695),
                          width: 2,
                        ),
                      ),
                      filled: true,
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchStringQuery = value;
                        currentPage = 1;
                        lastDocument = null;
                        previousPageLastDocuments.clear();
                        // hasNextPage = true; // assumes that search query has next page even if there's none
                        hasPreviousPage = false;
                        loadInitialData();
                      });
                    },
                  ),
                ),
              ),
              // 'Search by' button
              Padding(
                padding: const EdgeInsets.only(
                  left: 8.5,
                  top: 17,
                  right: 17,
                  bottom: 8.5,
                ),
                child: PopupMenuButton(
                  key: searchByPopupMenu,
                  initialValue: searchParam,
                  tooltip: "Search by",
                  onSelected: (selected) {
                    setState(() {
                      searchController.clear();
                      searchStringQuery = '';
                      searchParam = selected;
                    });
                  },
                  child: ElevatedButton(
                    onPressed: () {
                      searchByPopupMenu.currentState?.showButtonMenu();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(17),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          size: 25,
                          color: Theme.of(context)
                              .primaryTextTheme
                              .bodyMedium
                              ?.color,
                        ),
                        const SizedBox(width: 10),
                        Icon(
                          Icons.arrow_drop_down,
                          color: Theme.of(context)
                              .primaryTextTheme
                              .bodyMedium
                              ?.color,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          searchParam == SearchBy.name
                              ? "Name"
                              : searchParam == SearchBy.yearGraduated
                                  ? "Year Graduated"
                                  : searchParam == SearchBy.program
                                      ? "Degree"
                                      : "Search",
                          style: TextStyle(
                            color: Theme.of(context)
                                .primaryTextTheme
                                .bodyMedium
                                ?.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: SearchBy.name,
                      child: Text("Search by name"),
                    ),
                    const PopupMenuItem(
                      value: SearchBy.yearGraduated,
                      child: Text("Search by year graduated"),
                    ),
                    PopupMenuItem(
                      key: degreePopupMenu,
                      value: SearchBy.program,
                      child: const Text("Search by degree"),
                      onTap: () {
                        showMenu(
                          context: context,
                          position: const RelativeRect.fromLTRB(
                              double.infinity, double.infinity, 0, 0),
                          items: [
                            degreePopupMenuItem(
                              "BS Computer Science",
                              // "BS in Computer Science",
                              "BS in Computer Science",
                            ),
                            degreePopupMenuItem(
                              "Associate in Computer Technology",
                              // "Associate in Computer Technology",
                              "Associate in Computer Technology",
                            ),
                            degreePopupMenuItem(
                              "BEEd Major in General Education",
                              // "Bachelor in Elementary Education Major in General Education",
                              "Bachelor in Elementary Education Major in General Education",
                            ),
                            degreePopupMenuItem(
                              "BSEd Major in English",
                              // "Bachelor Secondary Education Major in English ",
                              "Bachelor Secondary Education Major in English ",
                            ),
                            degreePopupMenuItem(
                              "BSEd Major in Mathematics",
                              // "Bachelor Secondary Education Major in Mathematics ",
                              "Bachelor Secondary Education Major in Mathematics ",
                            ),
                            degreePopupMenuItem(
                              "Bachelor of Arts in English",
                              // "Bachelor of Arts in English ",
                              "Bachelor of Arts in English ",
                            ),
                            degreePopupMenuItem(
                              "BSBA Major in Marketing Management",
                              // "BS in Business Administration Major in Marketing Management ",
                              "BS in Business Administration Major in Marketing Management ",
                            ),
                            degreePopupMenuItem(
                              "BSBA Major in Human Resource Management",
                              // "BS in Business Administration Major in Human Resource Management",
                              "BS in Business Administration Major in Human Resource Management",
                            ),
                            degreePopupMenuItem(
                              "BS Entrepreneurship",
                              // "BS in Entrepreneurship",
                              "BS in Entrepreneurship",
                            ),
                            degreePopupMenuItem(
                              "BS Hospitality Management/Hotel and Restaurant Management",
                              // "BS in Hospitality Management / Hotel and Restaurant Management",
                              "BS in Hospitality Management / Hotel and Restaurant Management",
                            ),
                            degreePopupMenuItem(
                              "BS Tourism Management",
                              // "BS in Tourism Management",
                              "BS in Tourism Management",
                            ),
                            degreePopupMenuItem(
                              "Teacher Certificate Program",
                              // "Teacher Certificate Program",
                              "Teacher Certificate Program",
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          StreamBuilder(
              stream: alumniBase.alumni.snapshots(),
              builder: (context, snapShot) {
                if (!snapShot.hasData) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 17.0),
                    child: Card(
                      child: ListTile(
                        title: Text("Total Surveyed Alumni"),
                        subtitle: Text("Loading..."),
                      ),
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 17.0),
                  child: Card(
                    child: ListTile(
                      title: Text(searchController.text == ''
                          ? "Total Surveyed Alumni"
                          : "Displayed Alumni Count"),
                      subtitle: Text("${snapShot.data!.docs.length}"),
                    ),
                  ),
                );
              }),
          // Alumni List
          Padding(
            padding: const EdgeInsets.only(
              left: 17,
              top: 8.5,
              right: 17,
              bottom: 17,
            ),
            child: StreamBuilder(
              stream: getAlumniQuery(searchParam).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  alumniCount = snapshot.data!.docs.length;
                  List alumniList = snapshot.data!.docs;
                  return SizedBox(
                    width: screenWidth,
                    child: Theme(
                      data: ThemeData(
                        dividerTheme:
                            const DividerThemeData(color: Colors.grey),
                      ),
                      child: DataTable(
                        showCheckboxColumn: false,
                        headingRowHeight: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Colors.grey,
                            width: 0.75,
                          ),
                          color: Colors.white,
                        ),
                        columns: const [
                          DataColumn(
                            label: Expanded(
                              // Sort by name
                              child: Text(
                                "Name",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                "Sex",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                "Degree",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: SizedBox(
                              width: 100,
                              // Sort by name
                              child: Text(
                                "Year Graduated",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Row(
                                children: [
                                  Text(
                                    "Current Employment Status",
                                    style: TextStyle(fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                        rows: alumniList.map(
                          (doc) {
                            return DataRow(
                              onSelectChanged: (selected) {
                                if (selected == true) {
                                  Navigator.push(
                                      context,
                                      normalTransitionTo(
                                        ProfilePage(document: doc),
                                      ));
                                }
                              },
                              cells: [
                                DataCell(
                                  Text(
                                    '${doc['last_name'].toString().toUpperCase()}, ${doc['first_name']}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    doc['sex'],
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    doc['degree'],
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    '${doc['year_graduated']}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    doc['employment_status'],
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  alumniCount = null;
                  return const Center(
                    child: SpinKitFadingCircle(
                      color: Colors.black,
                    ),
                  );
                } else {
                  return const Center();
                }
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: hasPreviousPage ? loadPreviousPage : null,
                child: const Text("Previous"),
              ),
              const SizedBox(width: 20),
              Text("Page $currentPage"),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: hasNextPage ? loadNextPage : null,
                child: const Text("Next"),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: resultsHelpActionButton(context),
    );
  }
}
