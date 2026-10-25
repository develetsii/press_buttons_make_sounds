import 'package:flutter/material.dart';
import 'package:press_buttons_make_sounds/core/database/app.database.dart';
import 'package:press_buttons_make_sounds/data/repository/sound_button.repo.dart';
import 'package:press_buttons_make_sounds/data/services/sound_button.serv.dart';
import 'package:press_buttons_make_sounds/features/test.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const SoundboardApp());
}

class SoundboardApp extends StatelessWidget {
  const SoundboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = SoundButtonRepository(AppDatabase.instance.database);

    return ChangeNotifierProvider(
      create: (_) => SoundButtonViewModel(repository),
      child: MaterialApp(
        title: 'Soundboard',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const SoundButtonScreen(),
      ),
    );
  }
}
