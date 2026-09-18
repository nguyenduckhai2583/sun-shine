import 'package:material_ui/material_ui.dart';

class RenameDialog extends StatefulWidget {
  const RenameDialog({
    super.key,
    required this.title,
    required this.label,
    required this.initialValue,
    this.prefixText,
    this.allowSpaces = true,
  });

  final String title;
  final String label;
  final String initialValue;
  final String? prefixText;
  final bool allowSpaces;

  @override
  State<RenameDialog> createState() => _RenameDialogState();
}

class _RenameDialogState extends State<RenameDialog> {
  late final _controller = TextEditingController(text: widget.initialValue);
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String? _validate(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) return 'Name cannot be empty';
    if (!widget.allowSpaces && name.contains(' ')) {
      return 'Name cannot contain spaces';
    }
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
      title: Text(widget.title),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          autofocus: true,
          decoration: InputDecoration(
            prefixText: widget.prefixText,
            labelText: widget.label,
          ),
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
