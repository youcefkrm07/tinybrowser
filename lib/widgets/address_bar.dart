import 'package:flutter/material.dart';

class AddressBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onGo;
  final VoidCallback onHome;
  final Function(String) suggestionsBuilder;

  const AddressBar({
    super.key,
    required this.controller,
    required this.onGo,
    required this.onHome,
    required this.suggestionsBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(); // Placeholder
  }
}
