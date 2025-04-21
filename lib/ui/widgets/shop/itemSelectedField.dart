import 'package:flutter/material.dart';

class itemselectedField extends StatelessWidget {
  final String title;
  final String? value;
  final String placeholder;
  final IconData icon;
  final Color? color;

  const itemselectedField({
    Key? key,
    required this.title,
    this.value,
    required this.placeholder,
    required this.icon,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null && value!.isNotEmpty;
    final displayColor = color ?? Colors.blue;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasValue ? displayColor.withOpacity(0.5) : Colors.grey[200]!,
          width: hasValue ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color:
                  hasValue ? displayColor.withOpacity(0.1) : Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: hasValue ? displayColor : Colors.grey[600],
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  hasValue ? value! : placeholder,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: hasValue ? FontWeight.w500 : FontWeight.normal,
                    color: hasValue ? Colors.black87 : Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.grey[500],
            size: 16,
          ),
        ],
      ),
    );
  }
}
