// lib/features/main_navigation/screen/main_navigation_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:paciente_app/features/home/presentation/screen/home_screen.dart';
import 'package:paciente_app/features/menu_calendar/presentation/screen/calendar_screen.dart';
import 'package:paciente_app/features/planes/presentation/screen/planes_screen.dart';
import 'package:paciente_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:paciente_app/features/cart/presentation/screen/cart_screen.dart';
import 'package:paciente_app/features/cart/presentation/provider/cart_provider.dart';

/// Representa las pestañas visibles en el `BottomNavigationBar`.
enum NavigationTab {
  home,
  calendar,
//planes,
  profile,
  cart
}

/// Icono y etiqueta asociados a cada tab.
/// Usar extensiones evita `switch` repetitivos y mantiene el código limpio.
extension NavigationTabUI on NavigationTab {
  String get label {
    switch (this) {
      case NavigationTab.home:
        return 'Inicio';
      case NavigationTab.calendar:
        return 'Calendario';
      /* case NavigationTab.planes:
        return 'Planes'; */
      case NavigationTab.profile:
        return 'Perfil';
      case NavigationTab.cart:
        return 'Carrito';
    }
  }

  IconData get icon {
    switch (this) {
      case NavigationTab.home:
        return Icons.home;
      case NavigationTab.calendar:
        return Icons.calendar_month;
      /* case NavigationTab.planes:
        return Icons.assessment; */
      case NavigationTab.profile:
        return Icons.person;
      case NavigationTab.cart:
        return Icons.shopping_cart;
    }
  }
}

class MainNavigationScreen extends StatefulWidget {
  final NavigationTab initialTab;
  final int planesInitialIndex; // índice inicial para PlanesScreen

  const MainNavigationScreen({
    Key? key,
    this.initialTab = NavigationTab.home,
    this.planesInitialIndex = 0,
  }) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late NavigationTab _currentTab;

  @override
  void initState() {
    super.initState();
    _currentTab = widget.initialTab;
  }

  /// Devuelve el widget correspondiente a la tab seleccionada.
  Widget _screenForTab(NavigationTab tab) {
    switch (tab) {
      case NavigationTab.home:
        return const HomeScreen();
      case NavigationTab.calendar:
        return const CalendarScreen(isarrowBackActive: false);
      /* case NavigationTab.planes:
        return PlanesScreen(initialIndex: widget.planesInitialIndex); */
      case NavigationTab.profile:
        return const ProfileScreen();
      case NavigationTab.cart:
        return const CartScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProv = context.watch<CartProvider>();
    final cartCount = cartProv.itemsToal;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: _screenForTab(_currentTab),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentTab.index,
          selectedItemColor: const Color(0xFF5B6BF5),
          unselectedItemColor: Colors.grey,
          onTap: (i) => setState(() => _currentTab = NavigationTab.values[i]),
          items: NavigationTab.values.map((tab) {
            // El item del carrito necesita mostrar un badge dinámico.
            if (tab == NavigationTab.cart) {
              return BottomNavigationBarItem(
                label: tab.label,
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(tab.icon),
                    if (cartCount > 0)
                      Positioned(
                        right: -2,
                        top: -6,
                        child: _PulsingBadge(count: cartCount),
                      ),
                  ],
                ),
              );
            }

            return BottomNavigationBarItem(
              icon: Icon(tab.icon),
              label: tab.label,
            );
          }).toList(),
        ),
      ),
    );
  }
}

/// ------------- Badge animado para el carrito -------------
class _PulsingBadge extends StatefulWidget {
  final int count;

  const _PulsingBadge({Key? key, required this.count}) : super(key: key);

  @override
  State<_PulsingBadge> createState() => _PulsingBadgeState();
}

class _PulsingBadgeState extends State<_PulsingBadge> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleAnim = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });

    if (widget.count > 0) _controller.forward();
  }

  @override
  void didUpdateWidget(covariant _PulsingBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.count == 0 && widget.count > 0) _controller.forward();
    if (oldWidget.count > 0 && widget.count == 0) _controller.stop();
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
          style: const TextStyle(color: Colors.white, fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
