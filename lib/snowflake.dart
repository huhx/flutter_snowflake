import 'package:flutter_snowflake/snowflake_exception.dart';

/// snowflake include the mainly logic
class Snowflake {
  /// timestamp start from (Wed Oct 26 2021 00:00:00 GMT+0800 (China Standard Time)).
  static const int epoch = 1666713600000;

  static const int wrokerIdBits = 14;

  static const int sequenceBits = 8;

  static const int squenceMask = (1 << sequenceBits) - 1;

  static const int workerIdEftShiftBits = sequenceBits;

  static const int timestampEftShiftBits = workerIdEftShiftBits + wrokerIdBits;

  static const int workerIdMaxValue = (1 << wrokerIdBits) - 1;

  static const int maxTimestampBackwardsToWait = 10;

  late int workerId;

  int sequence = 0;

  int lastTimestamp = -1;

  Snowflake(this.workerId) {
    if (workerId > workerIdMaxValue || workerId < 1) {
      throw const SnowflakeException(
          "worker id can't be greater than $workerIdMaxValue or less than 1");
    }
  }

  /// genreate the snowflake id
  int getId() {
    int currentTimestamp = _getCurrentTimestamp();
    if (_tolerateTimestampBackwardsIfNeed(currentTimestamp)) {
      currentTimestamp = _getCurrentTimestamp();
    }
    // if current timestamp equals to previous one, we try to increase sequence
    if (lastTimestamp == currentTimestamp) {
      if (_sequenceIncreaseIfReachimitReset()) {
        currentTimestamp = _waitUntilNextTime(currentTimestamp);
      }
    } else {
      sequence = 0;
    }
    lastTimestamp = currentTimestamp;
    return ((currentTimestamp - epoch) << timestampEftShiftBits) |
        (workerId << workerIdEftShiftBits) |
        sequence;
  }

  /// if need to tolerate timesStamp backwards
  bool _tolerateTimestampBackwardsIfNeed(int curTimestamp) {
    if (lastTimestamp <= curTimestamp) {
      return false;
    }
    final int timeDifference = lastTimestamp - curTimestamp;
    if (timeDifference < maxTimestampBackwardsToWait) {
      _waitUntilNextTime(lastTimestamp);
    } else {
      throw const SnowflakeException("machine clock moved backward too much");
    }
    return true;
  }

  bool _sequenceIncreaseIfReachimitReset() {
    return 0 == (sequence = (sequence + 1) & squenceMask);
  }

  /// wait time that before next start
  int _waitUntilNextTime(int timestampToContinue) {
    int timestamp;
    do {
      timestamp = _getCurrentTimestamp();
    } while (timestamp <= timestampToContinue);
    return timestamp;
  }

  /// get current timestamp
  int _getCurrentTimestamp() {
    return DateTime.now().millisecondsSinceEpoch;
  }
}
