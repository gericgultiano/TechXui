import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/order.dart';
import '../models/cart.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../services/providers.dart';
import 'cart_screen.dart';
import 'orders_screen.dart';
import 'products_card.dart';
import 'profile_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final List<Order>? orders;

  const HomeScreen({super.key, this.orders});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;
  List<Order> _orders = [];
  final List<CartItem> _cartItems = [];
  bool _isProductsLoaded = false;

  @override
  void initState() {
    super.initState();
    if (widget.orders != null) {
      _orders = widget.orders!;
    }
    _loadProducts();
  }

  // Load products
  void _loadProducts() async {
    final productService = ref.read(productServiceProvider);
    await productService.loadProducts();
    setState(() {
      _isProductsLoaded = true;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _addToCart(Product product, int quantity) {
    setState(() {
      final existingCartItem = _cartItems.firstWhere(
        (item) => item.product.id == product.id,
        orElse: () => CartItem(product, 0),
      );

      if (existingCartItem.quantity > 0) {
        existingCartItem.quantity += quantity;
      } else {
        _cartItems.add(CartItem(product, quantity));
      }
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CartScreen(cartItems: _cartItems, onCheckout: _checkout),
      ),
    );
  }

  void _checkout(List<Order> orders) {
    setState(() {
      _orders.addAll(orders);
      _cartItems.clear();
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => OrdersScreen(orders: _orders)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productService = ref.watch(productServiceProvider);
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
            AppBar(
              title: Text(
                ['Products', 'Orders', 'Cart', 'Profile'][_selectedIndex],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              automaticallyImplyLeading: false,
              backgroundColor: const Color.fromARGB(85, 0, 95, 173),
              foregroundColor: Colors.white,
            ),
            Expanded(child: _buildBody(productService)),
            _buildBottomNavigationBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(ProductService productService) {
    switch (_selectedIndex) {
      case 0:
        return _buildProductGrid(productService);
      case 1:
        return OrdersScreen(orders: _orders);
      case 2:
        return CartScreen(cartItems: _cartItems, onCheckout: _checkout);
      default:
        return const ProfileScreen();
    }
  }

  Widget _buildProductGrid(ProductService productService) {
    if (!_isProductsLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    if (productService.getProducts().isEmpty) {
      return const Center(child: Text('No products available.'));
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
      ),
      itemCount: productService.getProducts().length,
      itemBuilder: (context, index) {
        final product = productService.getProducts()[index];
        return ProductCard(product: product, addToCart: _addToCart);
      },
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Products'),
        BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Orders'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      selectedItemColor: const Color.fromARGB(209, 2, 34, 218),
      unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
      backgroundColor: const Color.fromARGB(0, 34, 34, 34),
    );
  }
}
