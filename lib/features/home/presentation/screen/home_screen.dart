import 'package:flutter/material.dart';
import 'package:paciente_app/core/constants/app_constants.dart';
import 'package:provider/provider.dart';
import 'package:paciente_app/features/home/presentation/provider/home_provider.dart';
import 'package:paciente_app/features/home/presentation/widgets/home_header.dart';
import 'package:paciente_app/features/home/presentation/widgets/categories_grid.dart';
import 'package:paciente_app/features/home/presentation/widgets/top_doctors_list.dart';
import 'package:paciente_app/features/home/presentation/widgets/bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<HomeProvider>(context, listen: false).loadUserData(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeProv = Provider.of<HomeProvider>(context);

    return Scaffold(
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentNavIndex,
        onTap: (index) {
          setState(() {
            _currentNavIndex = index;
          });
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Encabezado con datos dinámicos
              HomeHeader(
                userName: homeProv.userName,
                userAvatar: homeProv.userAvatar,
              ),
              const SizedBox(height: 16),

              // Categorías
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const Text(
                  "Categorías",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CategoriesGrid(categories: AppConstants.homeCategories),
              ),
              const SizedBox(height: 16),

              // Top Médicos
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const Text(
                  "Top Médicos",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: TopDoctorsList(doctors: homeProv.topDoctors),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
