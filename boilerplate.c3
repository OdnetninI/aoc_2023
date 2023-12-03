import std::io;

File! input;

fn void main(String[] args) {
  io::printfn("Welcome!!");

  ulong sum = 0; 
  input = io::file::open(args[1], "r");


  
  input.close()!!;
  io::printfn("Total: %d", sum);
}
