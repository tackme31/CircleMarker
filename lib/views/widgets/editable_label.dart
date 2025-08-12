import 'package:flutter/material.dart';

class EditableLabel extends StatefulWidget {
  final String initialText;
  final void Function(String)? onSubmit;
  final TextStyle? style;
  final int? maxLines;

  const EditableLabel({
    super.key,
    required this.initialText,
    this.style,
    this.maxLines = 1,
    this.onSubmit,
  });

  @override
  State<EditableLabel> createState() => _EditableLabelState();
}

class _EditableLabelState extends State<EditableLabel> {
  late String _text;
  bool _editing = false;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _text = widget.initialText;
    _controller = TextEditingController(text: _text);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() {
      _text = _controller.text;
      _editing = false;
    });
    if (widget.onSubmit != null) {
      widget.onSubmit!(_text);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_editing) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              maxLines: widget.maxLines,
              autofocus: true,
              onSubmitted: (_) => _submit(), // Enter押下でも確定可
            ),
          ),
          IconButton(icon: const Icon(Icons.check), onPressed: _submit),
        ],
      );
    } else {
      return GestureDetector(
        onTap: () {
          setState(() {
            _editing = true;
            _controller.text = _text;
          });
        },
        child: Text(_text, style: widget.style),
      );
    }
  }
}
