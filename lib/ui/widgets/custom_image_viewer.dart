

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:taskmanager/core/constants/common_colors.dart';


import '../../main.dart';

class CustomImage extends StatelessWidget {
  final String path;
  final double? width;
  final double? height;
  final double? shimmerHeight;
  final BoxFit fit;
  final BorderRadius borderRadius;
  final double scale;
  final Widget? shimmerChild;
  final ColorFilter? colorFilter;
  final Color ?color;
  final Widget Function(BuildContext, String, Object)? errorWidget;
  final VoidCallback? onImageLoaded;


  const CustomImage({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = BorderRadius.zero,
    this.colorFilter,
    this.scale = 1.0,
    this.errorWidget,
    this.shimmerChild, this.color,
    this.onImageLoaded, this.shimmerHeight,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: _getImageWidget(),
    );
  }

  Widget _getImageWidget() {
    if (_isNetworkImage(path)) {
      return _loadNetworkImage(path);
    } else if (_isAssetImage(path)) {
      return _loadAssetImage(path);
    } else if (_isFileImage(path)) {
      return _loadFileImage(path);
    } else {
      return _errorPlaceholder();
    }
  }

  Widget _loadNetworkImage(String url) {
    return _isSvg(url)
        ? SvgPicture.network(
      url,
      width: width,
      height: height,
      fit: BoxFit.contain,
      colorFilter: colorFilter,
      placeholderBuilder: (context) => _loading(),
    )
        :
    Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      scale: scale ?? 1.0,
      // Placeholder
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          // when fully loaded, trigger callback
          onImageLoaded?.call();
          return child;
        }
        return _loading();
      },
      // Error widget
      errorBuilder: (context, error, stackTrace) {
        return errorWidget?.call(context, url, error) ?? _errorPlaceholder();
      },
    );
  }

  Widget _loadAssetImage(String path) {
    return _isSvg(path)
        ? SvgPicture.asset(
      path,
      width: width,
      height: height,
      fit: BoxFit.contain,
      color: color,
      colorFilter: colorFilter,
      placeholderBuilder: (context) => _loading(),
    )
        : Image.asset(
      path,
      width: width,
      height: height,
      fit: fit,
      scale: scale,
      errorBuilder: (context, error, stackTrace) => _errorPlaceholder(),
    );
  }

  Widget _loadFileImage(String path) {
    return _isSvg(path)
        ? SvgPicture.file(
      File(path),
      width: width,
      height: height,
      fit: BoxFit.contain,
      colorFilter: colorFilter,
      placeholderBuilder: (context) => _loading(),
    )
        : Image.file(
      File(path),
      width: width,
      height: height,
      fit: fit,
      scale: scale,
      errorBuilder: (context, error, stackTrace) => _errorPlaceholder(),
    );
  }

  bool _isNetworkImage(String path) {
    return path.startsWith("http") || path.startsWith("https");
  }

  bool _isAssetImage(String path) {
    return path.startsWith("assets/");
  }

  bool _isFileImage(String path) {
    return File(path).existsSync();
  }

  bool _isSvg(String path) {
    return path.toLowerCase().endsWith(".svg");
  }

  Widget _errorPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey.withOpacity(0.25),
      child: Icon(Icons.image_outlined, color: AppColors.primary),
    );
  }


  Widget _loading(){
    return SizedBox();
  }


}