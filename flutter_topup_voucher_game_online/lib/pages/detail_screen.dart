import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_topup_voucher_game_online/models/product.dart';
import 'package:flutter_topup_voucher_game_online/providers/game_provider.dart';

import 'package:flutter_topup_voucher_game_online/widgets/product_category_list.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../widgets/detail_screen/item_card.dart';
import 'cart_details.dart';

//import 'package:flutter_application_ecommerce/widgets/detail_screen/item_card.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final TextEditingController userIdText = TextEditingController();
  final TextEditingController serverIdText = TextEditingController();
  String userid = "";
  String serverid = "";
  String nameProduct = "";
  int price = 0;
  final int quantity = 1;

  double getWidth() {
    FlutterView view =
        PlatformDispatcher
            .instance
            .views
            .first; // untuk mendapatkan info nilai view layar
    double physicalWidth = view.physicalSize.width;
    double devicePixelRatio = view.devicePixelRatio;
    return physicalWidth / devicePixelRatio;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            context.read<GameProvider>().removeProduct();
            Get.back();
          },
          icon: Icon(Icons.arrow_back),
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.all(20.0),
            child: IconButton(
              onPressed: () {
                Get.to(CartDetails());
              },
              icon: Icon(Icons.add_shopping_cart, color: Colors.greenAccent),
            ),
          ),
        ],
      ),

      body: Column(
        children: [
          const SizedBox(height: 36),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: getWidth(),
                  child: TextField(
                    controller: userIdText,
                    autocorrect: true,
                    autofocus: false,
                    enableSuggestions: true,
                    enableInteractiveSelection: true,
                    decoration: const InputDecoration(hintText: "Masukan ID"),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: getWidth(),
                  child: TextField(
                    controller: serverIdText,
                    autocorrect: true,
                    autofocus: false,
                    enableSuggestions: true,
                    enableInteractiveSelection: true,
                    decoration: const InputDecoration(
                      hintText: "Masukan Server ID",
                    ),
                  ),
                ),
              ),
            ],
          ),
          const ProductCategoryList(),
          Expanded(
            child: Consumer<GameProvider>(
              builder: (context, provider, child) {
                if (provider.products.isEmpty) {
                  return const Center(
                    child: Text("Pilih Produk Category Category"),
                  ); // ✅ Loading state
                }

                final List<Product> products = provider.products;
                products.sort(
                  (a, b) => a.price.compareTo(b.price),
                ); // ✅ Urutkan berdasarkan harga

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: (60 / 100),
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                  ),
                  itemCount: products.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    final product = products[index];

                    return GestureDetector(
                      onTap: () {
                        // ✅ Ambil data yang diperlukan
                        final userId = userIdText.text;
                        final serverId = serverIdText.text;
                        final nameProduct = product.name;
                        final price = product.price;

                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return SizedBox(
                              height: 400,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text("User ID: $userId"),
                                  Text("Server ID: $serverId"),
                                  Text("Price: Rp. $price"),
                                  Text("Category: $nameProduct"),

                                  // ✅ Tombol Pembelian
                                  Center(
                                    child: ElevatedButton(
                                      onPressed: () async {},
                                      child: const Text('Buy'),
                                    ),
                                  ),

                                  // ✅ Tombol Tutup
                                  Center(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Close'),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: ItemCard(
                        product: product,
                      ), // ✅ Kirim data produk ke ItemCard
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      /*  bottomSheet: BottomAppBar(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.center,
          width: double.infinity,
          height: MediaQuery.of(context).size.height / 25,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 95, 95, 91),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Rp test',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  //   provider.toggleProduct(p);
                },
                icon: const Icon(Icons.send),
                label: const Text('Add to Cart'),
                style: const ButtonStyle(
                    foregroundColor:
                        MaterialStatePropertyAll(Colors.greenAccent),
                    backgroundColor: MaterialStatePropertyAll(Colors.black12)),
              )
            ],
          ),
        ),
      ),*/
    );
  }

  /*
  _buildProductCategory({required String image, required String name}) {
    return GestureDetector(
      onTap: () => () {},
      child: Container(
        width: 100,
        height: 100,
        margin: const EdgeInsets.only(top: 10, right: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: isSelected == name ? Colors.white : Colors.greenAccent,
            borderRadius: BorderRadius.circular(8)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset(image, fit: BoxFit.contain),
            Text(
              name,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
  */
}
