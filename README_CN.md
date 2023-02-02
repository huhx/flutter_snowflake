Language: [中文简体](README_CN.md) | [English](README.md)

# flutter_snowflake
SnowFlake id 生成器，灵感来自 Twitter. 更多细节，可以参考<a href="https://developer.twitter.com/en/docs/basics/twitter-ids"> Twitter IDs </a>

## 🐱&nbsp;使用
### 添加依赖
```yaml
dependencies:
  flutter_snowflake: ^0.0.4
```

### 生成id
```dart
final int id = Snowflake(2, 3).getId();
```