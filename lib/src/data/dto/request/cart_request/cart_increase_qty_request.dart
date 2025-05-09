class CartIncreaseQtyRequest {
  String? cartId;
  String? productId;
  num qty;
  CartIncreaseQtyRequest({this.cartId, this.productId, required this.qty});
}
