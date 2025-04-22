import 'package:flutter/material.dart';

class SuggestionList extends StatelessWidget {
  final List<String> suggestions;
  final TextEditingController controller;
  final VoidCallback onSelected;

  const SuggestionList({
    required this.suggestions,
    required this.controller,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
      ),
      child: ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(suggestions[index]),
            onTap: () {
              controller.text = suggestions[index];
              onSelected();
            },
          );
        },
      ),
    );
  }
}