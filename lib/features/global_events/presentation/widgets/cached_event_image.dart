import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedEventImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const CachedEventImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint('=================================');
    debugPrint('🖼️ CachedEventImage Build');
    debugPrint('📍 Image URL: $imageUrl');
    debugPrint('=================================');

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      clipBehavior: Clip.antiAlias,
      child: Container(
        width: width,
        height: height,
        color: Colors.grey[200],
        child: _buildImage(context),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    if (imageUrl.trim().isEmpty) {
      debugPrint('❌ Image URL is empty');
      return _buildErrorPlaceholder();
    }

    debugPrint('⏳ Attempting to load image: $imageUrl');

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,

      placeholder: (context, url) {
        debugPrint('⌛ Loading image from: $url');
        return const _EventImageShimmer();
      },

      imageBuilder: (context, imageProvider) {
        debugPrint('✅ Image loaded successfully');
        debugPrint('📍 URL: $imageUrl');

        return Image(
          image: imageProvider,
          fit: fit,
          width: width,
          height: height,
        );
      },

      errorWidget: (context, url, error) {
        debugPrint('=================================');
        debugPrint('❌ IMAGE LOAD FAILED');
        debugPrint('📍 URL: $url');
        debugPrint('🚨 ERROR TYPE: ${error.runtimeType}');
        debugPrint('🚨 ERROR: $error');
        debugPrint('=================================');

        return _buildErrorPlaceholder();
      },
    );
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      alignment: Alignment.center,
      color: Colors.grey[300],
      child: const Icon(
        Icons.broken_image,
        size: 32,
        color: Colors.grey,
      ),
    );
  }
}

class _EventImageShimmer extends StatefulWidget {
  const _EventImageShimmer({super.key});

  @override
  State<_EventImageShimmer> createState() => _EventImageShimmerState();
}

class _EventImageShimmerState extends State<_EventImageShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    debugPrint('✨ Shimmer Started');

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    debugPrint('✨ Shimmer Disposed');
    _controller.dispose();
    super.dispose();
  }

  double get _offset => (_controller.value * 2) - 1;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-1.0 - _offset, -0.3),
              end: Alignment(1.0 - _offset, 0.3),
              colors: [
                Colors.grey[300]!,
                Colors.grey[200]!,
                Colors.grey[300]!,
              ],
              stops: const [0.1, 0.3, 0.4],
            ),
          ),
        );
      },
    );
  }
}