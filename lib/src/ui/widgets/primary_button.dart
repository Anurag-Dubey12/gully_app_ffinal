import 'package:flutter/material.dart';
import 'package:gully_app/src/ui/theme/theme.dart';

class PrimaryButton extends StatefulWidget {
  final Function onTap;
  final String? title;
  const PrimaryButton({super.key, required this.onTap, this.title});

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.onTap(),
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: AppTheme.primaryColor,
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(100, 93, 93, 0.4),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Text(
            widget.title ?? 'Continue',
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
