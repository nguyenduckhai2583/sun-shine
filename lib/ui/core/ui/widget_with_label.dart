import 'package:material_ui/material_ui.dart';

class WidgetWithLabel extends StatelessWidget {
  const WidgetWithLabel({
    super.key,
    this.label,
    required this.child,
    this.labelStyle,
    this.gap = 5,
    this.required = false,
  });

  final String? label;
  final Widget child;
  final TextStyle? labelStyle;
  final double gap;
  final bool required;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label case final String label) ...[
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: label,
                  style: (labelStyle ?? theme.textTheme.bodySmall)?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                if (required)
                  TextSpan(
                    text: ' *',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: gap),
        ],
        child,
      ],
    );
  }
}
