import 'package:flutter/material.dart';
import 'single_box.dart';

class Board extends StatefulWidget {
  const Board({Key? key}) : super(key: key);

  @override
  _BoardState createState() => _BoardState();
}

class BoxState {
  CardStatus cardStatus;
  String cardValue;

  BoxState({required this.cardStatus, required this.cardValue});
}

class _BoardState extends State<Board> {
  List<BoxState> allBoxes = [];
  int activePosition = 0;

  @override
  void initState() {
    _newBoard();
    super.initState();
  }

  textEntryCallback(String submittedString) {
    setState(() {
      debugPrint('Setting State in Callback');
      allBoxes[activePosition] = BoxState(cardStatus: CardStatus.incorrect, cardValue: submittedString);
      activePosition = activePosition + 1;
    });
  }

  void _newBoard() {
    debugPrint('Kicking of newBoard');
    for (int x = 0; x < 5; x++) {
      for (int y = 0; y < 5; y++) {
        allBoxes.add(BoxState(cardStatus: CardStatus.unselected, cardValue: ''));
        debugPrint('Box $x $y');
      }
    }
    debugPrint('Done newBoard');
  }

  Widget _buildBoard(List<BoxState> boxes) {
    List<Widget> boardRow = [];
    List<Row> board = [];
    bool hasFocus = false;

    for (int x = 0; x < 5; x++) {
      for (int y = 0; y < 5; y++) {
        if ((x * 5 + y) == activePosition) hasFocus = true;
        debugPrint('Board $x $y $hasFocus $activePosition ');
        boardRow.add(
          SingleBox(
            cardStatus: allBoxes[(x * 5 + y)].cardStatus,
            cardValue: allBoxes[(x * 5 + y)].cardValue,
            isActive: hasFocus ? true : false,
            callBackFunction: textEntryCallback,
          ),
        );
        hasFocus = false;
      }
      board.add(Row(children: boardRow));
      boardRow = [];
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: board,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: _buildBoard(allBoxes),
      ),
    );
  }
}
