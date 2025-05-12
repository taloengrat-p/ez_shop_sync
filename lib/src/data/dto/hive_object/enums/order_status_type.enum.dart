enum OrderStatusType {
  // — รอการยืนยันคำสั่งซื้อ
  pending, // — รอการยืนยันคำสั่งซื้อ

  confirmed, // — ยืนยันคำสั่งซื้อแล้ว

  cancel,

  processing, // — กำลังดำเนินการจัดเตรียมสินค้า

  ready_to_ship, // — พร้อมจัดส่งแล้ว

  shipped, // — จัดส่งสินค้าแล้ว

  in_transit, // — สินค้ากำลังอยู่ระหว่างการขนส่ง

  out_for_delivery, // — กำลังจัดส่งถึงปลายทาง

  delivered,
  complete,
  undefined;

  factory OrderStatusType.fromString(String? value) {
    switch (value) {
      case 'pending':
        return pending;
      case 'confirmed':
        return confirmed;
      case 'cancel':
        return cancel;
      case 'processing':
        return processing;
      case 'ready_to_ship':
        return ready_to_ship;
      case 'shipped':
        return shipped;
      case 'in_transit':
        return in_transit;
      case 'out_for_delivery':
        return out_for_delivery;
      case 'delivered':
        return delivered;
      case 'complete':
        return complete;

      default:
        return undefined;
    }
  }
}
