class Logger {
  static void Log(LogType logType, String tag, dynamic content) {
    print(tag);
    print(content);
  }
}

enum LogType { ERROR, MESSAGE, EXTRA }
