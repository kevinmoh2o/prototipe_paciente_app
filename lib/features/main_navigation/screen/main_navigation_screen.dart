import 'package:flutter/material.dart';
import 'package:paciente_app/features/cart/presentation/screen/cart_screen.dart';
import 'package:paciente_app/features/home/presentation/screen/home_screen.dart';
import 'package:paciente_app/features/menu_calendar/presentation/screen/calendar_screen.dart';
import 'package:paciente_app/features/planes/presentation/screen/planes_screen.dart';
import 'package:paciente_app/features/profile/presentation/screens/profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(), // index=0
    const CalendarScreen(), // index=1
    const PlanesScreen(), // index=2 (placeholder)
    const ProfileScreen(), // index=3 (placeholder)
    const CartScreen(), // index=4
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex], // Muestra la pantalla según el index
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF5B6BF5),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Inicio",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: "Calendario",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment),
            label: "Planes",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Perfil",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Carrito",
          ),
        ],
      ),
    );
  }
}
