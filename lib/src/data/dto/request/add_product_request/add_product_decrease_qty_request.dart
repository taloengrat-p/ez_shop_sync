class AddProductDecreaseQtyRequest {
  String? addProductId;
  String? orderItemId;
  num qty;
  AddProductDecreaseQtyRequest({this.addProductId, this.orderItemId, required this.qty});
}
