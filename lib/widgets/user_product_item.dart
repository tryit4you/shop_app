import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  const UserProductItem(
    this.id,
    this.title,
    this.imageUrl,
  );

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    final theme = Theme.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
      trailing: Container(
        width: 100,
        child: Row(children: [
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routedName, arguments: id);
              },
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor),
          IconButton(
            onPressed: () async {
              try {
                await Provider.of<Products>(context, listen: false)
                    .deleteProduct(id);
              } catch (error) {
                scaffold.removeCurrentSnackBar();
                scaffold.showSnackBar(SnackBar(
                  content: Text(
                    error.toString(),
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  backgroundColor: theme.errorColor,
                ));
              }
            },
            icon: Icon(Icons.delete),
            color: theme.errorColor,
          )
        ]),
      ),
    );
  }
}
