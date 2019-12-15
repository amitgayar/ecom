
import 'package:flutter/material.dart';
import '../model/product.dart';
import 'product_card.dart';

class ProductGridView extends StatelessWidget {
  final List<Product> products;

  const ProductGridView({Key key, this.products});

  List<Container> _buildColumns(BuildContext context) {
    if (products == null || products.isEmpty) {
      return const <Container>[];
    }


    return List.generate(products.length, (index) {

      return Container(
        width: 100,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: ProductCard(product: products[index]),
        ),
      );
    }).toList();
  }



  @override
  Widget build(BuildContext context) {
    return GridView.count(
      // Create a grid with 2 columns. If you change the scrollDirection to
      // horizontal, this produces 2 rows.
      crossAxisCount: 2,
      scrollDirection: Axis.horizontal,

      // Generate 100 widgets that display their index in the List.
      children: _buildColumns(context),
    );



  }
}





