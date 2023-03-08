import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product.dart';
import 'package:shop/provider/products.dart';

class AddNewProduct extends StatefulWidget {
  static const namedRoute = '/add-product';
  const AddNewProduct({super.key});

  @override
  State<AddNewProduct> createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageFocusNode = FocusNode();
  final _imageInputController = TextEditingController();
  var formGlobalKey = GlobalKey<FormState>();

  var _editedProduct = Product(
    id: '',
    title: '',
    imageUrl: '',
    description: '',
    price: 0,
  );

  // Update page variables
  bool _isUpdating = false;
  var oldData = {
    'title': '',
    'description': '',
    'price': '',
    // 'imageUrl': '',
  };
  var isInit = true;
  String? expectedProductId = '';

  // Loading spinner
  bool _isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _imageFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _imageInputController.dispose();
    _descriptionFocusNode.dispose();
    _imageFocusNode.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _imageFocusNode.addListener(_updateImageUrl);
  }

  void _updateImageUrl() {
    if (!_imageFocusNode.hasFocus) {
      if ((_imageInputController.text.isNotEmpty &&
              !_imageInputController.text.startsWith('http') &&
              !_imageInputController.text.startsWith('https')) ||
          (_imageInputController.text.isNotEmpty &&
              !_imageInputController.text.endsWith('.png') &&
              !_imageInputController.text.endsWith('.jpeg') &&
              !_imageInputController.text.endsWith('.jpg'))) return;
      // if (_imageInputController.text.isEmpty) setState(() {});
      setState(() {});
    }
  }

  void _submitForm() async {
    final _isFormValid = formGlobalKey.currentState?.validate();
    // print(_isFormValid);
    if (!_isFormValid!) {
      return;
    }
    formGlobalKey.currentState?.save();
    setState(() {
      _isLoading = true;
    });

    // print(_isUpdating);
    if (_isUpdating) {
      // print('updating section');
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (err) {
        setState(() {
          _isLoading = false;
        });
        await showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: const Text('Error occured'),
                content: Text(
                  err.toString(),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      // print(oldData['title']);
                      Navigator.of(ctx).pop(true);
                    },
                    child: const Text('Okay'),
                  ),
                ],
              );
            });
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (isInit) {
      expectedProductId = ModalRoute.of(context)?.settings.arguments as String?;
      // print(expectedProductId);

      if (expectedProductId != null) {
        final foundProduct =
            Provider.of<Products>(context, listen: false).getProductById(
          expectedProductId!,
        );
        _isUpdating = true;
        oldData = {
          'title': foundProduct.title,
          'description': foundProduct.description,
          'price': foundProduct.price.toString(),
          // 'imageUrl': foundProduct.imageUrl,
        };
        _imageInputController.text = foundProduct.imageUrl;
      }
    }
    isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    // print(expectedProductId);
    // print(_isUpdating);
    return Scaffold(
      appBar: AppBar(
        title: _isUpdating
            ? const Text('Update Product')
            : const Text('Add Product'),
        actions: [
          IconButton(
            onPressed: _submitForm,
            icon: const Icon(Icons.save_rounded),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: formGlobalKey,
                child: ListView(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Title'),
                      ),
                      initialValue:
                          _isUpdating ? oldData['title'] : _editedProduct.title,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty || value.length < 2) {
                          return 'Please provide a valid title.';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: newValue!,
                          imageUrl: _editedProduct.imageUrl,
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                        );
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Price'),
                      ),
                      initialValue: _isUpdating
                          ? oldData['price']
                          : _editedProduct.price.toString(),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onEditingComplete: () {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Price should be greater than 0.';
                        }
                        if (value.isNotEmpty && double.parse(value) == 0.0) {
                          return 'Provide price greater than 0.';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          imageUrl: _editedProduct.imageUrl,
                          description: _editedProduct.description,
                          price: double.parse(newValue!),
                        );
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Description'),
                      ),
                      initialValue: _isUpdating
                          ? oldData['description']
                          : _editedProduct.description,
                      minLines: 1,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Provide a valid description';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          imageUrl: _editedProduct.imageUrl,
                          description: newValue!,
                          price: _editedProduct.price,
                        );
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              label: Text('Image Url'),
                            ),
                            keyboardType: TextInputType.url,
                            focusNode: _imageFocusNode,
                            controller: _imageInputController,
                            validator: (value) {
                              if (value!.isEmpty ||
                                  (value.isNotEmpty &&
                                      !value.startsWith('http') &&
                                      !value.startsWith('https')) ||
                                  (value.isNotEmpty &&
                                      !value.endsWith('.png') &&
                                      !value.endsWith('.jpeg') &&
                                      !value.endsWith('.jpg'))) {
                                return 'Provide a valid image url';
                              }
                              // if  {
                              //   return 'PRovide a valid url';
                              // }
                              // if  {
                              //   return 'Provide a valid url';
                              // }
                              return null;
                            },
                            onSaved: (newValue) {
                              _editedProduct = Product(
                                id: _isUpdating
                                    ? expectedProductId!
                                    : DateTime.now().toString(),
                                title: _editedProduct.title,
                                imageUrl: newValue!,
                                description: _editedProduct.description,
                                price: _editedProduct.price,
                              );
                            },
                          ),
                        ),
                        Container(
                          height: 100,
                          width: 100,
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 2,
                            ),
                          ),
                          margin: const EdgeInsets.only(
                            left: 5,
                            top: 10,
                          ),
                          child: _imageInputController.text.isEmpty
                              ? const Center(
                                  child: Text('Enter url'),
                                )
                              : Image.network(
                                  _imageInputController.text,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
