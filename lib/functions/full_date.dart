String _twoDigits(int n) {
  if (n >= 10) {
    return "$n";
  }
  return "0$n";
}

getFullDateString() {
  DateTime now = DateTime.now();
  return '${now.day}/${_twoDigits(now.month)}/${_twoDigits(now.year)} ${_twoDigits(now.hour)}:${_twoDigits(now.minute)}:${_twoDigits(now.second)}';
}
