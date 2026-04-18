import 'package:flutter/material.dart';

/// Card dùng chung cho các màn hình chấm công:
/// - Lịch sử chấm công
/// - Giải trình chấm công
/// - Sync chấm công offline
///
/// Style: white card, left accent border, rounded 12px, subtle shadow
class AttendanceStatusCard extends StatelessWidget {
  final Color leftBorderColor;
  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final Widget? badge;
  final VoidCallback? onTap;

  const AttendanceStatusCard({
    super.key,
    required this.leftBorderColor,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.badge,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Left accent border
            Positioned(
              left: 0,
              top: 10,
              bottom: 10,
              child: Container(
                width: 4,
                decoration: BoxDecoration(
                  color: leftBorderColor,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(4),
                    bottomRight: Radius.circular(4),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Leading (e.g. date column)
                  if (leading != null) ...[
                    leading!,
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.grey.shade200,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ],

                  // Content column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (title != null) title!,
                        if (subtitle != null) ...[
                          const SizedBox(height: 4),
                          subtitle!,
                        ],
                      ],
                    ),
                  ),

                  // Trailing (e.g. duration + status badge)
                  if (trailing != null) trailing!,
                ],
              ),
            ),

            // Badge indicator (top-right)
            if (badge != null)
              Positioned(
                right: 8,
                top: 8,
                child: badge!,
              ),
          ],
        ),
      ),
    );
  }
}
