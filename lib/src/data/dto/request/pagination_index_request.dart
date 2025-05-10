// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';

class PaginationIndexRequest {
  int start;
  int end;
  int limit;
  QueryDocumentSnapshot? lastDocument;
  PaginationIndexRequest({required this.start, required this.end, required this.limit, this.lastDocument});

  @override
  String toString() {
    return 'OrderGetAllRangeRequest(start: $start, end: $end, limit: $limit, lastDocument: $lastDocument)';
  }
}
