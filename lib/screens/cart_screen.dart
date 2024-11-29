import 'package:flutter/material.dart';
import '../models/cart.dart';
import '../models/order.dart';
import '../models/product.dart';
import 'homescreen.dart';

class CartScreen extends StatefulWidget {
  final List<CartItem> cartItems;
  final Function(List<Order>) onCheckout;

  const CartScreen(
      {super.key, required this.cartItems, required this.onCheckout});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<CartItem> _cartItems;

  @override
  void initState() {
    super.initState();
    _cartItems = List.from(widget.cartItems);
  }

  void _checkout(BuildContext context) {
    final List<Order> orders = [];
    final productsWithQuantities = <Product, int>{};

    for (var cartItem in _cartItems) {
      if (cartItem.quantity > 0) {
        productsWithQuantities[cartItem.product] = cartItem.quantity;
      }
    }

    if (productsWithQuantities.isNotEmpty) {
      final order = Order(
        DateTime.now().millisecondsSinceEpoch.toString(),
        productsWithQuantities,
      );
      orders.add(order);
      widget.onCheckout(orders);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(orders: orders),
        ),
      );
    }
  }

  void _updateQuantity(CartItem cartItem, int newQuantity) {
    setState(() {
      cartItem.quantity = newQuantity;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('Blue-Aesthetic-Background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: _cartItems.isEmpty
                  ? const Center(
                      child: Text(
                      'Your cart is empty.',
                      style: TextStyle(color: Colors.white),
                    ))
                  : ListView.builder(
                      itemCount: _cartItems.length,
                      itemBuilder: (context, index) {
                        return _buildCartItem(_cartItems[index]);
                      },
                    ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () => _checkout(context),
                  child: const Text('Checkout'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem(CartItem cartItem) {
    return ListTile(
      title: Text(
        cartItem.product.name,
        style: const TextStyle(color: Colors.white), // Change color here
      ),
      subtitle: Text(
        '₱${cartItem.product.price} x ${cartItem.quantity}',
        style: const TextStyle(color: Colors.white70), // Change color here
      ),
      trailing: Text(
        'Total: ₱${(cartItem.product.price * cartItem.quantity).toStringAsFixed(2)}',
        style: const TextStyle(color: Colors.white), // Change color here
      ),
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove,
                color: Colors.white), // Change icon color here
            onPressed: () {
              if (cartItem.quantity > 1) {
                _updateQuantity(cartItem, cartItem.quantity - 1);
              }
            },
          ),
          Text(
            cartItem.quantity.toString(),
            style: const TextStyle(color: Colors.white),
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              _updateQuantity(cartItem, cartItem.quantity + 1);
            },
          ),
        ],
      ),
    );
  }
}
