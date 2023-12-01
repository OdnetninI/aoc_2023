import std::io;

fn bool isDigit(char c) {
  return c >= '0' && c <= '9';
}

fn void main(String[] args) {
  io::printfn("Welcome!!");

  ulong sum = 0;
  
  //io::File! input = io::file::open("test_input", "r");
  io::File! input = io::file::open("input", "r");
  
  while(!(input.eof()!!)) {
    char! oc = input.read_byte();
    if (catch oc) break;
    char c = oc;
    uint current = 0;
    int last = -1;
    bool found_first = false;
    while(c != '\n') {
      if (isDigit(c)) {
        if (!found_first) {
          found_first = true;
          current = c - '0';
        }
        else {
          last = c - '0';
        }
      }
      c = input.read_byte()!!;
    }
    if (last == -1) last = current;
    current = current * 10 + last;
    sum += current;
    io::printfn("Curr: %d", current);
  }
  input.close()!!;

  io::printfn("Total: %d", sum);
}
