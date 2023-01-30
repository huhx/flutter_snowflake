/// snowflake exception
class SnowflakeException implements Exception {
  final String message;

  const SnowflakeException(this.message);
}
