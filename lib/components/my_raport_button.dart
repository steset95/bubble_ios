import 'package:flutter/material.dart';

class RaportButton extends StatelessWidget {
  final void Function()? onTap;
  const RaportButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        Icons.add,
            color: Colors.grey,
      ),
    );
  }
}
