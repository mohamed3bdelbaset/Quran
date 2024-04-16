import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

TextSpan span({
  required String text,
  required int pageIndex,
  required Color backgroundColor,
  required Color ayahColor,
  required Color textColor,
  required bool isFirstAyah,
  // TextSpan? lastCharacterSpan,
  LongPressStartDetailsFunction? onLongPressStart,
  LongPressDownDetailsFunction? onLongPressDown,
}) {
  if (text.isNotEmpty) {
    final String partOne = text.length < 3 ? text[0] : text[0] + text[1];
    final String? partTwo =
        text.length > 2 ? text.substring(2, text.length - 1) : null;
    final String initialPart = text.substring(0, text.length - 1);
    final String lastCharacter = text.substring(text.length - 1);
    TextSpan? first;
    TextSpan? second;
    if (isFirstAyah) {
      first = TextSpan(
        text: partOne,
        style: TextStyle(
          color: textColor,
          fontFamily: 'page${pageIndex + 1}',
          height: 2,
          letterSpacing: 30,
          backgroundColor: backgroundColor,
        ),
        recognizer: LongPressGestureRecognizer(
            duration: const Duration(milliseconds: 500))
          ..onLongPressDown = onLongPressDown
          ..onLongPressStart = onLongPressStart,
      );
      second = TextSpan(
        text: partTwo,
        style: TextStyle(
          color: textColor,
          fontFamily: 'page${pageIndex + 1}',
          height: 2,
          letterSpacing: 5,
          backgroundColor: backgroundColor,
        ),
        recognizer: LongPressGestureRecognizer(
            duration: const Duration(milliseconds: 500))
          ..onLongPressDown = onLongPressDown
          ..onLongPressStart = onLongPressStart,
      );
    }

    final TextSpan initialTextSpan = TextSpan(
      text: initialPart,
      style: TextStyle(
        color: textColor,
        fontFamily: 'page${pageIndex + 1}',
        height: 2,
        letterSpacing: 5,
        backgroundColor: backgroundColor,
      ),
      recognizer: LongPressGestureRecognizer(
          duration: const Duration(milliseconds: 500))
        ..onLongPressDown = onLongPressDown
        ..onLongPressStart = onLongPressStart,
    );

    // if (lastCharacterSpan == null)
    final TextSpan lastCharacterSpan = TextSpan(
      text: lastCharacter,
      style: TextStyle(
        fontFamily: 'page${pageIndex + 1}',
        height: 2,
        letterSpacing: 5,
        color: ayahColor,
        backgroundColor: backgroundColor,
      ),
      recognizer: LongPressGestureRecognizer(
          duration: const Duration(milliseconds: 500))
        ..onLongPressDown = onLongPressDown
        ..onLongPressStart = onLongPressStart,
    );

    return TextSpan(
      children: isFirstAyah
          ? [first!, second!, lastCharacterSpan]
          : [initialTextSpan, lastCharacterSpan],
      recognizer: LongPressGestureRecognizer(
          duration: const Duration(milliseconds: 500))
        ..onLongPressDown = onLongPressDown
        ..onLongPressStart = onLongPressStart,
    );
  } else {
    return const TextSpan(text: '');
  }
}

typedef LongPressStartDetailsFunction = void Function(LongPressStartDetails)?;

typedef LongPressDownDetailsFunction = void Function(LongPressDownDetails)?;
