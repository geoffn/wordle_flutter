import 'package:flutter/material.dart';

enum CardStatus { incorrect, correct, misplaced, unselected }

class SingleBox extends StatelessWidget {
  final CardStatus cardStatus;
  final String cardValue;
  final bool isActive;
  final Function(String) callBackFunction;

  const SingleBox({Key? key, required this.cardStatus, required this.cardValue, required this.isActive, required this.callBackFunction}) : super(key: key);

  Color _setColor() {
    switch (cardStatus) {
      case CardStatus.correct:
        return Colors.green;
      case CardStatus.incorrect:
        return Colors.black;
      case CardStatus.unselected:
        return Colors.black;
      case CardStatus.misplaced:
        return Colors.yellow;
    }
  }

  Widget _setWidget() {
    if (isActive) {
      return TextFormField(
        initialValue: '',
        autofocus: true,
        onChanged: (val) {
          debugPrint('in on changed ----------------');
          callBackFunction(val);
        },
      );
    } else {
      return Text(
        cardValue,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 70,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Box Called: $cardStatus');
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(color: _setColor(), border: Border.all(color: Colors.white)),
      child: _setWidget(),
    );
  }
}
