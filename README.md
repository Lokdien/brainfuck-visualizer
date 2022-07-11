<h1>Brainfuck Visualizer</h1>
<h2 style="font-weight: bold;">About</h2>
<p>This project is a interpreter / visualizer built in <strong>Dart</strong> of the  esoteric programming language, brainfuck.</p>
<a href="https://brainfuck-visualizer.netlify.app/">Go on website</a>
<h2 style="font-weight: bold;">What is brainfuck ?</h2>
<p>Brainfuck is an esoteric programming language created in 1993 by Urban Müller, and is notable for its extreme minimalism.

The language consists of only eight simple commands and an instruction pointer. While it is fully Turing complete, it is not intended for practical use, but to challenge and amuse programmers. Brainfuck simply requires one to break commands into microscopic steps..</p>
<a href="https://en.wikipedia.org/wiki/Brainfuck">Source : Wikipedia</a>

<h3 style="font-weight: bold;">Symbols</h3>
<blockquote><code>+</code> increment (increase by one) the byte at the data pointer.</blockquote>
<blockquote><code>-</code> decrement (decrease by one) the byte at the data pointer.</blockquote>
<blockquote><code>></code> increment the data pointer (to point to the next cell to the right).</blockquote>
<blockquote><code><</code> decrement the data pointer (to point to the next cell to the left).</blockquote>
<blockquote><code>,</code> accept one byte of input, storing its value in the byte at the data pointer.</blockquote>
<blockquote><code>.</code> output the byte at the data pointer.</blockquote>
<blockquote><code>[</code> if the byte at the data pointer is zero, then instead of moving the instruction pointer forward to the next command, jump it forward to the command after the matching <code>]</code> command.</blockquote>
<blockquote><code>[</code> if the byte at the data pointer is nonzero, then instead of moving the instruction pointer forward to the next command, jump it back to the command after the matching <code>[</code> command.
</blockquote>
