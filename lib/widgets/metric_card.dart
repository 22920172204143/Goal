import 'package:flutter/material.dart';

class MetricCard extends StatelessWidget {
  const MetricCard({
    super.key,
    required this.label,
    required this.value,
    this.highlight = false,
    this.icon,
  });

  final String label;
  final String value;
  final bool highlight;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final background = highlight
        ? const Color(0xFF234A45)
        : const Color(0xFF223147);
    final iconBg = highlight
        ? const Color(0x33F2CD79)
        : Colors.white.withValues(alpha: 0.05);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: highlight
              ? scheme.primary.withValues(alpha: 0.28)
              : Colors.white.withValues(alpha: 0.04),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (icon != null)
            Container(
              width: 28,
              height: 28,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: scheme.secondary, size: 16),
            ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }
}
