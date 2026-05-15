import 'package:flutter/material.dart';
import 'package:scam_shield/theme/cyber_theme.dart';

class AppLogo extends StatefulWidget {
  final double size;
  final bool showText;

  const AppLogo({
    super.key,
    this.size = 100,
    this.showText = false,
  });

  @override
  State<AppLogo> createState() => _AppLogoState();
}

class _AppLogoState extends State<AppLogo> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ScaleTransition(
          scale: _pulseAnimation,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer Glowing Ring
              Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: CyberTheme.primaryCyan.withValues(alpha: 0.2),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: CyberTheme.primaryCyan.withValues(alpha: 0.1),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
              ),
              // Inner Hexagon/Shield Background
              Container(
                width: widget.size * 0.7,
                height: widget.size * 0.7,
                decoration: BoxDecoration(
                  color: CyberTheme.primaryCyan.withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: CyberTheme.primaryCyan.withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  Icons.shield_rounded,
                  size: widget.size * 0.4,
                  color: CyberTheme.primaryCyan,
                ),
              ),
              // Scanning Line Effect
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Positioned(
                    top: widget.size * 0.2 + (_controller.value * widget.size * 0.6),
                    child: Container(
                      width: widget.size * 0.5,
                      height: 1.5,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            CyberTheme.accentNeon,
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        if (widget.showText) ...[
          const SizedBox(height: 16),
          Text(
            'SCAMSHIELD AI',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  letterSpacing: 4,
                  fontWeight: FontWeight.w900,
                ),
          ),
        ],
      ],
    );
  }
}
