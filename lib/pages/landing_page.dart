import "package:admin/components/admin_appbar.dart";
import "package:admin/components/admin_drawer.dart";
import "package:admin/constants.dart";
import "package:admin/pages/home_page.dart";
import "package:flutter/material.dart";
import "package:google_generative_ai/google_generative_ai.dart";

class LandingPage extends StatefulWidget {
  final GenerativeModel model;
  const LandingPage({
    super.key,
    required this.model,
  });

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final TextEditingController searchController = TextEditingController();
  late String searchStringQuery = '';
  late SearchBy searchParam = SearchBy.name;
  bool showSearchButton = false;

  PopupMenuItem degreePopupMenuItem(
          String degree, String searchStringForDegree) =>
      PopupMenuItem(
        child: Text(degree),
        onTap: () {
          setState(() {
            searchStringQuery = searchController.text = searchStringForDegree;
            showSearchButton = true;
            gotoHomePage();
          });
        },
      );

  void gotoHomePage() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => HomePage(
            searchText: searchController.text,
            searchParameter: searchParam,
            model: widget.model)));
  }

  @override
  Widget build(BuildContext context) {
    final searchByPopupMenu = GlobalKey<PopupMenuButtonState>();
    final degreePopupMenu = GlobalKey<PopupMenuButtonState>();

    return Scaffold(
        appBar: adminAppBar(context, displayHeader: false),
        drawer: adminDrawer(context, widget.model),
        backgroundColor: Theme.of(context).primaryColor,
        body: Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                'https://lh3.googleusercontent.com/d/1MGemsbZGVRh9g_cJMi7fGDz51L9hTC4x',
              ),
              fit: BoxFit.cover,
              opacity: 0.15,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Column(
                      children: [
                        Image.network(
                          'https://lh3.googleusercontent.com/d/1tUIidRs4zuCSM8phHqcoVFOAWXOoYnd4',
                          cacheWidth: 740,
                          cacheHeight: 263,
                        ),
                        SizedBox(
                          width: 900,
                          child: Row(
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
                                      suffixIcon: searchStringQuery != ''
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 5),
                                              child: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    searchController.clear();
                                                    searchStringQuery = '';
                                                    showSearchButton = false;
                                                  });
                                                },
                                                icon: const Icon(Icons.clear),
                                              ),
                                            )
                                          : null,
                                      hintText: searchParam == SearchBy.name
                                          ? "Search alumni"
                                          : searchParam ==
                                                  SearchBy.yearGraduated
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
                                        if (searchStringQuery != '') {
                                          showSearchButton = true;
                                        } else {
                                          showSearchButton = false;
                                        }
                                      });
                                    },
                                    onSubmitted: (value) {
                                      gotoHomePage();
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
                                      searchByPopupMenu.currentState
                                          ?.showButtonMenu();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFFFD22F),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.only(
                                        left: 10,
                                        top: 17,
                                        right: 17,
                                        bottom: 17,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.arrow_drop_down,
                                          color: Colors.black,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          searchParam == SearchBy.name
                                              ? "Name"
                                              : searchParam ==
                                                      SearchBy.yearGraduated
                                                  ? "Year Graduated"
                                                  : searchParam ==
                                                          SearchBy.program
                                                      ? "Degree"
                                                      : "Search",
                                          style: const TextStyle(
                                            color: Colors.black,
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
                                              double.infinity,
                                              double.infinity,
                                              0,
                                              0),
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
                              // Search Button
                              showSearchButton == true
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                        top: 17,
                                        right: 17,
                                        bottom: 8.5,
                                      ),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          gotoHomePage();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFF1D4695),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          padding: const EdgeInsets.only(
                                            left: 14,
                                            top: 17,
                                            right: 17,
                                            bottom: 17,
                                          ),
                                        ),
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.search,
                                              size: 25,
                                              color: Colors.white,
                                            ),
                                            SizedBox(width: 10),
                                            SizedBox(width: 5),
                                            Text(
                                              "Search",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
