import 'package:flutter/material.dart';
import 'package:press_buttons_make_sounds/data/services/sound_button.serv.dart';
import 'package:press_buttons_make_sounds/shared/sound_button/sound_button.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    
    


    return Scaffold(
      body: Consumer<SoundButtonViewModel> (
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(viewModel.errorMessage!),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: viewModel.loadButtons,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (viewModel.buttons.isEmpty){
            return const Scaffold(
              body: SafeArea(child: Center(child: Text('No sound buttons yet.'))),
            );  
          }
          return SafeArea(
            child: GridView.builder(
              itemCount: viewModel.buttons.length, 
              padding: const EdgeInsets.all(18.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10.0,  // Espacio horizontal entre columnas
                  mainAxisSpacing: 10.0,   // Espacio vertical entre filas
                  childAspectRatio: 1.0

            ),
            itemBuilder: (context, index) {
              final button = viewModel.buttons[index];
              return SoundButton(
                button: button,
              );
            },

            )
          );
      }
    ));
  }
}