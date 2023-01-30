import 'package:flutter_snowflake/flutter_snowflake.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("test id generator", () {
    final int id1 = SnowflakeIdGenerator.getId();
    final int id2 = SnowflakeIdGenerator.getId();

    final int value = id2 - id1;

    expect(value, greaterThan(0));
  });
}
