import 'dart:html';
import 'interpreter.dart';

void main() {
  SpanElement output = querySelector('#output');
  TextAreaElement code = querySelector('#input-code');
  InputElement input = querySelector('#input');
  DivElement preview = querySelector('#preview');
  // Buttons
  var runButton = querySelector('#run');
  var stepButton = querySelector('#step');
  var pauseButton = querySelector('#pause');
  var stopButton = querySelector('#stop');
  var inputButton = querySelector('#input-submit');

  var started = false;

  var memoryCases = querySelectorAll('.case');

  var bf = BrainfuckInterpreter();

  bf.onOutput((outputText) {
    output.innerHtml += outputText;
  });

  bf.onMemoryChange((memory) {
    for (var i = 0; i < memory.length; i++) {
      memoryCases[i].innerHtml = '${memory[i]}';
    }
  });

  bf.onPointerMove((index) {
    querySelectorAll('.pointed').forEach((el) => el.classes.remove('pointed'));
    memoryCases[index].classes.add('pointed');
  });

  bf.onInput(() {
    input.parent.classes.remove('hidden');
    inputButton.addEventListener('click', (event) {
      if (input.value != null) {
        input.parent.classes.add('hidden');
        bf.setChar(input.value);
        input.value = '';
        bf.run(BrainfuckInterpreter.cleanCode(code.value));
      }
    });
  });

  bf.onOperation((index) {
    index -= 1;
    querySelectorAll('.highlight').forEach((el) {
      el.classes.remove('highlight');
    });

    var localIndex = 0;
    querySelectorAll('#preview .code').forEach((el) {
      if (localIndex == index) {
        el.classes.add('highlight');
      }
      localIndex++;
    });
  });

  bf.onDone(() {
    started = false;
    stopButton.classes.add('hidden');
    pauseButton.classes.add('hidden');
    runButton.classes.remove('hidden');
    bf.clear();

    preview.classes.add('hidden');
    code.classes.remove('hidden');
  });

  bf.onError((err) => print(err));

  runButton.addEventListener('click', (event) {
    var _code = code.value;
    if (!started) {
      started = true;
      var temp = '';
      for (var i = 0; i < _code.length; i++) {
        if (i == _code.indexOf('\n', i)) {
          temp += '<br>';
          i++;
          continue;
        }

        if ('<>+-[].,'.contains(_code[i])) {
          temp += '<span class="code">' + _code[i] + '</span>';
        } else {
          temp += '<span class="comment">' + _code[i] + '</span>';
        }
      }
      preview.innerHtml = temp;

      preview.classes.remove('hidden');
      code.classes.add('hidden');
    }
    output.innerText = '';
    runButton.classes.add('hidden');
    pauseButton.classes.remove('hidden');
    stopButton.classes.remove('hidden');
    bf.run(BrainfuckInterpreter.cleanCode(_code));
  });

  stepButton.addEventListener('click', (event) {
    var _code = code.value;
    if (!started) {
      started = true;
      var temp = '';
      for (var i = 0; i < _code.length; i++) {
        if (i == _code.indexOf('\n', i)) {
          temp += '<br>';
          continue;
        }

        if ('<>+-[].,'.contains(_code[i])) {
          temp += '<span class="code">' + _code[i] + '</span>';
        } else {
          temp += '<span class="comment">' + _code[i] + '</span>';
        }
      }
      preview.innerHtml = temp;

      preview.classes.remove('hidden');
      code.classes.add('hidden');
      stopButton.classes.remove('hidden');
    }
    bf.pause();
    bf.stepForward(BrainfuckInterpreter.cleanCode(_code));
    pauseButton.classes.add('hidden');
    runButton.classes.remove(('hidden'));
  });

  pauseButton.addEventListener('click', (event) {
    bf.pause();
    pauseButton.classes.add('hidden');
    runButton.classes.remove('hidden');
  });

  stopButton.addEventListener('click', (event) {
    if (started) {
      started = false;
    }
    bf.clear();
    runButton.classes.remove('hidden');
    pauseButton.classes.add('hidden');
    stopButton.classes.add('hidden');
    input.parent.classes.add('hidden');

    preview.classes.add('hidden');
    code.classes.remove('hidden');
  });
}
