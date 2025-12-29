import 'package:flutter/material.dart';

/// 検索結果が0件の場合の表示ウィジェット
class EmptySearchResult extends StatelessWidget {
  const EmptySearchResult({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            '検索結果がありません',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
