// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';

class PaginationIndexRequest {
  int start;
  int limit;
  QueryDocumentSnapshot? lastDocument;
  bool? descending;

  PaginationIndexRequest({required this.start, required this.limit, this.lastDocument, this.descending = true});

  @override
  String toString() {
    return 'OrderGetAllRangeRequest(start: $start, limit: $limit, lastDocument: $lastDocument)';
  }
}
