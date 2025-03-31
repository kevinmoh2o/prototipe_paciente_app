import 'package:flutter/material.dart';
import 'package:paciente_app/features/cart/presentation/screen/cart_screen.dart';
import 'package:paciente_app/features/home/presentation/screen/home_screen.dart';
import 'package:paciente_app/features/menu_calendar/presentation/screen/calendar_screen.dart';
import 'package:paciente_app/features/planes/presentation/screen/planes_screen.dart';
import 'package:paciente_app/features/profile/presentation/screens/profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final int currentIndex;
  const MainNavigationScreen({Key? key, required this.currentIndex}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex; // Set initial value from widget
  }

  final List<Widget> _screens = [
    const HomeScreen(), // index=0
    const CalendarScreen(), // index=1
    const PlanesScreen(), // index=2
    const ProfileScreen(), // index=3
    const CartScreen(), // index=4
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex], // Shows the screen based on the current index
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF5B6BF5),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update index when a button is pressed
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
