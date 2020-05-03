import 'dart:typed_data';

const tokens = '<>+-[].,';

class BrainfuckInterpreter {
  // Events
  Function(String) _onOutput;
  Function(Uint8List) _onMemoryChange;
  Function(int) _onPointerMove;
  Function(int) _onOperation;
  Function() _onInput;
  Function(String) _onError;
  Function() _onDone;
  // Local Variables
  bool _pause = false;
  bool _haveToSet = false;
  Uint8List _memory = Uint8List(30);
  int _codeIndex = 0;
  int _pointer = 0;
  Map _braces;

  BrainfuckInterpreter();

  Map getBraces(String code) {
    var braces = {};
    var temp = [];

    for (var i = 0; i < code.length; i++) {
      if (tokens.contains(code[i]) == false) continue;

      if (code[i] == '[') {
        temp.add(i);
      }
      if (code[i] == ']') {
        var target = temp.removeLast();
        braces[i] = target;
        braces[target] = i;
      }
    }

    return braces;
  }

  void pause() {
    if (!_pause) {
      _pause = true;
    }
  }

  void stepForward(String code) {
    _braces ??= getBraces(code);
    _pointer ??= 0;
    _memory ??= Uint8List(30);
    _codeIndex ??= 0;

    if (_codeIndex < code.length) {
      switch (code[_codeIndex]) {
        case '>':
          {
            if (_pointer + 1 < _memory.length) {
              _pointer++;
              _onPointerMove(_pointer);
            } else {
              _onError(
                  '> : Running out of memory, index: $_codeIndex, $_memory');
            }
          }
          break;

        case '<':
          {
            if (_pointer > 0) {
              _pointer--;
              _onPointerMove(_pointer);
            } else {
              _onError(
                  '< : Running out of memory, index: $_codeIndex $_memory');
            }
          }
          break;

        case '+':
          {
            _memory[_pointer] += 1;
            _onMemoryChange(_memory);
          }
          break;

        case '-':
          {
            _memory[_pointer] -= 1;
            _onMemoryChange(_memory);
          }
          break;

        case '.':
          {
            if (_onOutput != null) {
              _onOutput(String.fromCharCode(_memory[_pointer]));
            }
          }
          break;

        case ',':
          {
            _pause = true;
            _haveToSet = true;
            _onInput();
            return;
          }
          break;

        case '[':
          {
            if (_memory[_pointer] == 0) {
              _codeIndex = _braces[_codeIndex] +1;
            }
          }
          break;

        case ']':
          {
            if (_memory[_pointer] != 0) {
              _codeIndex = _braces[_codeIndex];
            }
          }
          break;
      }
      _codeIndex++;
      _onOperation(_codeIndex);
    } else {
      if (_onDone != null) {
        _onDone();
      }
    }
  }

  void run(String code) async {
    _pause = false;
    _onMemoryChange(_memory);
    _onPointerMove(_pointer);

    while (_codeIndex < code.length) {
      if (_pause) return;
      await Future.delayed(Duration(milliseconds: 100));
      stepForward(code);
    }
  }

  void setChar(String char) {
    if (_pause == false) return;
    if (_haveToSet == false) return;
    _haveToSet = false;
    _memory[_pointer] = char.isEmpty ?  ' '.codeUnitAt(0) : char.codeUnitAt(0);
    _codeIndex++;
    _onOperation(_codeIndex);
  }

  void clear() {
    _pause = true;
    _memory = Uint8List(30);
    _pointer = 0;
    _codeIndex = 0;
    _braces = null;
    _onMemoryChange(_memory);
    _onPointerMove(_pointer);
  }

  static String cleanCode(String code) {
    return code.replaceAll(RegExp(r'[^+<\[\].>,-]'), '');
  }

  // Listeners
  void onMemoryChange(Function(Uint8List) callback) {
    _onMemoryChange = callback;
  }

  void onOutput(Function(String) callback) {
    _onOutput = callback;
  }

  void onInput(Function() callback) {
    _onInput = callback;
  }

  void onDone(Function() callback) {
    _onDone = callback;
  }

  void onError(Function(String) callback) {
    _onError = callback;
  }

  void onOperation(Function(int) callback) {
    _onOperation = callback;
  }

  void onPointerMove(Function(int) callback) {
    _onPointerMove = callback;
  }
}
