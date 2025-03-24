import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:paciente_app/features/home/presentation/provider/home_provider.dart';
import 'package:paciente_app/features/home/presentation/widgets/home_header.dart';
import 'package:paciente_app/core/constants/app_constants.dart';
import 'package:paciente_app/features/home/presentation/widgets/categories_grid.dart';
import 'package:paciente_app/features/home/presentation/widgets/top_doctors_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              HomeHeader(
                userName: homeProv.userName,
                userAvatar: homeProv.userAvatar,
              ),
              const SizedBox(height: 16),
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
