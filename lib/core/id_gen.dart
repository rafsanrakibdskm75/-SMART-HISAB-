/// Locally generated unique IDs (§9): data entry must never wait for a
/// server round-trip to get an ID. Format: <prefix>_<microseconds>_<counter>.
library;

class IdGen {
  static int _counter = 0;
  static String next(String prefix) {
    _counter++;
    return '${prefix}_${DateTime.now().toUtc().microsecondsSinceEpoch}_$_counter';
  }
}
