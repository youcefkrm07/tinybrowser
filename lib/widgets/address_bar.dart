import 'package:flutter/material.dart';

class AddressBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onGo;

  const AddressBar({
    Key? key,
    required this.controller,
    required this.onGo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Search or enter address',
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: onGo,
          ),
        ),
        onSubmitted: (_) => onGo(),
      ),
    );
  }
}
