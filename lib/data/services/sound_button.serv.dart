import 'package:flutter/foundation.dart';
import 'package:press_buttons_make_sounds/data/repository/sound_button.repo.dart';
import 'package:press_buttons_make_sounds/domain/models/sound_button.model.dart';

class SoundButtonViewModel extends ChangeNotifier {
  SoundButtonViewModel(this._repository);

  final SoundButtonRepository _repository;

  List<SoundButtonModel> _buttons = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<SoundButtonModel> get buttons => List.unmodifiable(_buttons);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadButtons() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _buttons = await _repository.getAll();
    } catch (error) {
      _errorMessage = 'Could not load sound buttons.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addButton(SoundButtonModel button) async {
    await _repository.create(button);
    await loadButtons();
  }

  Future<void> editButton(SoundButtonModel button) async {
    await _repository.update(button);
    await loadButtons();
  }

  Future<void> removeButton(int id) async {
    await _repository.delete(id);
    await loadButtons();
  }

  Future<void> toggleFavorite(SoundButtonModel button) async {
    await editButton(button.copyWith(isFavorite: !button.isFavorite));
  }

  Future<void> toggleEnabled(SoundButtonModel button) async {
    await editButton(button.copyWith(isEnabled: !button.isEnabled));
  }
}
