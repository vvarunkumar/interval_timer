import 'package:flutter/material.dart';

class TextEditingDialog extends StatelessWidget {
  final EdgeInsets titlePadding;
  final String initialVal;
  final Widget confirmWidget;
  final Widget cancelWidget;

  TextEditingDialog({
    this.titlePadding,
    this.initialVal,
    Widget confirmWidget,
    Widget cancelWidget,
  })  : confirmWidget = confirmWidget ?? new Text('OK'),
        cancelWidget = cancelWidget ?? new Text('CANCEL');

  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _controller.text = initialVal;
    return new AlertDialog(
      title: Text('Enter Text: '),
      content: Container(
        width: 65,
        child: TextField(
          controller: _controller,
        ),
      ),
      actions: [
        new FlatButton(
          onPressed: () => Navigator.of(context).pop(),
          child: cancelWidget,
        ),
        new FlatButton(
          onPressed: () => Navigator.of(context).pop(_controller.text),
          child: confirmWidget,
        ),
      ],
    );
  }
}
