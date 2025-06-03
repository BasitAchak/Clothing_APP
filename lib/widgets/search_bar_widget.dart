import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget { final Function(String) onSearch;

const SearchBarWidget({super.key, required this.onSearch});

@override Widget build(BuildContext context) { final TextEditingController controller = TextEditingController();

return Padding(
  padding: const EdgeInsets.all(16.0),
  child: TextField(
    controller: controller,
    decoration: InputDecoration(
      hintText: 'Search products...',
      prefixIcon: const Icon(Icons.search),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      suffixIcon: IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          controller.clear();
        },
      ),
    ),
    onSubmitted: onSearch,
  ),
);

} }