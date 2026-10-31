import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
      child: GridView.builder(
        itemCount: 0, 
        padding: const EdgeInsets.all(18.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10.0,  // Espacio horizontal entre columnas
            mainAxisSpacing: 10.0,   // Espacio vertical entre filas
            childAspectRatio: 1.0

      ),
      itemBuilder: (context, index) {
  return ElevatedButton(
    onPressed: () {},
    child: Text('Botón $index'),
  );
},

    )));
  }
}