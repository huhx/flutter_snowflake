import 'package:flutter_snowflake/flutter_snowflake.dart';

void main() {
  final int id = Snowflake(3, 4).getId();
  print("Generated id $id");
}
