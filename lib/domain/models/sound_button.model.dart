class SoundButtonModel {
  const SoundButtonModel({
    this.id,
    required this.name,
    required this.audioPath,
    this.volume = 1.0,
    this.color,
    this.isFavorite = false,
    this.isEnabled = true,
  });

  final int? id;
  final String name;
  final String audioPath;
  final double volume;
  final int? color;
  final bool isFavorite;
  final bool isEnabled;

  Map<String, Object?> toMap() {
    return {
      'name': name,
      'audio_path': audioPath,
      'volume': volume,
      'color': color,
      'is_favorite': isFavorite ? 1 : 0,
      'is_enabled': isEnabled ? 1 : 0,
    };
  }

  factory SoundButtonModel.fromMap(Map<String, Object?> map) {
    return SoundButtonModel(
      id: map['id'] as int,
      name: map['name'] as String,
      audioPath: map['audio_path'] as String,
      volume: (map['volume'] as num).toDouble(),
      color: map['color'] as int?,
      isFavorite: map['is_favorite'] == 1,
      isEnabled: map['is_enabled'] == 1,
    );
  }

  SoundButtonModel copyWith({
    String? name,
    String? audioPath,
    double? volume,
    int? color,
    int? position,
    bool? isFavorite,
    bool? isEnabled,
  }) {
    return SoundButtonModel(
      id: id,
      name: name ?? this.name,
      audioPath: audioPath ?? this.audioPath,
      volume: volume ?? this.volume,
      color: color ?? this.color,
      isFavorite: isFavorite ?? this.isFavorite,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}
