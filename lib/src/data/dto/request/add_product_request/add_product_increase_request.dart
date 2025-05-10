class AddProductIncreaseRequest {
  String? addProductId;
  String? orderItemId;
  num qty;
  AddProductIncreaseRequest({this.addProductId, this.orderItemId, required this.qty});
}
