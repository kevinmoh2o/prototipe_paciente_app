// lib/features/main_navigation/screen/main_navigation_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:paciente_app/features/home/presentation/screen/home_screen.dart';
import 'package:paciente_app/features/menu_calendar/presentation/screen/calendar_screen.dart';
import 'package:paciente_app/features/planes/presentation/screen/planes_screen.dart';
import 'package:paciente_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:paciente_app/features/cart/presentation/screen/cart_screen.dart';
import 'package:paciente_app/features/cart/presentation/provider/cart_provider.dart';

class MainNavigationScreen extends StatefulWidget {
  final int currentIndex;
  final int planesInitialIndex; // 🆕 índice inicial para PlanesScreen

  const MainNavigationScreen({
    Key? key,
    required this.currentIndex,
    this.planesInitialIndex = 0, // por defecto 0
  }) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
  }

  late final List<Widget> _screens = [
    const HomeScreen(), // 0
    const CalendarScreen(isarrowBackActive: false), // 1
    PlanesScreen(initialIndex: widget.planesInitialIndex), // 2  🆕
    const ProfileScreen(), // 3
    const CartScreen(), // 4
  ];

  @override
  Widget build(BuildContext context) {
    final cartProv = context.watch<CartProvider>();
    final cartCount = cartProv.itemsToal;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: _screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedItemColor: const Color(0xFF5B6BF5),
          unselectedItemColor: Colors.grey,
          onTap: (i) => setState(() => _currentIndex = i),
          items: [
            const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
            const BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: "Calendario"),
            const BottomNavigationBarItem(icon: Icon(Icons.assessment), label: "Planes"),
            const BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
            BottomNavigationBarItem(
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.shopping_cart),
                  if (cartCount > 0)
                    Positioned(
                      right: -2,
                      top: -6,
                      child: _PulsingBadge(count: cartCount),
                    ),
                ],
              ),
              label: "Carrito",
            ),
          ],
        ),
      ),
    );
  }
}

class _PulsingBadge extends StatefulWidget {
  final int count;

  const _PulsingBadge({Key? key, required this.count}) : super(key: key);

  @override
  State<_PulsingBadge> createState() => _PulsingBadgeState();
}

class _PulsingBadgeState extends State<_PulsingBadge> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Creamos un Tween que oscile de 0.95 a 1.05, para un “pulse”
    _scaleAnim = Tween(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Hacemos que se repita (reverse) indefinidamente
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });

    // Solo pulsar si hay contenido
    if (widget.count > 0) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant _PulsingBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Si el count pasa de 0 a >0, iniciamos la animación
    if (oldWidget.count == 0 && widget.count > 0) {
      _controller.forward();
    }
    // Si el count pasa a 0, paramos la animación
    if (oldWidget.count > 0 && widget.count == 0) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnim,
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: const BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
        child: Text(
          '${widget.count}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
