import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function toDo;

  const CustomButton({
    super.key,
    required this.text,
    required this.toDo,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => toDo(),
      child: Container(
        width: 150,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}