import std::io;
import std::math;

int max_red = 12;
int max_green = 13;
int max_blue = 14;

fn bool isDigit(char c) {
  return c >= '0' && c <= '9';
}

fn bool isColor(char c) {
  switch(c) {
    case 'r':
    case 'g':
    case 'b':
      return true;
  }
  return false;
}

io::File! input;

fn char getChar() {
    char! och = input.read_byte();
    if (catch och) return '\0';
    return och;
}

fn char skipUntilNum(char ch) {
  while(!isDigit(ch)) {
    ch = getChar();
  }
  return ch;
}

fn char skipUntilNext(char ch) {
  while(!isDigit(ch) && 
    //ch != ',' && 
    //ch != ';' && 
    ch != '\n') {
    ch = getChar();
  }
  return ch;
}

fn char skipUntilColor(char ch) {
  while(!isColor(ch)) {
    ch = getChar();
  }
  return ch;
}

int processedNumber = 0;
fn char processNumber(char ch) {
  processedNumber = 0;
  while(isDigit(ch)) {
    processedNumber = processedNumber * 10;
    processedNumber += ch - '0';
    ch = getChar();
  }
  return ch;
}

fn void main(String[] args) {
  io::printfn("Welcome!!");

  ulong sum = 0; 
  input = io::file::open(args[1], "r");
  
  while(try oc = input.read_byte()) {
    char c = oc;
    // For each game
    while(c != '\n') {
      c = skipUntilNum(c);
      c = processNumber(c);
      int gameId = processedNumber;
      io::printfn("Game ID: %d", gameId);
      // Current c should be ':'
      c = skipUntilNum(c);
      // Now process the full game set
      int current_red = 0;
      int current_green = 0;
      int current_blue = 0;
      while(c != '\n') {
        c = processNumber(c);
        int curr = processedNumber;
        c = skipUntilColor(c);
        switch(c) {
          case 'r': current_red = math::max(current_red, curr);
          case 'g': current_green = math::max(current_green, curr);
          case 'b': current_blue = math::max(current_blue, curr);
        }
        c = skipUntilNext(c);
      }
      io::printfn("Red %d; Green %d; Blue %d", current_red, current_green, current_blue);
      if (current_red <= max_red && current_green <= max_green && current_blue <= max_blue) {
        sum += gameId;
        io::printfn("\tGame fills requirements :) partial -> %d", sum);
      }
    }
  }
  input.close()!!;

  io::printfn("Total: %d", sum);
}
