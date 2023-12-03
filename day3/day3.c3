import std::io;

int width;
int height;
char* board;

fn int xyToidx(int x, int y) {
  return x + y * width;
}

fn char boardRead(int x, int y) {
  if (x < 0 || x >= width) return '\0';
  if (y < 0 || y >= height) return '\0';
  return board[xyToidx(x, y)];
}
 fn void boardWrite(int x, int y, char c) {
  if (x < 0 || x >= width) return;
  if (y < 0 || y >= height) return;
  board[xyToidx(x, y)] = c;
 }

fn bool isSymbol(char c) {
  if (c == '\0') return false;
  if (c == '\n') return false;
  if (c >= '0' && c <= '9') return false;
  if (c == '.') return false;
  return true;
}

fn bool isDigit(char c) {
  return c >= '0' && c <= '9';
}

fn int lookForNumberBackwards(int _x, int y) {
  int num = 0;
  int startNumber = _x;
  for (int x = _x -1; x >= 0; x--) {
    char c = boardRead(x, y);
    //io::printfn("\tLooking for start of number (curr char %c) [x = %d]", c, x);
    if (x == 0 && isDigit(c)) {
      startNumber = 0;
      //io::printfn("Start of number %d %d", x, startNumber);
      break;
    }
    if (!isDigit(c)) {
      startNumber = x + 1;
      //io::printfn("Start of number %d %d", x, startNumber);
      break;
    }
  }
  
  io::printfn("Start Number at %d", startNumber);

  for (int x = startNumber; x < width; x++) {
    char c = boardRead(x, y);
    if (!isDigit(c)) break;
    num = num * 10;
    num += c - '0';
    boardWrite(x, y, '.');
  }
  return num;
}

fn int lookupParts(int _x, int _y) {
  int sum = 0;
  for (int y = _y - 1; y <= _y + 1; y++) {
    for (int x = _x -1; x <= _x + 1; x++) {
      char c = boardRead(x, y);
      if (isDigit(c)) {
        io::printfn("Found %c at: %d %d", c, x, y);
        int found = lookForNumberBackwards(x, y);
        io::printfn("Found part %d", found);
        sum += found;
      }
    }
  }
  return sum;
}

fn void main(String[] args) {
  io::printfn("Welcome!!");

  ulong sum = 0; 
  File! input = io::file::open(args[1], "r");
  usz size = input.seek(0, END)!!;
  board = mem::new_array(char, size);
  input.seek(0, SET)!!;
  input.read(board[:size-1])!!;
  input.close()!!;

  int line_size = 0;
  for(int i = 0; board[i] != '\n'; ++i) { line_size++; }
  line_size++;

  io::printfn("Board is: %dx%d", line_size, size / line_size);

  width = line_size;
  height = ((int)size) / line_size;
  
  for (int y = 0; y < height; ++y) {
    // -1 to remove '\n'
    for (int x = 0; x < width - 1; ++x) {
      char c = boardRead(x, y);
      //io::printfn("%d %d -> %c", x, y, c);
      if (isSymbol(c)) {
        io::printf("Found Symbol %c\n", c);
        int parts = lookupParts(x, y);
        io::printfn(" -> %d", parts);
        sum += parts;
      }
    }
  }
  
  io::printfn("Total: %d", sum);
}
