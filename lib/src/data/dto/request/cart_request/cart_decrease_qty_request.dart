class CartDecreaseQtyRequest {
  String? cartId;
  String? productId;
  num qty;
  CartDecreaseQtyRequest({this.cartId, this.productId, required this.qty});
}
