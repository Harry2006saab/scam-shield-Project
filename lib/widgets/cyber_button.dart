import 'package:flutter/material.dart';
import 'package:scam_shield/theme/cyber_theme.dart';

class CyberButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isSecondary;
  final IconData? icon;

  const CyberButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isSecondary = false,
    this.icon,
  });

  @override
  State<CyberButton> createState() => _CyberButtonState();
}

class _CyberButtonState extends State<CyberButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _glowAnimation = Tween<double>(begin: 4.0, end: 12.0).animate(
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return GestureDetector(
          onTapDown: (_) => _controller.forward(),
          onTapUp: (_) => _controller.reverse(),
          onTapCancel: () => _controller.reverse(),
          onTap: widget.isLoading ? null : widget.onPressed,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: widget.isSecondary
                    ? null
                    : const LinearGradient(
                        colors: [CyberTheme.primaryCyan, CyberTheme.secondaryCyan],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                border: widget.isSecondary
                    ? Border.all(color: CyberTheme.primaryCyan.withValues(alpha: 0.5), width: 2)
                    : null,
                boxShadow: widget.isLoading || widget.isSecondary
                    ? []
                    : [
                        BoxShadow(
                          color: CyberTheme.primaryCyan.withValues(alpha: 0.3),
                          blurRadius: _glowAnimation.value,
                          spreadRadius: 1,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (!widget.isLoading)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(
                            widget.icon,
                            color: widget.isSecondary ? CyberTheme.primaryCyan : Colors.black,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                        ],
                        Text(
                          widget.text.toUpperCase(),
                          style: TextStyle(
                            color: widget.isSecondary ? CyberTheme.primaryCyan : Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  if (widget.isLoading)
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: widget.isSecondary ? CyberTheme.primaryCyan : Colors.black,
                        strokeWidth: 3,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
