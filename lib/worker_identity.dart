class WorkerIdentity {
  static const int sixMask = (1 << 6) - 1;

  /// get worker id from ip address
  /// [ipAddress] is ipv4 address
  int getWorkerId(String ipAddress) {
    final List<String> ips = ipAddress.split(".");

    assert(ips.length > 4, "$ipAddress should be ip v4 address.");
    final int subnet = int.parse(ips[2]);
    final int machine = int.parse(ips[3]);

    return (sixMask & subnet) << 8 | machine;
  }
}
