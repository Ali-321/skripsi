class Product2 {
  Product2({
    required this.id,
    required this.name,
    required this.category,
    required this.image,
    required this.price,
    required this.vMoney,
    required this.bonus,
  });
  int id = 0;
  String name = ""; // nama game yang ingin di top up
  String category = ""; // kategori uang virtual game
  String image = "";
  int vMoney = 0;
  int bonus = 0;
  int price = 0;

  static Product2 fromJson(Map<String, dynamic> json) => Product2(
      id: json['id'] as int,
      name: json['name'].toString(),
      category: json['category'].toString(),
      image: json['image'].toString(),
      vMoney: json['vMoney'] as int,
      bonus: json['bonus'] as int,
      price: json['price'] as int);
}
