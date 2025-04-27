class PreviousOrderModel {

  final String productId;
  final String productName;
  final String productImage;
  final int productPrice;
  final int quantity;
  final DateTime orderDate;


  PreviousOrderModel({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.productPrice,
    required this.quantity,
    required this.orderDate,
  });
  factory PreviousOrderModel.fromJson(Map<String, dynamic> json) {
    return PreviousOrderModel(
      productId: json['productId'],
      productName: json['name'],
      productImage: json['image'],
      productPrice: json['price'],
      quantity: json['quantity'],
      orderDate: DateTime.parse(json['orderDate']),
    );
  }

}