import 'package:flutter/material.dart';

const primaryColor = Color(0xFF2697FF);
const secondaryColor = Color(0xFFFFFFFF);
const bgColor = Color(0xFFe9e9e9);
const storageBucketPath='gs://accesfy-882e6.appspot.com';
const sendGridApiKey="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";

/*const primaryColor = Color(0xFFc1272d);
const secondaryColor = Color(0xFFc59b6c);
const bgColor = Color(0xFF5f3926);*/
const serverToken="AAAAp-jUd-Y:APA91bH5eKykWgIpIm852lY1GD6mAdZ8JDn7BYfvuslZpehQOO5lQ-HwTBH22B_qci9yeT1ahB1pQU-8otkUjSNhRqvTrmAoN2MgvV7Roind2a6IRbyREG_kD5A-4t5498wgQKlkFAtr";


const defaultPadding = 16.0;

Iterable<List<T>> combinations<T>(List<List<T>> lists, [int index = 0, List<T>? prefix,]) sync* {
  prefix ??= <T>[];
  if (lists.length == index) {
    yield prefix.toList();
  }
  else {
    for (final value in lists[index]) {
      yield* combinations(lists, index + 1, prefix..add(value));
      prefix.removeLast();
    }
  }
}
