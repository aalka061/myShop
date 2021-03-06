import 'package:flutter/material.dart';
import 'package:my_shop/providers/product.dart';
import 'package:my_shop/providers/products.dart';
import 'package:provider/provider.dart';
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
  var _initValues = {
    'title': '',
    'description': '',
    'price': 0,
    'imageUrl': '',
  };

  var _isLoading = false;

  @override
  void didChangeDependencies() {
    final p = ModalRoute.of(context).settings.arguments as Product;
    if (p == null) {
      return;
    }

    _editProduct = p;
    _initValues['title'] = p.title;
    _initValues['description'] = p.description;
    _initValues['price'] = p.price;
    _initValues['imageUrl'] = '';
    _imageUrlController.text = _editProduct.imageUrl;

    super.didChangeDependencies();
  }

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
  Future<void> _saveForm() async {
    // the save method triggers a method (onSaved) in every form field that allow us to
    // to take the value entered in the text field
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editProduct);
      } catch (e) {
        await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('error occured'),
            content: Text('Somthing went wrong'),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Okey'),
              )
            ],
          ),
        );
      }
      //finally {
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _initValues['title'],
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
                            id: _editProduct.id,
                            title: value,
                            price: _editProduct.price,
                            description: _editProduct.description,
                            imageUrl: _editProduct.imageUrl,
                            isFavorite: _editProduct.isFavorite,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['price'].toString(),
                        decoration: InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        validator: (val) {
                          if (val.isEmpty) {
                            return 'Please provide a price';
                          } else if (double.tryParse(val) == null) {
                            return "Please enter valid price";
                          }
                          if (double.parse(val) <= 0) {
                            return 'Please enter a price greater than 0';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editProduct = Product(
                            id: _editProduct.id,
                            title: _editProduct.title,
                            price: double.parse(value),
                            description: _editProduct.description,
                            imageUrl: _editProduct.imageUrl,
                            isFavorite: _editProduct.isFavorite,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['description'],
                        decoration: InputDecoration(labelText: 'Description'),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        validator: (val) {
                          if (val.isEmpty) {
                            return 'Please provide a description';
                          }
                          if (val.length < 0) {
                            return 'Should be at least 10 characters long';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editProduct = Product(
                            id: _editProduct.id,
                            title: _editProduct.title,
                            price: _editProduct.price,
                            description: value,
                            imageUrl: _editProduct.imageUrl,
                            isFavorite: _editProduct.isFavorite,
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
                                    child:
                                        Image.network(_imageUrlController.text),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          // text form field takes as much width as possible,
                          // however a row has unconstrained width
                          Expanded(
                            // you cannot use both cont
                            child: TextFormField(
                                decoration:
                                    InputDecoration(labelText: 'Image url'),
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
                                validator: (val) {
                                  if (val.isEmpty) {
                                    return 'Please provide an image url';
                                  }
                                  if (!val.startsWith('http') &&
                                      !val.startsWith('https')) {
                                    return 'Please enter a valid URL.';
                                  }

                                  if (!val.endsWith('.png') &&
                                      !val.endsWith('jpg') &&
                                      !val.endsWith('.jpeg') &&
                                      !val.endsWith('.png')) {
                                    return 'Please enter valid image URL';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _editProduct = Product(
                                    id: _editProduct.id,
                                    title: _editProduct.title,
                                    price: _editProduct.price,
                                    description: _editProduct.description,
                                    imageUrl: value,
                                    isFavorite: _editProduct.isFavorite,
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
