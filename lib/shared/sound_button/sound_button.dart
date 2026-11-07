import 'package:flutter/material.dart';
import 'package:press_buttons_make_sounds/domain/models/sound_button.model.dart';
//import 'package:audioplayers/audioplayers.dart';

class SoundButton extends StatelessWidget {
  // un botón que reprudce un sonido al ser presionado
  // el sonido se pasa como parámetro al constructor
  final SoundButtonModel button;

  const SoundButton({super.key, required this.button});

  @override
  Widget build(BuildContext context) {
    //final AudioPlayer audioPlayer = AudioPlayer();

    return ElevatedButton(
      onPressed: () async {
        try {
          // await audioPlayer.play(AssetSource(soundPath));
        } catch (e) {
          debugPrint('Error al reproducir el sonido: $e');
        }
      },
      child: Text('Reproducir Sonido'),
    );
  }
}
