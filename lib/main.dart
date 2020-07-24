import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: TikTakToe(),
    theme: ThemeData(
      primaryColor: Colors.blueGrey,
    ),
  ));
}

class TikTakToe extends StatefulWidget {
  @override
  _TikTakToeState createState() => _TikTakToeState();
}

class _TikTakToeState extends State<TikTakToe> {
  String _turn = "circle";
  List<List<Widget>> _circleorcross = [];
  List<List<int>> _wincombination = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6]
  ];

  List<List<int>> _board = [];
  String _winner;
  int _turns = 0;
  double _spreadradius = 4.0;
  double _blur = 4.0;

  String _findwinner() {
    // look for winning possibility of cross when turn is of circle
    if (_turn == "circle") {
      for (int i = 0; i < _wincombination.length; i++) {
        if (_board[_wincombination[i][0] ~/ 3]
                    [_wincombination[i][0] % 3] ==
                1 &&
            _board[_wincombination[i][1] ~/ 3][_wincombination[i][1] % 3] ==
                1 &&
            _board[_wincombination[i][2] ~/ 3][_wincombination[i][2] % 3] ==
                1) {
          return "cross";
        }
      }
    } else {
      for (int i = 0; i < _wincombination.length; i++) {
        if (_board[_wincombination[i][0] ~/ 3]
                    [_wincombination[i][0] % 3] ==
                0 &&
            _board[_wincombination[i][1] ~/ 3][_wincombination[i][1] % 3] ==
                0 &&
            _board[_wincombination[i][2] ~/ 3][_wincombination[i][2] % 3] ==
                0) {
          return "circle";
        }
      }
    }
    if (_turns == 9) {
      return "tie";
    }
    return null;
  }

  Padding _buttonbuilder(int row, int button) {
    return Padding(
      padding: EdgeInsets.all(3.0),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              spreadRadius: _spreadradius,
              blurRadius: _blur,
              offset: Offset(3, 2),
            ),
          ],
        ),
        child: FlatButton(
          child: _circleorcross[row][button],
          onPressed: () {
            if (_circleorcross[row][button] == null && _winner == null) {
              setState(() {
                _turns++;
                if (_turn == "circle") {
                  _circleorcross[row][button] = CircleAvatar(
                    backgroundColor: Colors.black87,
                    radius: 15.0,
                  );
                  _board[row][button] = 0;
                  _turn = "cross";
                } else {
                  _circleorcross[row][button] = Icon(
                    Icons.close,
                    size: 40.0,
                    color: Colors.black,
                  );
                  _board[row][button] = 1;
                  _turn = "circle";
                }
              });

              _winner = _findwinner();
              if (_winner != null) {
                _blur = 0.0;
                _spreadradius = 0.0;
              }
            }
          },
        ),
      ),
    );
  }

  Row _turnbuilder() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Turn is of ",
          style: TextStyle(fontSize: 30.0),
        ),
        _turn == "circle"
            ? CircleAvatar(
                backgroundColor: Colors.black87,
                radius: 9.0,
              )
            : Icon(
                Icons.close,
                size: 30.0,
                color: Colors.black,
              ),
      ],
    );
  }

  Row _rowbuilder(int row) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buttonbuilder(row, 0),
        _buttonbuilder(row, 1),
        _buttonbuilder(row, 2),
      ],
    );
  }

  Padding _boardbuilder() {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          _rowbuilder(0),
          _rowbuilder(1),
          _rowbuilder(2),
        ],
      ),
    );
  }

  void _startagain() {
    setState(() {
      _turn = "circle";
      _circleorcross = [];
      _board = [];
      _winner = null;
      _turns = 0;
      for (int i = 0; i < 3; i++) {
        _circleorcross.add([null, null, null]);
        _board.add([null, null, null]);
      }
      _spreadradius = 4.0;
      _blur = 4.0;
    });
  }

  Column _finishgamebuilder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _winner != null && _winner != "tie"
                ? _winner == "circle"
                    ? CircleAvatar(
                        backgroundColor: Colors.black87,
                        radius: 9.0,
                      )
                    : Icon(
                        Icons.close,
                        size: 30.0,
                        color: Colors.black,
                      )
                : Text(""),
            _winner == null
                ? Text("")
                : _winner == "tie"
                    ? Text(
                        "Tie",
                        style: TextStyle(fontSize: 30.0),
                      )
                    : Text(
                        " wins",
                        style: TextStyle(fontSize: 30.0),
                      ),
          ],
        ),
        _winner != null
            ? SizedBox(
                height: 20,
              )
            : SizedBox(),
        _winner != null
            ? RaisedButton(
                onPressed: _startagain,
                child: Text("Restart"),
                splashColor: Colors.red,
              )
            : Text(""),
      ],
    );
  }

  @override
  void initState() {
    for (int i = 0; i < 3; i++) {
      _circleorcross.add([null, null, null]);
      _board.add([null, null, null]);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Tik Tak Toe",
            style: TextStyle(fontSize: 25),
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 80,
            ),
            _turnbuilder(),
            SizedBox(
              height: 40,
            ),
            _boardbuilder(),
            SizedBox(
              height: 40,
            ),
            _finishgamebuilder(),
          ],
        ),
      ),
    );
  }
}
