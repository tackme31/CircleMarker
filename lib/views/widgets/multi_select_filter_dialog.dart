import 'package:flutter/material.dart';

/// 複数選択可能なフィルターダイアログ
///
/// [T] はアイテムの型（例：String, MapDetail）
/// [K] は選択キーの型（例：String, int）
class MultiSelectFilterDialog<T, K> extends StatefulWidget {
  const MultiSelectFilterDialog({
    required this.title,
    required this.items,
    required this.initialSelection,
    required this.keyExtractor,
    required this.displayTextBuilder,
    required this.onApply,
    super.key,
  });

  /// ダイアログのタイトル
  final String title;

  /// 選択可能なアイテムのリスト
  final List<T> items;

  /// 初期選択されているキーのリスト
  final List<K> initialSelection;

  /// アイテムから選択キーを抽出する関数
  final K Function(T item) keyExtractor;

  /// アイテムから表示テキストを生成する関数
  final String Function(T item) displayTextBuilder;

  /// "適用"ボタンがクリックされたときのコールバック
  /// 選択されたキーのリストを受け取る
  final Future<void> Function(List<K> selectedKeys) onApply;

  @override
  State<MultiSelectFilterDialog<T, K>> createState() =>
      _MultiSelectFilterDialogState<T, K>();
}

class _MultiSelectFilterDialogState<T, K>
    extends State<MultiSelectFilterDialog<T, K>> {
  late List<K> _selectedKeys;

  @override
  void initState() {
    super.initState();
    // 初期選択をコピーして内部状態として管理
    _selectedKeys = List<K>.from(widget.initialSelection);
  }

  /// すべてのアイテムが選択されているかどうか
  bool get _isAllSelected => _selectedKeys.isEmpty;

  /// すべて選択/解除を切り替え
  void _toggleSelectAll() {
    setState(() {
      if (_isAllSelected) {
        // 現在すべて選択 → すべて解除（全キーを追加）
        _selectedKeys.clear();
        _selectedKeys.addAll(
          widget.items.map(widget.keyExtractor),
        );
      } else {
        // 現在部分選択 → すべて選択（リストをクリア）
        _selectedKeys.clear();
      }
    });
  }

  /// 個別アイテムの選択を切り替え
  void _toggleItem(K key) {
    setState(() {
      if (_selectedKeys.contains(key)) {
        _selectedKeys.remove(key);
      } else {
        _selectedKeys.add(key);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.all(8),
      title: Text(widget.title),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // すべて選択チェックボックス
              CheckboxListTile(
                title: const Text('すべて選択'),
                value: _isAllSelected,
                onChanged: (value) => _toggleSelectAll(),
              ),
              const Divider(),
              // 個別アイテムのチェックボックス
              ...widget.items.map((item) {
                final key = widget.keyExtractor(item);
                final isSelected = _selectedKeys.contains(key);
                return CheckboxListTile(
                  title: Text(widget.displayTextBuilder(item)),
                  value: isSelected,
                  onChanged: (value) => _toggleItem(key),
                );
              }),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('キャンセル'),
        ),
        TextButton(
          onPressed: () async {
            Navigator.of(context).pop();
            await widget.onApply(_selectedKeys);
          },
          child: const Text('適用'),
        ),
      ],
    );
  }
}
