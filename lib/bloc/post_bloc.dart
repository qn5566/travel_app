class PostBloc {
  int _state = 0;

  get state => _state;

  int increment() {
    return _state++;
  }
}
