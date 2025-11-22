import '../models/game_result.dart';
import '../models/game_state.dart';

/// スコア計算ユーティリティ
/// 設計書 5.4「スコア計算ロジック」に準拠
class ScoreCalculator {
  /// 設計書 5.4: calculateResult()
  /// GameStateからGameResultを計算して返す
  ///
  /// [state] ゲーム状態
  /// [endTime] 終了時刻（省略時は現在時刻）
  ///
  /// 返り値: GameResult オブジェクト
  static GameResult calculateResult(GameState state, {DateTime? endTime}) {
    final end = endTime ?? DateTime.now();
    final start = state.startTime;

    // 1. 総タイピング時間（秒、小数点第1位まで）
    // 計算式: 終了時刻 - 開始時刻
    final totalTimeSeconds = _calculateTotalTime(start, end);

    // 2. 正確率（パーセント、小数点第1位まで）
    // 計算式: (correctChars / totalChars) × 100
    // エッジケース: totalChars == 0 の場合は0%
    final accuracyPercent = _calculateAccuracy(
      state.correctChars,
      state.totalChars,
    );

    // 3. WPM（Words Per Minute、小数点第1位まで）
    // 計算式: (総文字数 / 5) / (総タイピング時間秒 / 60)
    // エッジケース: 総タイピング時間 == 0 の場合は0 WPM
    final wpmValue = _calculateWpm(state.totalChars, totalTimeSeconds);

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

  /// 総タイピング時間を計算（秒、小数点第1位まで）
  static double _calculateTotalTime(DateTime? start, DateTime end) {
    if (start == null) {
      return 0.0;
    }
    final duration = end.difference(start);
    final seconds = duration.inMilliseconds / 1000.0;
    // 小数点第1位まで（四捨五入）
    return (seconds * 10).round() / 10.0;
  }

  /// 正確率を計算（パーセント、小数点第1位まで）
  /// エッジケース: totalChars == 0 の場合は0%
  static double _calculateAccuracy(int correctChars, int totalChars) {
    if (totalChars == 0) {
      return 0.0;
    }
    final accuracy = (correctChars / totalChars) * 100.0;
    // 小数点第1位まで（四捨五入）
    return (accuracy * 10).round() / 10.0;
  }

  /// WPMを計算（Words Per Minute、小数点第1位まで）
  /// 計算式: (総文字数 / 5) / (総タイピング時間秒 / 60)
  /// エッジケース: 総タイピング時間 == 0 の場合は0 WPM
  static double _calculateWpm(int totalChars, double totalTimeSeconds) {
    if (totalTimeSeconds == 0 || totalChars == 0) {
      return 0.0;
    }
    // 総文字数を5で割って単語数に換算
    final wordCount = totalChars / 5.0;
    // 時間を分に換算
    final minutes = totalTimeSeconds / 60.0;
    final wpm = wordCount / minutes;
    // 小数点第1位まで（四捨五入）
    return (wpm * 10).round() / 10.0;
  }
}
