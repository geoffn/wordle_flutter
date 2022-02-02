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
  final List<String> wordOfTheDay = ['S', 'T', 'A', 'R', 'E'];

  List<BoxState> allBoxes = [];
  int activePosition = 0;
  int totalCorrectLetters = 0;

  @override
  void initState() {
    _newBoard();
    super.initState();
  }

  textEntryCallback(String submittedString) {
    setState(() {
      debugPrint('Setting State in Callback');
      if (submittedString == 'DELETE') {
        if (activePosition % 5 > 0) {
          activePosition = activePosition - 1;
          allBoxes[activePosition] = BoxState(cardStatus: CardStatus.unselected, cardValue: '');
        }
      } else {
        allBoxes[activePosition] = BoxState(cardStatus: CardStatus.incorrect, cardValue: submittedString);
        if ((activePosition + 1) % 5 == 0) {
          _checkWord();
        }
        activePosition = activePosition + 1;
      }
    });
  }

  bool _checkWord() {
    int correctAnswers = 0;
    int indexOfLetter = 0;
    debugPrint('Checking Word');
    for (int i = activePosition - 4; i < activePosition + 1; i++) {
      indexOfLetter = wordOfTheDay.indexOf(allBoxes[i].cardValue);
      debugPrint('Checking Word - IndexofLetter $indexOfLetter ');
      if (indexOfLetter > -1) {
        debugPrint('Checking index $i ${allBoxes[i].cardValue}');
        if (indexOfLetter == i) {
          allBoxes[i].cardStatus = CardStatus.correct;
          correctAnswers = correctAnswers + 1;
          debugPrint("Increment Correct $correctAnswers");
        } else {
          allBoxes[i].cardStatus = CardStatus.misplaced;
        }
      }
    }

    if (correctAnswers == 5) {
      setState(() {
        totalCorrectLetters = correctAnswers;
        debugPrint(totalCorrectLetters.toString());
      });
      return true;
    } else {
      setState(() {
        totalCorrectLetters = correctAnswers;
        debugPrint(totalCorrectLetters.toString());
      });

      return false;
    }
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

  Widget _buildBoard(List<BoxState> boxes, int totalCorrect) {
    List<Widget> boardRow = [];
    List<Row> board = [];
    bool hasFocus = false;

    for (int x = 0; x < 5; x++) {
      for (int y = 0; y < 5; y++) {
        if ((x * 5 + y) == activePosition) hasFocus = true;
        //debugPrint('Board $x $y $hasFocus $activePosition ');
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
      body: Column(
        children: [
          totalCorrectLetters == 5
              ? Text(
                  "You Win!!",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 70,
                  ),
                )
              : Text(
                  "Keep Trying!! $totalCorrectLetters",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 70,
                  ),
                ),
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: _buildBoard(allBoxes, totalCorrectLetters),
          ),
        ],
      ),
    );
  }
}
