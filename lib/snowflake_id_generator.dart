import 'package:flutter_snowflake/worker_identity.dart';

import 'snowflake.dart';

class SnowflakeIdGenerator {
  static final Snowflake snowflake =
      Snowflake(WorkerIdentity().getWorkerId("127.0.0.1"));

  /// return snowflake id
  static int getId() {
    return snowflake.getId();
  }
}
