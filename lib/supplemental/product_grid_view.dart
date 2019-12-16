
import 'dart:ffi';

import 'package:flutter/material.dart';
import '../model/product.dart';
import 'product_card.dart';
import 'package:scoped_model/scoped_model.dart';
import '../model/app_state_model.dart';

_print(var text, {String msg = 'custom print'}) {
  print('.............................................' + msg);
  print(text.toString());
}

class ProductPage extends StatelessWidget {
  final Category category;
  const ProductPage({this.category = Category.all});
  @override
  Widget build(BuildContext context) {
    _print(category, msg:'category in product_grid_view.dart');
    return ScopedModelDescendant<AppStateModel>(
        builder: (context, child, model) {
          return ProductGridView(
              products: model.getProducts()

              );
        });
  }
}



class ProductGridView extends StatelessWidget {
  final List<Product> products;

  const ProductGridView({Key key, this.products});

  List<Container> _buildRows(BuildContext context) {
    if (products == null || products.isEmpty) {
      _print(products, msg:'products');
      return const <Container>[];

    }


    return List.generate(products.length, (index) {

      return Container(
//        width: 100,
        child:
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: ProductCard(product: products[index]),
        ),
      );
    }).toList();
  }


  @override
  Widget build(BuildContext context) {
    return new Row(
      children: <Widget>[
        Expanded(
          child: SizedBox(
            height: 300.0,
            child: new GridView.count(
              scrollDirection: Axis.horizontal,
              primary: false,
              padding: const EdgeInsets.all(20),
              crossAxisSpacing: 30,
              mainAxisSpacing: 30,
              crossAxisCount: 3,
              children: _buildRows(context),
              ),
            ),
          ),

      ],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      );



  }
}





