import 'package:flutter/foundation.dart';
import 'package:flutter_snowflake/flutter_snowflake.dart';

void main() {
  final int id = SnowflakeIdGenerator.getId();
  if (kDebugMode) {
    print("Generated id $id");
  }
}