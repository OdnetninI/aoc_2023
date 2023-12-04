import std::io;

File! input;

fn char getChar() {
    char! och = input.read_byte();
    if (catch och) return '\0';
    return och;
}

fn bool isDigit(char ch) {
  return ch >= '0' && ch <= '9';
}

fn char skipUntilNum(char ch) {
  while(!isDigit(ch)) {
    ch = getChar();
  }
  return ch;
}

fn char skipUntilNumOrSep(char ch) {
  while(!isDigit(ch) && ch != '|') {
    ch = getChar();
  }
  return ch;
}

fn char skipCardId(char ch) {
  while (ch != ':') {
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

  int[64] followingCopies = {
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    };

  while (try oc = input.read_byte()) {
    char c = oc;
    while (c != '\n') {
      //io::printfn("New Card");
      c = skipCardId(c);
      c = skipUntilNum(c);
      int[16] luckyNumbers = { -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1 };
      int idx = 0;
      while (c != '|') {
        c = processNumber(c);
        luckyNumbers[idx] = processedNumber;
        idx++;
        c = skipUntilNumOrSep(c);
      }

      bool coincidence = false;
      int points = 0;
      while (c != '\n') {
        c = skipUntilNum(c);
        c = processNumber(c);
        //io::printfn("Test Number: %d", processedNumber);
        for (int i = 0; i < luckyNumbers.len && luckyNumbers[i] != '-1'; ++i) {
          if (processedNumber == luckyNumbers[i]) {
            //io::printfn("Lucky!");
            if (!coincidence) {
              coincidence = true;
              points = 1;
            }
            else  {
              //points = points * 2;
              points++;
            }
          }
        }
      }
      //io::printfn("Card has a total of %d points", points);
      //sum += points;

      // Add the curent card
      sum += followingCopies[0];
      io::printfn("Current card has %d points and %d copies", points, followingCopies[0]);

      bool win = coincidence;
      if (win) {
        for (int i = 1; i <= points; ++i) {
          followingCopies[i] = followingCopies[i] + followingCopies[0];
        }  
      }

      for (int i = 1; i < 64; i++) {
        followingCopies[i - 1] = followingCopies[i];
        if (followingCopies[i] != 1) {
          io::printfn("Copies at %d - %d", i, followingCopies[i]);
        }
      }
      followingCopies[15] = 1;
    }
  }
  
  input.close()!!;
  io::printfn("Total: %d", sum);
}
