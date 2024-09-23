import 'package:flutter/material.dart';
import 'package:fincalweb_project/helper/size_config.dart';

class CalculateButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CalculateButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal.shade800,
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: Text(
          'Calculate',
          style: TextStyle(fontSize: 1.5.t, color: Colors.white),
        ),
      ),
    );
  }
}
