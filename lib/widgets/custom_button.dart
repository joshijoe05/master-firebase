import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;
  final String title;
  const CustomButton(
      {super.key,
      required this.onTap,
      required this.title,
      this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
      style: TextButton.styleFrom(
          minimumSize: Size(double.infinity, 50),
          padding: EdgeInsets.symmetric(vertical: 12),
          backgroundColor: Colors.deepPurple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          )),
    );
  }
}
