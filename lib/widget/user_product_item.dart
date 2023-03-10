import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:shop/provider/auth.dart';
import '../provider/products.dart';
import '../screen/add_new_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String id;
  final String prodUserId;
  const UserProductItem({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.id,
    required this.prodUserId,
  });

  @override
  Widget build(BuildContext context) {
    // final curUserId = Provider.of<Auth>(context, listen: false).curUserId;
    // final isUserOwner = prodUserId == curUserId;
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      title: Text(title),
      trailing: SizedBox(
        width: 100,
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(AddNewProduct.namedRoute, arguments: id);
            },
            icon: const Icon(Icons.mode_edit_outlined),
          ),
          IconButton(
            onPressed: () {
              final userChoice = showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Are your sure?'),
                  content: const Text('Do you want to delete the product?'),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(ctx).pop(false);
                      },
                      child: const Text('No'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(ctx).pop(true);
                      },
                      child: const Text('Yes'),
                    ),
                  ],
                ),
              );
              userChoice.then((value) {
                if (value) {
                  Provider.of<Products>(context, listen: false)
                      .removeProduct(id);
                }
              });
            },
            icon: Icon(
              Icons.delete,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ]
            // : [
            //     IconButton(
            //       onPressed: () {
            //         Navigator.of(context)
            //             .pushNamed(AddNewProduct.namedRoute, arguments: {
            //           'id': id,
            //           'view': true,
            //         });
            //       },
            //       icon: const Icon(Icons.remove_red_eye),
            //     ),
            //   ],
            ),
      ),
    );
  }
}
