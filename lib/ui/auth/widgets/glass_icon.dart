import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sun_shine/core.dart';

/// The app mark on a frosted-glass plate, sized to the viewport.
class GlassIcon extends StatelessWidget {
  const GlassIcon({
    super.key,
    this.svgAsset,
    this.iconData,
    this.iconSizePercent,
  });

  final String? svgAsset;
  final IconData? iconData;
  final double? iconSizePercent;

  @override
  Widget build(BuildContext context) {
    final plateSize = MediaQuery.sizeOf(context).width * .26;
    final iconSize = plateSize * (iconSizePercent ?? .48);

    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          AppAsset.imgDecorativeGlass,
          width: plateSize,
          height: plateSize,
        ),
        _icon(iconSize),
      ],
    );
  }

  Widget _icon(double size) {
    if (svgAsset case final String asset when asset.isNotEmpty) {
      return SvgPicture.asset(asset, width: size, height: size);
    }
    if (iconData != null) return Icon(iconData, size: size);
    return const SizedBox.shrink();
  }
}
