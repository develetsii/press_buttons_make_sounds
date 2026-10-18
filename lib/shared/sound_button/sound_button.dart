import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class SoundButton extends StatelessWidget {
  // un botón que reprudce un sonido al ser presionado
  // el sonido se pasa como parámetro al constructor
  final String soundPath;

  const SoundButton({super.key, required this.soundPath});

  @override
  Widget build(BuildContext context) {
    final AudioPlayer audioPlayer = AudioPlayer();

    return ElevatedButton(
      onPressed: () async {
        try {
          await audioPlayer.play(AssetSource(soundPath));
        } catch (e) {
          print('Error al reproducir el sonido: $e'); // no se recomienda usar print en producción, pero sirve para depuración
        }
      },
      child: Text('Reproducir Sonido'),
    );
  }
}