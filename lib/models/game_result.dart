import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'game_state.dart';

@immutable
class GameResult {
  final double totalTime;
  final double accuracy;
  final double wpm;
  final int totalChars;
  final int correctChars;
  final int mistakes;

  const GameResult({
    required this.totalTime,
    required this.accuracy,
    required this.wpm,
    required this.totalChars,
    required this.correctChars,
    required this.mistakes,
  });

  factory GameResult.fromGameState(GameState state, {DateTime? endTime}) {
    final end = endTime ?? DateTime.now();
    final start = state.startTime;

    // 1. 総タイピング時間（秒、小数点第1位まで）
    double totalTimeSeconds = 0.0;
    if (start != null) {
      final duration = end.difference(start);
      totalTimeSeconds = duration.inMilliseconds / 1000.0;
      totalTimeSeconds = (totalTimeSeconds * 10).round() / 10.0;
    }

    // 2. 正確率（パーセント、小数点第1位まで）
    double accuracyPercent = 0.0;
    if (state.totalChars > 0) {
      accuracyPercent = (state.correctChars / state.totalChars) * 100.0;
      accuracyPercent = (accuracyPercent * 10).round() / 10.0;
    }

    // 3. WPM（Words Per Minute、小数点第1位まで）
    double wpmValue = 0.0;
    if (totalTimeSeconds > 0 && state.totalChars > 0) {
      final wordCount = state.totalChars / 5.0;
      final minutes = totalTimeSeconds / 60.0;
      wpmValue = wordCount / minutes;
      wpmValue = (wpmValue * 10).round() / 10.0;
    }

    // 4. 誤入力数はそのまま使用
    return GameResult(
      totalTime: totalTimeSeconds,
      accuracy: accuracyPercent,
      wpm: wpmValue,
      totalChars: state.totalChars,
      correctChars: state.correctChars,
      mistakes: state.mistakes,
    );
  }

  // 表示用のフォーマット済み文字列を返す
  String get formattedTotalTime => '${totalTime.toStringAsFixed(1)} seconds';
  String get formattedAccuracy => '${accuracy.toStringAsFixed(1)}%';
  String get formattedWpm => '${wpm.toStringAsFixed(1)} WPM';
  String get formattedMistakes => '$mistakes mistakes';
}
