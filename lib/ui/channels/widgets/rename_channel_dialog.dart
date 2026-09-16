import 'package:material_ui/material_ui.dart';

class RenameChannelDialog extends StatefulWidget {
  const RenameChannelDialog({super.key, required this.initialName});

  final String initialName;

  @override
  State<RenameChannelDialog> createState() => _RenameChannelDialogState();
}

class _RenameChannelDialogState extends State<RenameChannelDialog> {
  late final _controller = TextEditingController(text: widget.initialName);
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String? _validate(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) return 'Name cannot be empty';
    if (name.contains(' ')) return 'Name cannot contain spaces';
    return null;
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.of(context).pop(_controller.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Rename channel'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          autofocus: true,
          decoration: const InputDecoration(prefixText: '#', labelText: 'Name'),
          validator: _validate,
          onFieldSubmitted: (_) => _submit(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Save')),
      ],
    );
  }
}
