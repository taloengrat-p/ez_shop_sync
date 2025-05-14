// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class PaginationResponse<T> {
  QueryDocumentSnapshot? lastDocument;
  int totalItem;
  T data;
  PaginationResponse({this.lastDocument, required this.data, required this.totalItem});
}
