import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final Function(Product, int) addToCart;

  const ProductCard(
      {super.key, required this.product, required this.addToCart});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(141, 0, 63, 179),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            product.imageUrl,
            height: 100,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              product.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(190, 255, 255, 255),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              '₱${product.price.toStringAsFixed(2)}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color.fromARGB(190, 255, 255, 255),
              ),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return QuantityDialog(
                    onQuantitySelected: (quantity) {
                      addToCart(product, quantity);
                      Navigator.of(context).pop();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${product.name} added to cart'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  );
                },
              );
            },
            child: const Text('Add to Cart'),
          ),
        ],
      ),
    );
  }
}

class QuantityDialog extends StatefulWidget {
  final Function(int) onQuantitySelected;

  const QuantityDialog({super.key, required this.onQuantitySelected});

  @override
  _QuantityDialogState createState() => _QuantityDialogState();
}

class _QuantityDialogState extends State<QuantityDialog> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 0, 54, 153),
      title: const Text(
        'Select Quantity',
        style: TextStyle(color: Colors.white),
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.remove, color: Colors.white),
            onPressed: () {
              if (_quantity > 1) setState(() => _quantity--);
            },
          ),
          Text(
            '$_quantity',
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => setState(() => _quantity++),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.onQuantitySelected(_quantity);
            Navigator.of(context).pop();
          },
          child: const Text(
            'Add to Cart',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
