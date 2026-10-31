import 'package:flutter/material.dart';
import 'package:press_buttons_make_sounds/core/database/app.database.dart';
import 'package:press_buttons_make_sounds/data/repository/sound_button.repo.dart';
import 'package:press_buttons_make_sounds/data/services/sound_button.serv.dart';
import 'package:press_buttons_make_sounds/features/home/home_page.dart';
import 'package:press_buttons_make_sounds/features/sounds_manager/sounds_manager.dart';
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
        home: DefaultTabController(
          length: 3,
          initialIndex: 1,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Botones pulsar, sonidos sonar'),
              bottom: const TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.bar_chart)),
                  Tab(icon: Icon(Icons.home)),
                  Tab(icon: Icon(Icons.tune)),
                ],
              ),
            ),
            body: const TabBarView(
              children: [Icon(Icons.bar_chart), HomePage(), SoundManagerPage()],
            ),
          ),
        ),
      ),
    );
  }
}
