import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

/// The app's single-line text field.
///
/// A focused port of employer's widget of the same name, which carries 60-odd
/// parameters covering multiline, debounced change callbacks, emoji filtering
/// and validators. Only what the auth screens use is here; the rest is added
/// back when a screen that needs it arrives.
class TextFieldInput extends StatefulWidget {
  const TextFieldInput({
    super.key,
    this.inputController,
    this.hintText,
    this.obscureText = false,
    this.focusNode,
    this.keyboardType,
    this.maxLength,
    this.textInputAction = TextInputAction.done,
    this.onFieldSubmitted,
    this.inputFormatters,
    this.showClearIcon = true,
  });

  final TextEditingController? inputController;
  final String? hintText;
  final bool obscureText;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final int? maxLength;
  final TextInputAction textInputAction;
  final void Function(String?)? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final bool showClearIcon;

  @override
  State<TextFieldInput> createState() => _TextFieldInputState();
}

class _TextFieldInputState extends State<TextFieldInput> {
  late bool _isObscured = widget.obscureText;

  @override
  void initState() {
    super.initState();
    widget.inputController?.addListener(_onTextChanged);
  }

  @override
  void didUpdateWidget(TextFieldInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.inputController != widget.inputController) {
      oldWidget.inputController?.removeListener(_onTextChanged);
      widget.inputController?.addListener(_onTextChanged);
    }
  }

  @override
  void dispose() {
    // The controller belongs to whoever passed it in, so only the listener is
    // ours to remove.
    widget.inputController?.removeListener(_onTextChanged);
    super.dispose();
  }

  /// Redraws so the clear button appears and disappears with the text.
  void _onTextChanged() {
    if (widget.showClearIcon && mounted) setState(() {});
  }

  Widget? _suffixIcon() {
    if (widget.obscureText) {
      return IconButton(
        onPressed: () => setState(() => _isObscured = !_isObscured),
        icon: Icon(
          _isObscured
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
        ),
      );
    }

    final controller = widget.inputController;
    if (!widget.showClearIcon ||
        controller == null ||
        controller.text.isEmpty) {
      return null;
    }

    // A gesture detector holds no focus node, so the clear button stays out of
    // the traversal order — an InkWell would swallow the next action of a
    // filled field instead of letting it reach the field below.
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: controller.clear,
      child: const Icon(Icons.close),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.inputController,
      focusNode: widget.focusNode,
      obscureText: _isObscured,
      keyboardType: widget.keyboardType,
      maxLength: widget.maxLength,
      textInputAction: widget.textInputAction,
      onSubmitted: widget.onFieldSubmitted,
      cursorColor: Theme.of(context).colorScheme.primary,
      inputFormatters: [
        ...?widget.inputFormatters,
        if (widget.maxLength != null)
          LengthLimitingTextInputFormatter(widget.maxLength),
      ],
      decoration: InputDecoration(
        filled: true,
        hintText: widget.hintText,
        suffixIcon: _suffixIcon(),
        // maxLength would otherwise print a "0/50" counter under the field.
        counterText: '',
      ),
    );
  }
}
