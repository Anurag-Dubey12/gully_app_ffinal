import 'package:logger/logger.dart';

var logger = Logger(
  level: Level.all,
  printer: PrefixPrinter(
    PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: false,
    ),
  ),
  filter: DevelopmentFilter(),
);
