import 'package:material_ui/material_ui.dart';
import 'package:sun_shine/core.dart';

class GridTileBackground extends StatelessWidget {
  const GridTileBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [const _GridTile(), child]);
  }
}

class _GridTile extends StatelessWidget {
  const _GridTile();

  static const _tabletWidth = 600.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossCount = constraints.maxWidth >= _tabletWidth ? 6 : 4;
        final mainCount = (constraints.maxHeight / (constraints.maxWidth / 4))
            .ceil();

        const gradientIndex = [0, 14, 23];
        const filledIndex = [3, 5, 24];

        return Opacity(
          opacity: .5,
          child: GridView.builder(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossCount,
            ),
            itemCount: mainCount * crossCount,
            itemBuilder: (context, index) {
              if (gradientIndex.contains(index)) {
                return const _BorderedTile(child: _GradientTile());
              }
              if (filledIndex.contains(index)) {
                return const _BorderedTile(child: _FilledTile());
              }
              return const _BorderedTile(child: _PlainTile());
            },
          ),
        );
      },
    );
  }
}

class _BorderedTile extends StatelessWidget {
  const _BorderedTile({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        border: GradientBorder(
          width: 0.5,
          gradient: LinearGradient(
            colors: [colors.primaryContainer, colors.outlineVariant],
          ),
        ),
      ),
      child: child,
    );
  }
}

class _PlainTile extends StatelessWidget {
  const _PlainTile();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surfaceContainerLowest,
      child: const SizedBox(),
    );
  }
}

class _GradientTile extends StatelessWidget {
  const _GradientTile();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.outlineVariant,
            const Color(0x1D1B2014).withValues(alpha: .08),
          ],
        ),
      ),
    );
  }
}

class _FilledTile extends StatelessWidget {
  const _FilledTile();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: const SizedBox(),
    );
  }
}
