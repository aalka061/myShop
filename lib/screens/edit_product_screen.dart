import 'package:flutter/material.dart';
import '../providers/product.dart';

class EditProductScreen extends StatefulWidget {
  static const ROUTE = '/edit_product_screen';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _imageUrlController = TextEditingController();
  //keep track if this image url in focus or not
  final _imageUrlFocus = FocusNode();

  // this global key allows us to interact with the state of the form widget
  // all we need to do now is to establish connection of the form to this
  // global key
  final _form = GlobalKey<FormState>();

  var _editProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );

  // when focus is lost, then we update the UI
  void _updateImageUrl() {
    if (!_imageUrlFocus.hasFocus) {
      setState(() {});
    }
  }

  @override
  void initState() {
    _imageUrlFocus.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    // dispose all fonucs nodes or listerners
    _imageUrlFocus.removeListener(_updateImageUrl);
    _imageUrlController.dispose();
    _imageUrlFocus.dispose();

    super.dispose();
  }

  // to save form, you would need to interact with the form somehow
  // to do that we need a global key (it is one of the rare instances that we need to use global key)
  void _saveForm() {
    // the save method triggers a method (onSaved) in every form field that allow us to
    // to take the value entered in the text field
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    print(_editProduct.title);
    print(_editProduct.description);
    print(_editProduct.price);
    print(_editProduct.imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
        title: Text('Edit Product'),
      ),
      // it better to avoid list view column because of data loss
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Title',
                    // error configuration
                  ),
                  textInputAction: TextInputAction.next,
                  // validator has to be trigger to work
                  // you can use autovalide in the form to do that

                  validator: (val) {
                    // return null, means input is correct
                    // return "error_message", means validation falied with error_message
                    if (val.isEmpty) {
                      return 'Please provide a value';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _editProduct = Product(
                      id: null,
                      title: value,
                      price: _editProduct.price,
                      description: _editProduct.description,
                      imageUrl: _editProduct.imageUrl,
                    );
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Price'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  validator: (val) {
                    if (val.isEmpty) {
                      return 'Please provide a price';
                    } else if (double.tryParse(val) == null) {
                      return "Please enter valid price";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _editProduct = Product(
                      id: null,
                      title: _editProduct.title,
                      price: double.parse(value),
                      description: _editProduct.description,
                      imageUrl: _editProduct.imageUrl,
                    );
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  validator: (val) {
                    if (val.isEmpty) {
                      return 'Please provide a description';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _editProduct = Product(
                      id: null,
                      title: _editProduct.title,
                      price: _editProduct.price,
                      description: value,
                      imageUrl: _editProduct.imageUrl,
                    );
                  },
                ),
                Row(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(top: 8, right: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        ),
                      ),
                      child: _imageUrlController.text.isEmpty
                          ? Text('Enter URL')
                          : FittedBox(
                              child: Image.network(_imageUrlController.text),
                              fit: BoxFit.cover,
                            ),
                    ),
                    // text form field takes as much width as possible,
                    // however a row has unconstrained width
                    Expanded(
                      child: TextFormField(
                          decoration: InputDecoration(labelText: 'Image url'),
                          keyboardType: TextInputType.url,
                          textInputAction: TextInputAction.done,
                          controller: _imageUrlController,
                          focusNode: _imageUrlFocus,
                          onEditingComplete: () {
                            setState(() {});
                          },
                          onFieldSubmitted: (_) {
                            _saveForm();
                          },
                          onSaved: (value) {
                            _editProduct = Product(
                              id: null,
                              title: _editProduct.title,
                              price: _editProduct.price,
                              description: _editProduct.description,
                              imageUrl: value,
                            );
                          }),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
