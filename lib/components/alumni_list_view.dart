import "package:admin/components/page_transition.dart";
import "package:admin/pages/profile_page.dart";
import "package:flutter/material.dart";
import "package:google_generative_ai/google_generative_ai.dart";

class AlumniListView extends StatelessWidget {
  final List list;
  final GenerativeModel model;

  const AlumniListView({
    super.key,
    required this.list,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) {
      return const SizedBox(
        width: double.infinity,
        height: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search,
                size: 30,
                color: Colors.black,
              ),
              SizedBox(height: 10),
              Text("No results found"),
            ],
          ),
        ),
      );
    }
    return Padding(
        padding: const EdgeInsets.only(
          left: 17,
          top: 8.5,
          right: 17,
          bottom: 17,
        ),
        child: SizedBox(
          child: Theme(
            data: ThemeData(
              dividerTheme: const DividerThemeData(color: Colors.grey),
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
              rows: list.map(
                (doc) {
                  return DataRow(
                    onSelectChanged: (selected) {
                      if (selected == true) {
                        Navigator.push(
                            context,
                            normalTransitionTo(
                              ProfilePage(document: doc, model: model),
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
        ));
  }
}
