import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/user_product_item.dart';

class UserProductScreen extends StatelessWidget {
  static const routedName = '/user-product';
  const UserProductScreen({Key key}) : super(key: key);
  void delete(String id){
    
  }
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Products'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routedName);
              },
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
          ),
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height - 30,
              child: ListView.builder(
                  itemCount: productsData.items.length,
                  itemBuilder: (ctx, i) => Column(
                        children: [
                          UserProductItem(
                              productsData.items[i].id,
                              productsData.items[i].title,
                              productsData.items[i].imageUrl),
                          Divider()
                        ],
                      )),
            ),
          ),
        ));
  }
}
