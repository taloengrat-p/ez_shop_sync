// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';

class PaginationIndexRequest<T> {
  int start;
  int limit;
  QueryDocumentSnapshot? lastDocument;
  bool? descending;
  T? payload;

  PaginationIndexRequest({required this.start, required this.limit, this.lastDocument, this.descending, this.payload});

  @override
  String toString() {
    return 'OrderGetAllRangeRequest(start: $start, limit: $limit, lastDocument: $lastDocument, payload: $payload)';
  }
}
