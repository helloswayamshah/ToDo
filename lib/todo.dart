class Todo {
  int key;
  String title;
  bool isFin;

  setIsFin(bool b) {
    isFin = b;
  }

  Todo(int k, String t) {
    key = k;
    title = t;
    isFin = false;
  }
}
