import 'dart:math';

String formatBytes(int size, [int fractionDigits = 2]) {
  if (size <= 0) return '0 B';
  final multiple = (log(size) / log(1024)).floor();
  return '${(size / pow(1024, multiple)).toStringAsFixed(fractionDigits)} ${[
    'B',
    'kB',
    'MB',
    'GB',
    'TB',
    'PB',
    'EB',
    'ZB',
    'YB',
  ][multiple]}';
}

int uuidToInt(String uuid) {
  // Remove hyphens from the UUID string
  String cleanUuid = uuid.replaceAll('-', '');

  // Take the first 8 characters (32 bits) of the UUID
  String substring = cleanUuid.substring(0, 8);

  // Parse the hexadecimal string to an integer
  return int.parse(substring, radix: 16);
}
