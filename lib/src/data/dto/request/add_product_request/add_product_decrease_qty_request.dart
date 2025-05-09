class AddProductDecreaseQtyRequest {
  String? cartId;
  String? productId;
  num qty;
  AddProductDecreaseQtyRequest({this.cartId, this.productId, required this.qty});
}
