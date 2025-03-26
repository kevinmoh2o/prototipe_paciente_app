import 'package:flutter/material.dart';
import 'package:paciente_app/core/data/models/category_model.dart';
import 'package:paciente_app/features/medication/presentation/screen/medication_screen.dart';

class CategoriesGrid extends StatelessWidget {
  final List<CategoryModel> categories;
  const CategoriesGrid({Key? key, required this.categories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      // Para permitir scroll dentro de un Column, definimos shrinkWrap y physics
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final cat = categories[index];
        return _CategoryCard(category: cat);
      },
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final CategoryModel category;
  const _CategoryCard({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(category.title);
        if (category.title == "Medicamentos") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const MedicationScreen(),
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icono / imagen
            Image.asset(
              category.iconPath,
              height: 70,
              width: 70,
              scale: 5,
            ),
            const SizedBox(height: 8),
            // Título
            Text(
              category.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            if (category.description != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  category.description!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
