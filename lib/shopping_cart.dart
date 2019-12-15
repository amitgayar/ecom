

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

import 'expanding_bottom_sheet.dart';
import 'model/app_state_model.dart';
import 'model/product.dart';

const _leftColumnWidth = 30.0;

class ShoppingCartPage extends StatefulWidget {
  @override
  _ShoppingCartPageState createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  List<Widget> _createShoppingCartRows(AppStateModel model) {
    return model.productsInCart.keys
        .map(
          (id) => ShoppingCartRow(
            product: model.getProductById(id),
            quantity: model.productsInCart[id],
            onPressed: () {
              model.removeItemFromCart(id);
            },
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final localTheme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.brown,
      body: SafeArea(
        child: Container(
          child: ScopedModelDescendant<AppStateModel>(
            builder: (context, child, model) {
              return Stack(
                children: [
                  ListView(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: _leftColumnWidth,
                            child: IconButton(
                                icon: const Icon(Icons.keyboard_arrow_down),
                                onPressed: () =>
                                    Navigator.pop(context)),
                          ),
                          Text(
                            'CART',
                            style: localTheme.textTheme.subhead
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 16.0),
                          Text('${model.totalCartQuantity} ITEMS'),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Column(
                        children: _createShoppingCartRows(model),
                      ),
                      ShoppingCartSummary(model: model),
                      const SizedBox(height: 100.0),
                    ],
                  ),
                  Positioned(
                    bottom: 16.0,
                    left: 16.0,
                    right: 16.0,
                    child: RaisedButton(
                      shape: const BeveledRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7.0)),
                      ),
                      color: Colors.brown,
                      splashColor: Colors.brown,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Text('CLEAR CART'),
                      ),
                      onPressed: () {
                        model.clearCart();
                        ExpandingBottomSheet.of(context).close();
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class ShoppingCartSummary extends StatefulWidget {
  ShoppingCartSummary({this.model});
  final AppStateModel model;

 @override
 _ShoppingCartSummary createState() => _ShoppingCartSummary();
}

class _ShoppingCartSummary extends State<ShoppingCartSummary> {
//   AppStateModel model;
//   _ShoppingCartSummary({this.model});

  bool isGST = false;
  @override
  Widget build(BuildContext context) {
    final smallAmountStyle =
        Theme.of(context).textTheme.body1.copyWith(color: Colors.black);
    final largeAmountStyle = Theme.of(context).textTheme.display1;
    final formatter = NumberFormat.simpleCurrency(
        decimalDigits: 2, locale: Localizations.localeOf(context).toString());

    return ScopedModelDescendant<AppStateModel>(
      builder: (context, child, model) {
        return Row(
          children: [
            SizedBox(width: _leftColumnWidth),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

//                      new Checkbox(
//                      value: isGST,
//                      onChanged: (bool value) {
//                        setState(() {
//                          isGST = value;
//                          isGST? print('gst'): print('nogst!!');
//
//                          var gst = model.setGST(value);
//                          print(gst.toString());
//                        });
//                      },
//                        activeColor: Colors.black,
//                      ),
                        const Expanded(
                          child: Text('GST')
//                          SizedBox(height: 1,),
                          ),
                        Text(
//                          model.setGST(value).toString(),
                            '6767',
                          style: smallAmountStyle,
                          ),
                      ],
                      ),
                    const SizedBox(height: 16.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Expanded(
                          child: Text('TOTAL'),
                          ),
                        Text(
                          formatter.format(model.totalCost),
                          style: largeAmountStyle,
                          ),
                      ],
                      ),
                    const SizedBox(height: 16.0),
                    Row(
                      children: [
                        const Expanded(
                          child: Text('Subtotal:'),
                          ),
                        Text(
                          formatter.format(model.subtotalCost),
                          style: smallAmountStyle,
                          ),
                      ],
                      ),
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        const Expanded(
                          child: Text('Shipping:'),
                          ),
                        Text(
                          formatter.format(model.shippingCost),
                          style: smallAmountStyle,
                          ),
                      ],
                      ),
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        const Expanded(
                          child: Text('Tax:'),
                          ),
                        Text(
                          formatter.format(model.tax),
                          style: smallAmountStyle,
                          ),
                      ],
                      ),
                  ],
                  ),
                ),
              ),
          ],
          );
      },
    );
  }
}

class ShoppingCartRow extends StatelessWidget {
  ShoppingCartRow(
      {@required this.product, @required this.quantity, this.onPressed});

  final Product product;
  final int quantity;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.simpleCurrency(
        decimalDigits: 0, locale: Localizations.localeOf(context).toString());
    final localTheme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        key: ValueKey(product.id),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: localTheme.textTheme.subhead
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                            Row(
                              children: [
                                const SizedBox(width: 80.0),
                                Container(
                                  width: 30,
                                  child: TextField(
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: '${product.price}'
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 40.0),
                                Container(
                                  width: 30,
                                  child: TextField(
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: '${product.price}'
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 50.0),
                                Container(
                                  width: 30,
                                  child: Text('$quantity'),
                                ),
                                const SizedBox(width: 30.0),
                                Text('${formatter.format(product.price*quantity)}'),
                              ],
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  const Divider(
                    color: Colors.brown,
                    height: 10.0,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: _leftColumnWidth,
              child: IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: onPressed,
          ),
          ),
        ],
      ),
    );
  }
}
