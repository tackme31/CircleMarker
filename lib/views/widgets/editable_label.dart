import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class EditableLabel extends StatefulWidget {
  const EditableLabel({
    super.key,
    required this.initialText,
    this.style,
    this.maxLines = 1,
    this.onSubmit,
  });

  final String initialText;
  final void Function(String)? onSubmit;
  final TextStyle? style;
  final int? maxLines;

  @override
  State<EditableLabel> createState() => _EditableLabelState();
}

class _EditableLabelState extends State<EditableLabel> {
  late String _text;
  bool _editing = false;
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _text = widget.initialText;
    _controller = TextEditingController(text: _text);
    _focusNode = FocusNode();

    // フォーカスが外れたときにsubmit
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && _editing) {
        _submit();
        _editing = false;
      }
    });
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

  Future<void> _onOpen(LinkableElement link) async {
    final uri = Uri.parse(link.url);

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $uri';
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
              focusNode: _focusNode,
              maxLines: widget.maxLines,
              autofocus: true,
            ),
          ),
        ],
      );
    } else {
      return GestureDetector(
        onLongPress: () {
          setState(() {
            _editing = true;
            _controller.text = _text;
            _focusNode.requestFocus();
          });
        },
        child: _text.isEmpty
            ? Text('No Text', style: widget.style)
            : Linkify(
                onOpen: _onOpen,
                text: _text,
                style: widget.style,
                linkStyle: widget.style?.copyWith(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
      );
    }
  }
}
