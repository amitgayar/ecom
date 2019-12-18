
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'model/app_state_model.dart';

enum Category {
  all,
  accessories,
  clothing,
  home,
  Reports,
  Customer,
  Stock_Requests,
  Orders,
  Inventory,
  Custom_Item,

}

class CategoryMenuPage extends StatelessWidget {
  final List<Category> _categories = Category.values;
  final VoidCallback onCategoryTap;

  const CategoryMenuPage({Key key, this.onCategoryTap,}) : super(key: key);

  Widget _buildCategory(Category category, BuildContext context) {
    final categoryString =
        category.toString().replaceAll('Category.', '').toUpperCase();

    return ScopedModelDescendant<NewAppStateModel>(
      builder: (context, child, model) => GestureDetector(
        onTap: () {
          model.setCategory(categoryString);
          if (onCategoryTap != null)
            {
              onCategoryTap();
              print('category clicked');
            }
        },
        child: model.selectedCategory == category
            ? Column(
                children: <Widget>[
                  SizedBox(height: 16.0),
                  Text(
                    categoryString,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 14.0),
                  Container(
                    width: 70.0,
                    height: 2.0,
                    color: Colors.brown,
                  ),
                ],
              )
            : Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  categoryString,
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.only(top: 40.0),
        color: Colors.grey,
        child: ListView(
          children: _categories.map((c) => _buildCategory(c, context)).toList(),
        ),
      ),
    );
  }
}
