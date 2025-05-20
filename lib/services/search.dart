import 'package:admin/models/search_by.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService {
  static Query getSearchQuery({
    required searchQuery,
    required searchStringQuery,
    required searchParameter,
  }) {
    if (searchStringQuery != '') {
      if (searchParameter == SearchBy.name) {
        searchQuery = searchQuery.where('searchable_name',
            arrayContains: searchStringQuery);
      } else if (searchParameter == SearchBy.yearGraduated) {
        searchQuery =
            searchQuery.where('year_graduated', isEqualTo: searchStringQuery);
      } else if (searchParameter == SearchBy.program) {
        searchQuery = searchQuery.where('degree', isEqualTo: searchStringQuery);
      }
    }
    return searchQuery;
  }
}
