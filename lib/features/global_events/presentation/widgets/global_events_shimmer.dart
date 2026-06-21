import 'package:flutter/material.dart';

class GlobalEventsShimmer extends StatefulWidget {
  const GlobalEventsShimmer({super.key});

  @override
  State<GlobalEventsShimmer> createState() => _GlobalEventsShimmerState();
}

class _GlobalEventsShimmerState extends State<GlobalEventsShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double get _offset => (_controller.value * 2) - 1;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ListView.builder(
          itemCount: 8,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.all(8),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    _shimmerBox(
                      width: 60,
                      height: 60,
                      radius: 8,
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _shimmerBox(
                            width: double.infinity,
                            height: 16,
                          ),

                          const SizedBox(height: 8),

                          _shimmerBox(
                            width: 120,
                            height: 12,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _shimmerBox({
    required double width,
    required double height,
    double radius = 4,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          begin: Alignment(-1.0 - _offset, -0.3),
          end: Alignment(1.0 - _offset, 0.3),
          colors: [
            Colors.grey.shade300,
            Colors.grey.shade100,
            Colors.grey.shade300,
          ],
          stops: const [0.1, 0.3, 0.4],
        ),
      ),
    );
  }
}