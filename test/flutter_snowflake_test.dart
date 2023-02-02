import 'package:flutter_snowflake/flutter_snowflake.dart';
import 'package:flutter_snowflake/snowflake.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("test id generator", () {
    final Snowflake snowflake = Snowflake(2, 3);

    final int id1 = snowflake.getId();
    final int id2 = snowflake.getId();

    expect(id2 - id1, greaterThan(0));
  });
}
