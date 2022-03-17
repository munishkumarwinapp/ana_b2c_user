class PlaceOrderDetailModel {
  late String billDiscount;
  late String companyCode;
  late String itemCode;
  late String itemDescription;
  late String itemDiscount;
  late String itemRemarks;
  late String netTotal;
  late String price;
  late String qty;
  late String slNo;
  late String subTotal;
  late String tax;
  late String total;
  late String transactionNo;
  late String uOMCode;
  PlaceOrderDetailModel({
    required this.billDiscount,
    required this.companyCode,
    required this.itemCode,
    required this.itemDescription,
    required this.itemDiscount,
    required this.itemRemarks,
    required this.netTotal,
    required this.price,
    required this.qty,
    required this.slNo,
    required this.subTotal,
    required this.tax,
    required this.total,
    required this.transactionNo,
    required this.uOMCode,
  });

  Map<String, dynamic> toJsonAttr() => {
        'BillDiscount': billDiscount,
        'CompanyCode': companyCode,
        'ItemCode': itemCode,
        'ItemDescription': itemDescription,
        'ItemDiscount': itemDiscount,
        'ItemRemarks': itemRemarks,
        'NetTotal': netTotal,
        'Price': price,
        'Qty': qty,
        'SlNo': slNo,
        'SubTotal': subTotal,
        'Tax': tax,
        'Total': total,
        'TransactionNo': transactionNo,
        'UOMCode': uOMCode,
      };
}
