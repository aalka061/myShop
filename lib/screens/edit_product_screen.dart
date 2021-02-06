import 'package:flutter/material.dart';

class EditProductScreen extends StatefulWidget {
  static const ROUTE = '/edit_product_screen';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [],
          title: Text('Edit Product'),
        ),
        // it better to avoid list view column because of data loss
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            child: ListView(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Title'),
                  textInputAction: TextInputAction.next,
                ),
              ],
            ),
          ),
        ));
  }
}
