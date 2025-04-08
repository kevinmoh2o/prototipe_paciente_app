// lib/features/aptitud_fisica/presentation/screen/consulta_entrenador_screen.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:paciente_app/features/aptitud_fisica/presentation/provider/aptitud_provider.dart';

class ConsultaEntrenadorScreen extends StatelessWidget {
  const ConsultaEntrenadorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final aptProv = context.watch<AptitudProvider>();
    final entrenadores = aptProv.entrenadores;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Consulta con Entrenador"),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: entrenadores.length,
        itemBuilder: (ctx, i) {
          final ent = entrenadores[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              )
            ]),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(ent.imageAsset),
                  radius: 30,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(ent.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text("${ent.rating}★"),
                          const SizedBox(width: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: ent.isOnline ? Colors.green : Colors.grey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            child: Text(
                              ent.isOnline ? "Online" : "Offline",
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.video_call, color: Colors.blue),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Videollamada con ${ent.name}...")));
                      },
                    ),
                    IconButton(
                      icon: const Icon(FontAwesomeIcons.whatsapp, color: Colors.green),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("WhatsApp a ${ent.name}...")));
                      },
                    )
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
