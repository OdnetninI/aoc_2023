import std::io;

fn bool isDigit(char c) {
  return c >= '0' && c <= '9';
}

int state = 0;
int text_num = -1;

fn void reprocess(char c) {
  switch(c) {
    case 'o': state = 1;
    case 't': state = 2;
    case 'f': state = 3;
    case 's': state = 4;
    case 'e': state = 5;
    case 'n': state = 6;
    default: state = 0;
  }
}

fn bool processTextToDigit(char c) {
  switch(state) {
    case 0:
      switch(c) {
        case 'o': state = 1;
        case 't': state = 2;
        case 'f': state = 3;
        case 's': state = 4;
        case 'e': state = 5;
        case 'n': state = 6;
        default: state = 0;
      }
      return false;
    case 1:
      switch(c) {
        case 'n': state = 7;
        default: state = 0;
      }
      return false;
    case 2:
      switch(c) {
        case 'w': state = 8;
        case 'h': state = 9;
        default: state = 0;
      }
      return false;
    case 3:
      switch(c) {
        case 'o': state = 10;
        case 'i': state = 11;
        default: state = 0;
      }
      return false;
    case 4:
      switch(c) {
        case 'i': state = 12;
        case 'e': state = 13;
        default: state = 0;
      }
      return false;
    case 5:
      switch(c) {
        case 'i': state = 14;
        default: state = 0;
      }
      return false;
    case 6:
      switch(c) {
        case 'i': state = 15;
        default: state = 0;
      }
      return false;
    case 7:
      switch(c) {
        case 'e': state = 0; text_num = 1; return true;
        case 'i': state = 15;
        default: state = 0; return false;
      }
    case 8:
      switch(c) {
        case 'o': state = 0; text_num = 2; return true;
        default: state = 0; return false;
      }
    case 9:
      switch(c) {
        case 'r': state = 16;
        default: state = 0;
      }
      return false;
    case 10:
      switch(c) {
        case 'u': state = 17;
        case 'n': state = 7;
        default: state = 0;
      }
      return false;
    case 11:
      switch(c) {
        case 'v': state = 18;
        default: state = 0;
      }
      return false;
    case 12:
      switch(c) {
        case 'x': state = 0; text_num = 6; return true;
        default: state = 0;
      }
      return false;
    case 13:
      switch(c) {
        case 'v': state = 19;
        case 'i': state = 14; // se -> seight -> 8
        default: state = 0;
      }
      return false;
    case 14:
      switch(c) {
        case 'g': state = 20;
        default: state = 0;
      }
      return false;
    case 15:
      switch(c) {
        case 'n': state = 21;
        default: state = 0;
      }
      return false;
    case 16:
      switch(c) {
        case 'e': state = 22;
        default: state = 0;
      }
      return false;
    case 17:
      switch(c) {
        case 'r': state = 0; text_num = 4; return true;
        default: state = 0;
      }
      return false;
    case 18:
      switch(c) {
        case 'e': state = 0; text_num = 5; return true;
        default: state = 0;
      }
      return false;
    case 19:
      switch(c) {
        case 'e': state = 23;
        default: state = 0;
      }
      return false;
    case 20:
      switch(c) {
        case 'h': state = 24;
        default: state = 0;
      }
      return false;
    case 21:
      switch(c) {
        case 'e': state = 0; text_num = 9; return true;
        case 'i': state = 15;
        default: state = 0;
      }
      return false;
    case 22:
      switch(c) {
        case 'e': state = 0; text_num = 3; return true;
        case 'i': state = 14; // thre -> threight -> 8
        default: state = 0;
      }
      return false;
    case 23:
      switch(c) {
        case 'n': state = 0; text_num = 7; return true; 
        case 'i': state = 14; // seve -> seveight -> 8
        default: state = 0;
      }
      return false;
    case 24:
      switch(c) {
        case 't': state = 0; text_num = 8; return true;
        default: state = 0;
      }
      return false;
  }
  return false;
}

fn void main(String[] args) {
  io::printfn("Welcome!!");

  ulong sum = 0;
  
  io::File! input = io::file::open(args[1], "r");
  //io::File! input = io::file::open("test_input2", "r");
  //io::File! input = io::file::open("input", "r");
  
  while(!(input.eof()!!)) {
    char! oc = input.read_byte();
    if (catch oc) break;
    char c = oc;
    uint current = 0;
    int last = -1;
    bool found_first = false;
    while(c != '\n') {
      io::printf("%c", c);
        //io::printf("State %d: ", state);
      bool found_num = processTextToDigit(c);
        //io::printfn("Char %c -> State %d ", c, state);
        /*if (found_num) {
          io::printfn("Found char %c got number %d", c, text_num);
        }*/
      if (state == 0 && !found_num) {
        reprocess(c);
      }
      if (isDigit(c) || found_num) {
        if (!found_first) {
          found_first = true;
          if (found_num) { current = text_num; }
          else { current = c - '0'; }
        }
        else {
          if (found_num) { last = text_num; }
          else { last = c - '0'; }
        }
      }
      // Allow overlapping text numbers
      if (found_num) {
        //io::printf("Reprocessing %c: State: %d", c, state);
        processTextToDigit(c);
        //io::printfn("Char %c -> State %d ", c, state);
      }
      c = input.read_byte()!!;
    }
    if (last == -1) last = current;
    current = current * 10 + last;
    sum += current;
    io::printfn("\nCurr: %d", current);
    state = 0;
  }
  input.close()!!;

  io::printfn("Total: %d", sum);
}
