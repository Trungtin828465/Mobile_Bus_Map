import 'package:flutter/material.dart';
import 'package:utilitybus/models/address_suggestion_trip.dart';

class SuggestionListWidget extends StatelessWidget {
  final List<AddressSuggestion> suggestions;
  final Function(AddressSuggestion) onSelect; // Sửa kiểu từ Map<String, dynamic> thành AddressSuggestion

  SuggestionListWidget({required this.suggestions, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) return SizedBox.shrink();
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
            title: Text(suggestions[index].name),
            onTap: () => onSelect(suggestions[index]),
          );
        },
      ),
    );
  }
}