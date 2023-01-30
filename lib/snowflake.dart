import 'package:flutter_snowflake/snowflake_exception.dart';

class Snowflake {
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

  int getId() {
    int currentTimestamp = getCurrentTimestamp();
    if (tolerateTimestampBackwardsIfNeed(currentTimestamp)) {
      currentTimestamp = getCurrentTimestamp();
    }
    // if current timestamp equals to previous one, we try to increase sequence
    if (lastTimestamp == currentTimestamp) {
      if (sequenceIncreaseIfReachimitReset()) {
        currentTimestamp = waitUntilNextTime(currentTimestamp);
      }
    } else {
      sequence = 0;
    }
    lastTimestamp = currentTimestamp;
    return ((currentTimestamp - epoch) << timestampEftShiftBits) |
        (workerId << workerIdEftShiftBits) |
        sequence;
  }

  bool tolerateTimestampBackwardsIfNeed(int curTimestamp) {
    if (lastTimestamp <= curTimestamp) {
      return false;
    }
    int timeDifference = lastTimestamp - curTimestamp;
    if (timeDifference < maxTimestampBackwardsToWait) {
      waitUntilNextTime(lastTimestamp);
    } else {
      throw const SnowflakeException("machine clock moved backward too much");
    }
    return true;
  }

  bool sequenceIncreaseIfReachimitReset() {
    return 0 == (sequence = (sequence + 1) & squenceMask);
  }

  int waitUntilNextTime(int timestampToContinue) {
    int timestamp;
    do {
      timestamp = getCurrentTimestamp();
    } while (timestamp <= timestampToContinue);
    return timestamp;
  }

  int getCurrentTimestamp() {
    return DateTime.now().millisecondsSinceEpoch;
  }
}
