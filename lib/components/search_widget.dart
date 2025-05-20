import "package:admin/models/search_by.dart";
import "package:flutter/material.dart";

class SearchWidget extends StatefulWidget {
  final TextEditingController searchController;
  final SearchBy searchParam;
  final Function(dynamic value) onSubmit;
  final Function(dynamic selected) popupButtonOnSelected;
  final Function(dynamic searchString) degreePopupItemOnTap;
  final GlobalKey<PopupMenuButtonState> searchByPopupMenuKey;
  final GlobalKey<PopupMenuButtonState> degreePopupMenuKey;

  const SearchWidget({
    required this.searchController,
    required this.searchParam,
    required this.onSubmit,
    required this.popupButtonOnSelected,
    required this.degreePopupItemOnTap,
    required this.searchByPopupMenuKey,
    required this.degreePopupMenuKey,
    super.key,
  });

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  late SearchBy searchParam;

  PopupMenuItem degreePopupMenuItem(
          String degree, String searchStringForDegree) =>
      PopupMenuItem(
        child: Text(degree),
        onTap: () {
          widget.degreePopupItemOnTap(searchStringForDegree);
        },
      );

  @override
  void initState() {
    searchParam = widget.searchParam;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
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
              controller: widget.searchController,
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
              onSubmitted: (value) {
                widget.onSubmit(value);
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
            key: widget.searchByPopupMenuKey,
            initialValue: searchParam,
            tooltip: "Search by",
            onSelected: (selected) {
              widget.popupButtonOnSelected(selected);
              setState(() {
                searchParam = selected;
              });
            },
            child: ElevatedButton(
              onPressed: () {
                widget.searchByPopupMenuKey.currentState?.showButtonMenu();
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
                    color: Theme.of(context).primaryTextTheme.bodyMedium?.color,
                  ),
                  const SizedBox(width: 10),
                  Icon(
                    Icons.arrow_drop_down,
                    color: Theme.of(context).primaryTextTheme.bodyMedium?.color,
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
                      color:
                          Theme.of(context).primaryTextTheme.bodyMedium?.color,
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
                key: widget.degreePopupMenuKey,
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
    );
  }
}
