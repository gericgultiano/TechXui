import 'package:flutter/material.dart';
import '../models/order.dart';

class OrdersScreen extends StatelessWidget {
  final List<Order> orders;

  const OrdersScreen({super.key, required this.orders});

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
        child: _buildOrderList(orders),
      ),
    );
  }

  Widget _buildOrderList(List<Order> orders) {
    if (orders.isEmpty) {
      return const Center(
          child: Text(
        'No orders found.',
        style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
      ));
    }

    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return _buildOrderTile(orders[index]);
      },
    );
  }

  Widget _buildOrderTile(Order order) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(
          'Order ID: ${order.id}',
          style: TextStyle(
              color: const Color.fromARGB(255, 0, 0, 0),
              fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: order.productsWithQuantities.entries.map((entry) {
            final product = entry.key;
            final quantity = entry.value;
            return Text(
              '${product.name} x $quantity - ₱${(product.price * quantity).toStringAsFixed(2)}',
              style: TextStyle(color: Colors.black87),
            );
          }).toList(),
        ),
        trailing: Text(
          'Total: ₱${order.finalPrice.toStringAsFixed(2)}',
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
