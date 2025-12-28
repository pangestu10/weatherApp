// ignore_for_file: deprecated_member_use

import 'dart:math' as math;
import 'package:flutter/material.dart';

class RainEffectWidget extends StatefulWidget {
  final double intensity;
  final bool isRaining;
  final Widget child;

  const RainEffectWidget({
    super.key,
    this.intensity = 0.5,
    required this.isRaining,
    required this.child,
  });

  @override
  State<RainEffectWidget> createState() => _RainEffectWidgetState();
}

class _RainEffectWidgetState extends State<RainEffectWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<RainDrop> _rainDrops = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    if (widget.isRaining) {
      _generateRainDrops();
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(RainEffectWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.isRaining != oldWidget.isRaining) {
      if (widget.isRaining) {
        _generateRainDrops();
        _controller.repeat();
      } else {
        _controller.stop();
        _rainDrops.clear();
      }
    }
    
    if (widget.isRaining && widget.intensity != oldWidget.intensity) {
      _generateRainDrops();
    }
  }

  void _generateRainDrops() {
    final dropCount = math.max(1, (15 * widget.intensity).round());
    _rainDrops = List.generate(dropCount, (index) {
      return RainDrop(
        x: math.Random().nextDouble() * 400, // Akan di-adjust di paint
        y: math.Random().nextDouble() * -200, // Mulai dari atas
        speed: 2.0 + math.Random().nextDouble() * 3.0, // Variasi kecepatan
        length: 8.0 + math.Random().nextDouble() * 15.0, // Variasi panjang
        opacity: 0.2 + math.Random().nextDouble() * 0.5, // Variasi transparansi
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
        return Stack(
          children: [
            // Content asli
            widget.child,
            // Efek hujan
            if (widget.isRaining)
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return RepaintBoundary(
                      child: CustomPaint(
                        painter: RainPainter(_rainDrops, _controller.value),
                        child: const SizedBox.expand(),
                      ),
                    );
                  },
                ),
              ),
          ],
        );
  }
}

class RainDrop {
  final double x;
  final double y;
  final double speed;
  final double length;
  final double opacity;

  RainDrop({
    required this.x,
    required this.y,
    required this.speed,
    required this.length,
    required this.opacity,
  });
}

class RainPainter extends CustomPainter {
  final List<RainDrop> rainDrops;
  final double animationValue;

  RainPainter(this.rainDrops, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || rainDrops.isEmpty) return;
    
    final paint = Paint()
      ..color = Colors.lightBlue.withOpacity(0.6)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Clamp values untuk avoiding overflow
    final maxHeight = size.height + 200.0;
    final maxWidth = size.width;

    for (final drop in rainDrops) {
      final dropY = (drop.y + (drop.speed * animationValue * 60)) % maxHeight;
      final dropX = (drop.x % maxWidth).clamp(0.0, maxWidth);
      
      final startOffset = Offset(dropX, dropY);
      final endOffset = Offset(dropX, (dropY + drop.length).clamp(0.0, maxHeight));
      
      paint.color = Colors.lightBlue.withOpacity(drop.opacity);
      canvas.drawLine(startOffset, endOffset, paint);
    }
  }

  @override
  bool shouldRepaint(covariant RainPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
