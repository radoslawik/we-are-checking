import 'dart:convert';
import 'dart:io';

class LivetimingConversion {
  // Some data from livetiming is decoded in a specific way, this function converts it to the human form lol
  // Useful link: https://github.com/theOehrly/Fast-F1/blob/master/fastf1/api.py#L930
  // Sample input: "7ZbNagMhEIDfZc5JmBln/LuGvkF7SeghlEALYQ9Jbsu+e4y9FLqEMlCCi5dR1A911A9HeBmu56/jBfJ+hLfrB2RgZF5jWDt6Jc7IWfxGFL3GsIMVbA/nMnoEuoft52EYjqfagJBxBVyjq1Fq1O/6vZim2mXixMipkfNGjtAKWjNKc6kRDvqDpd8sVda8zWgEeS4/LkV+zNbVMlsntd46tl47Zz1Nsc4owfpCzE9kLqtKFP9wlMG22oI+8pQvnuJE3VPteEq1KU+F0D21CE9JRPc0T0VCj6rdU814Sl2M7XhKkPp/aiGeKqJ6kqfChlyxVOz/qXY8JZxSU57y3VPL8JSj9J+eep9u";
  static String decodeToString(String rawInput) {
    final decodedString = base64.decode(rawInput);
    final zlibDecoder = ZLibDecoder(raw: true);
    final outputBytes = zlibDecoder.convert(decodedString);
    final outputString = utf8.decode(outputBytes);
    return outputString;
  }

  static Duration? parseDuration(String s) {
    int? hours = 0;
    int? minutes = 0;
    final parts = s.split(':');
    if (parts.length > 2) {
      hours = int.tryParse(parts[parts.length - 3]);
    }
    if (parts.length > 1) {
      minutes = int.tryParse(parts[parts.length - 2]);
    }
    final microseconds = double.tryParse(parts[parts.length - 1]);
    return hours != null && minutes != null && microseconds != null
        ? Duration(
            hours: hours,
            minutes: minutes,
            microseconds: (microseconds * 1000000).round())
        : null;
  }
}
