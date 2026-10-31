import 'package:flutter/material.dart';
import 'package:press_buttons_make_sounds/data/services/sound_button.serv.dart';
import 'package:press_buttons_make_sounds/domain/models/sound_button.model.dart';
import 'package:provider/provider.dart';

class SoundManagerPage extends StatefulWidget {
  const SoundManagerPage({super.key});

  @override
  State<SoundManagerPage> createState() => _SoundManagerPageState();
}

class _SoundManagerPageState extends State<SoundManagerPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<SoundButtonViewModel>().loadButtons();
      }
    });
  }

  Future<void> _showButtonDialog({SoundButtonModel? button}) async {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: button?.name ?? '');
    final pathController = TextEditingController(text: button?.audioPath ?? '');

    try {
      final result = await showDialog<SoundButtonModel>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: Text(
              button == null ? 'New sound button' : 'Edit sound button',
            ),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter a name.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: pathController,
                    decoration: const InputDecoration(
                      labelText: 'Audio path',
                      hintText: 'assets/sounds/applause.mp3',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter an audio path.';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () {
                  if (!formKey.currentState!.validate()) return;

                  final name = nameController.text.trim();
                  final audioPath = pathController.text.trim();

                  final updatedButton = button == null
                      ? SoundButtonModel(name: name, audioPath: audioPath)
                      : button.copyWith(name: name, audioPath: audioPath);

                  Navigator.pop(dialogContext, updatedButton);
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      );

      if (!mounted || result == null) return;

      final viewModel = context.read<SoundButtonViewModel>();

      try {
        if (button == null) {
          await viewModel.addButton(result);
        } else {
          await viewModel.editButton(result);
        }
      } catch (_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not save the sound button.')),
          );
        }
      }
    } finally {
      nameController.dispose();
      pathController.dispose();
    }
  }

  Future<void> _deleteButton(SoundButtonModel button) async {
    final id = button.id;
    if (id == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete button?'),
        content: Text('Delete "${button.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      await context.read<SoundButtonViewModel>().removeButton(id);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not delete the sound button.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Soundboard')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showButtonDialog(),
        child: const Icon(Icons.add),
      ),
      body: Consumer<SoundButtonViewModel>(
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

          if (viewModel.buttons.isEmpty) {
            return const Center(child: Text('No sound buttons yet.'));
          }

          return ListView.builder(
            itemCount: viewModel.buttons.length,
            itemBuilder: (context, index) {
              final button = viewModel.buttons[index];

              return ListTile(
                leading: Icon(
                  Icons.volume_up,
                  color: button.color == null ? null : Color(button.color!),
                ),
                title: Text(button.name),
                subtitle: Text(
                  button.audioPath,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: button.isEnabled
                    ? () {
                        // Aquí conectaremos el servicio de audio.
                      }
                    : null,
                trailing: Wrap(
                  spacing: 0,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    IconButton(
                      tooltip: 'Toggle favorite',
                      icon: Icon(
                        button.isFavorite ? Icons.star : Icons.star_border,
                      ),
                      onPressed: () {
                        viewModel.toggleFavorite(button);
                      },
                    ),
                    Switch(
                      value: button.isEnabled,
                      onChanged: (_) {
                        viewModel.toggleEnabled(button);
                      },
                    ),
                    IconButton(
                      tooltip: 'Edit',
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () {
                        _showButtonDialog(button: button);
                      },
                    ),
                    IconButton(
                      tooltip: 'Delete',
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _deleteButton(button),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
