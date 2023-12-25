import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/products_list.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final FocusNode _priceFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();
  final FocusNode _imageFocus = FocusNode();

  final TextEditingController _imageController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, Object> _formData = <String, Object>{};

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _imageFocus.addListener(_updateImage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final args = ModalRoute.of(context)?.settings.arguments;

      if (args != null) {
        final Product product = args as Product;

        _formData['id'] = product.id;
        _formData['name'] = product.name;
        _formData['price'] = product.price;
        _formData['description'] = product.description;
        _formData['imageUrl'] = product.imageUrl;

        _imageController.text = product.imageUrl;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocus.dispose();
    _descriptionFocus.dispose();
    _imageFocus.removeListener(_updateImage);
    _imageFocus.dispose();
  }

  void _updateImage() {
    setState(() {});
  }

  Future<void> _submitForm() async {
    final isvalid = _formKey.currentState?.validate() ?? false;

    if (!isvalid) {
      return;
    }

    _formKey.currentState?.save();

    final ProductsList provider =
        Provider.of<ProductsList>(context, listen: false);

    setState(() => _isLoading = true);

    try {
      await provider.saveProduct(_formData);
    } catch (error) {
      if (!context.mounted) return;

      await showDialog<void>(
        context: context,
        builder: (ctx) {
          return AlertDialog.adaptive(
            title: const Text('Ocorreu um erro!'),
            content: const Text(
              "Não foi possível salvar o produto. Caso o erro persista, entre em contato com o suporte.",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Fechar'),
              ),
            ],
          );
        },
      );
    } finally {
      setState(() => _isLoading = false);

      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulário de Produto'),
        backgroundColor: Colors.deepPurple.withOpacity(0.95),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Salvar',
            icon: const Icon(Icons.save),
            onPressed: () => _submitForm(),
          ),
        ],
      ),
      body: Visibility(
        visible: !_isLoading,
        replacement: const Center(
          child: CircularProgressIndicator(),
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.all(16.0),
            children: [
              TextFormField(
                initialValue: _formData['name']?.toString(),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => _priceFocus.requestFocus(),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nome',
                ),
                onSaved: (value) => _formData['name'] = value ?? '',
                validator: (value) {
                  final String name = value?.trim() ?? '';

                  if (name.trim().isEmpty) {
                    return 'Nome é obrigatório.';
                  }

                  if (name.trim().length < 3) {
                    return 'Nome muito pequeno. No mínimo 3 letras.';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                initialValue: _formData['price']?.toString(),
                textInputAction: TextInputAction.next,
                focusNode: _priceFocus,
                onFieldSubmitted: (value) => _descriptionFocus.requestFocus(),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Preço',
                ),
                onSaved: (value) {
                  value = value?.replaceAll(',', '.') ?? '0';

                  _formData['price'] = double.parse(value);
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Preço é obrigatório.';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                initialValue: _formData['description']?.toString(),
                textInputAction: TextInputAction.next,
                focusNode: _descriptionFocus,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                onFieldSubmitted: (value) => _imageFocus.requestFocus(),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Descrição',
                ),
                onSaved: (value) => _formData['description'] = value ?? '',
                validator: (value) {
                  final String description = value ?? '';

                  if (description.trim().isEmpty) {
                    return 'Descrição é obrigatória.';
                  }

                  if (description.trim().length < 10) {
                    return 'Descrição muito pequena. No mínimo 10 letras.';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: _imageController,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.url,
                focusNode: _imageFocus,
                onFieldSubmitted: (_) => _submitForm(),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Imagem (URL)',
                ),
                onSaved: (value) => _formData['imageUrl'] = value ?? '',
                validator: (value) {
                  final String imageUrl = value ?? '';

                  if (imageUrl.trim().isEmpty) {
                    return 'Imagem é obrigatória.';
                  }

                  if (!imageUrl.startsWith('http')) {
                    return 'Informe uma URL válida.';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  color: Colors.grey.withOpacity(0.3),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.3),
                  ),
                ),
                child: Visibility(
                  visible: _imageController.value.text.isNotEmpty &&
                      _imageController.value.text.startsWith('http'),
                  replacement: const Center(
                    child: Text('Nenhuma imagem'),
                  ),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Image.network(_imageController.value.text),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
