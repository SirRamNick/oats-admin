import 'package:admin/components/admin_appbar.dart';
import 'package:admin/components/admin_drawer.dart';
import 'package:admin/components/results_helpbutton.dart';
import 'package:admin/components/alumni_list_view.dart';
import 'package:admin/components/search_widget.dart';
import 'package:admin/constants.dart';
import 'package:admin/services/firebase.dart';
import 'package:admin/services/pagination.dart';
import 'package:admin/services/search.dart';
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
  final CollectionReference alumniList = FirestoreService().alumni;
  late final TextEditingController searchController;
  late String searchStringQuery = widget.searchText;
  late SearchBy searchParam = widget.searchParameter;
  late Stream alumniStream;

  void _updateStream() {
    Query alumniQuery = alumniList;
    alumniQuery = SearchService.getSearchQuery(
      searchQuery: alumniQuery,
      searchStringQuery: searchStringQuery,
      searchParameter: searchParam,
    );

    if (PaginationService.lastDocument != null) {
      alumniQuery =
          alumniQuery.startAfterDocument(PaginationService.lastDocument!);
    }

    alumniQuery = alumniQuery.limit(pageSize);
    alumniStream = alumniQuery.snapshots();
  }

  @override
  void initState() {
    super.initState();
    searchStringQuery = widget.searchText;
    searchParam = widget.searchParameter;
    searchController = TextEditingController(text: searchStringQuery);
    PaginationService.performSearchQuery(
      firebaseCollection: alumniList,
      searchStringQuery: searchStringQuery,
      searchParameter: searchParam,
    );
    _updateStream();
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchByPopupMenuKey = GlobalKey<PopupMenuButtonState>();
    final degreePopupMenuKey = GlobalKey<PopupMenuButtonState>();

    return Scaffold(
      appBar: adminAppBar(context),
      drawer: adminDrawer(context, widget.model),
      floatingActionButton: resultsHelpActionButton(context),
      body: ListView(
        children: [
          SearchWidget(
            searchController: searchController,
            searchParam: widget.searchParameter,
            onSubmit: (value) async {
              setState(() {
                searchStringQuery = value;
                PaginationService.performSearchQuery(
                  firebaseCollection: alumniList,
                  searchStringQuery: searchStringQuery,
                  searchParameter: searchParam,
                );
                _updateStream();
              });
            },
            popupButtonOnSelected: (selected) {
              setState(() {
                searchController.clear();
                searchStringQuery = '';
                searchParam = selected;
              });
            },
            degreePopupItemOnTap: (searchString) {
              setState(() {
                searchStringQuery = searchController.text = searchString;
                PaginationService.performSearchQuery(
                  firebaseCollection: alumniList,
                  searchStringQuery: searchStringQuery,
                  searchParameter: searchParam,
                );
                _updateStream();
              });
            },
            searchByPopupMenuKey: searchByPopupMenuKey,
            degreePopupMenuKey: degreePopupMenuKey,
          ),
          StreamBuilder(
              stream: alumniStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active ||
                    snapshot.connectionState == ConnectionState.done) {
                  return AlumniListView(list: snapshot.data.docs);
                } else {
                  return Container(
                    margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                    width: double.infinity,
                    height: 200,
                    decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: const Color.fromARGB(255, 207, 171, 38)),
                    child: const Center(
                      child: SpinKitWave(color: Colors.black),
                    ),
                  );
                }
              }),
          // Page Controller
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: TextButton.styleFrom(
                  backgroundColor: PaginationService.hasPreviousPage
                      ? const Color(0xFF0B085F)
                      : Colors.grey,
                ),
                onPressed: PaginationService.hasPreviousPage
                    ? () async {
                        await PaginationService.loadPreviousPage();
                        setState(() {
                          _updateStream();
                        });
                      }
                    : null,
                child: const Text(
                  "Previous",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 20),
              Text("Page ${PaginationService.currentPage}"),
              const SizedBox(width: 20),
              ElevatedButton(
                style: TextButton.styleFrom(
                  backgroundColor: PaginationService.hasNextPage
                      ? const Color(0xFF0B085F)
                      : Colors.grey,
                ),
                onPressed: PaginationService.hasNextPage
                    ? () async {
                        await PaginationService.loadNextPage();
                        setState(() {
                          _updateStream();
                        });
                      }
                    : null,
                child: const Text(
                  "Next",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
