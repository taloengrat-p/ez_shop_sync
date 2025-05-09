class AddProductIncreaseRequest {
  String? cartId;
  String? productId;
  num qty;
  AddProductIncreaseRequest({this.cartId, this.productId, required this.qty});
}
