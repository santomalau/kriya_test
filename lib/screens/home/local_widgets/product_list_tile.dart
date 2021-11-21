import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:kriya/api/models/models.dart';
import 'package:kriya/bloc/product_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductListTile extends StatelessWidget {
  final Product product;
  const ProductListTile({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String fullname;
    // if (product.lastName == null) {
    //   fullname = product.name.toString();
    // } else {
    //   fullname = product.name.toString() + " " + product.lastName.toString();
    // }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            offset: new Offset(2.0, 2.0),
          ),
        ],
      ),
      child: ListTile(
        leading: Image.asset('assets/images/ic_product.png'),
        title: Text(
          product.title!,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        subtitle: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                onPressed: () {
                  BlocProvider.of<ProductBloc>(context)
                      .add(ProductDecrementEvent(product: product));
                },
                icon: Icon(FeatherIcons.minusCircle)),
            Text((product.quantity ?? 0).toString()),
            IconButton(
                onPressed: () {
                  BlocProvider.of<ProductBloc>(context)
                      .add(ProductIncrementEvent(product: product));
                },
                icon: Icon(FeatherIcons.plusCircle)),
          ],
        ),
        // subtitle: Text(
        //   product.age.toString(),
        // ),
      ),
    );
  }
}
