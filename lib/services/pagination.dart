import 'package:admin/constants.dart';
import 'package:admin/services/search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaginationService {
  static int currentPage = 1;
  static DocumentSnapshot? lastDocument;
  static List previousPageLastDocuments = [];
  static bool hasNextPage = true;
  static bool hasPreviousPage = false;
  static int _maxPage = 0;
  static late Query query;

  static void performSearchQuery({
    required firebaseCollection,
    required searchStringQuery,
    required searchParameter,
  }) async {
    lastDocument = null;
    previousPageLastDocuments = [];
    currentPage = 1;
    _maxPage = 0;
    hasPreviousPage = false;

    query = firebaseCollection;
    query = SearchService.getSearchQuery(
      searchQuery: query,
      searchStringQuery: searchStringQuery,
      searchParameter: searchParameter,
    );
    final AggregateQuerySnapshot snapshot = await query.count().get();
    int totalDocumentCount = snapshot.count!;
    _maxPage = (totalDocumentCount / pageSize).ceil();

    hasNextPage = !(currentPage >= _maxPage);

    // print("previousDocuments: ${previousPageLastDocuments.length}");
    // print(
    //     "lastDocument: ${lastDocument?.data == null ? 'Empty' : "${lastDocument!['last_name']}, ${lastDocument!['first_name']} ${lastDocument!['middle_name']}"}");
    // print("hasNext: $hasNextPage");
    // print("hasPrevious: $hasPreviousPage");
    // print("currentPage: $currentPage");
    // print("totalDocumentCount: $totalDocumentCount");
    // print("maxPage: $_maxPage");
  }

  static Future<void> loadNextPage() async {
    if (lastDocument != null) {
      query = query.startAfterDocument(PaginationService.lastDocument!);
    }

    query = query.limit(pageSize);
    final snapshot = await query.get();
    if (snapshot.docs.isNotEmpty) {
      lastDocument = snapshot.docs.last;
      previousPageLastDocuments.add(lastDocument);
      hasPreviousPage = true;
      if (currentPage == _maxPage - 1) {
        hasNextPage = false;
      } else if (currentPage < _maxPage) {
        hasNextPage = true;
      }
      currentPage++;
    } else {
      hasNextPage = false;
    }
    // print("previousDocuments: ${previousPageLastDocuments.length}");
    // print(
    //     "lastDocument: ${lastDocument?.data == null ? 'Empty' : "${lastDocument!['last_name']}, ${lastDocument!['first_name']} ${lastDocument!['middle_name']}"}");
    // print("hasNext: $hasNextPage");
    // print("hasPrevious: $hasPreviousPage");
    // print("currentPage: $currentPage");
  }

  static Future<void> loadPreviousPage() async {
    currentPage--;
    previousPageLastDocuments.removeLast();
    hasNextPage = true;
    if (previousPageLastDocuments.isNotEmpty) {
      lastDocument = previousPageLastDocuments.last;
    }
    if (currentPage == 1) {
      hasPreviousPage = false;
      lastDocument = null;
    }
    // print("previousDocuments: ${previousPageLastDocuments.length}");
    // print(
    //     "lastDocument: ${lastDocument?.data == null ? 'Empty' : "${lastDocument!['last_name']}, ${lastDocument!['first_name']} ${lastDocument!['middle_name']}"}");
    // print("hasNext: $hasNextPage");
    // print("hasPrevious: $hasPreviousPage");
    // print("currentPage: $currentPage");
  }
}
