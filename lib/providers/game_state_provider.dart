// lib/providers/game_state_provider.dart
import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/game_state.dart';
import '../models/game_result.dart';
import '../models/word_data.dart';
import '../utils/input_validator.dart';
import '../utils/score_calculator.dart';
import '../utils/word_selector.dart';

/// ゲーム全体の状態管理（設計書 6.2 の GameStateNotifier に相当）
class GameStateProvider extends ChangeNotifier {
  GameStateProvider({WordSelector? wordSelector})
    : _wordSelector = wordSelector ?? WordSelector();

  final WordSelector _wordSelector;

  GameState _state = GameState.initial(const []);
  GameResult? _lastResult;
  Timer? _wordDelayTimer;

  GameState get state => _state;
  GameResult? get lastResult => _lastResult;

  /// スタート画面 → カウントダウン画面遷移時に呼び出し
  /// - 単語を5語ランダム選択（設計書 4.2 / 5.1）
  /// - GameStateを初期化
  void startGame({List<WordData>? predefinedWords}) {
    _cancelWordDelay();

    final words =
        predefinedWords ?? _wordSelector.pick(count: 5, allowDuplicates: true);

    _state = GameState.initial(words).beginCountdown();
    _lastResult = null;
    notifyListeners();
  }

  /// カウントダウン完了時に呼び出し、ゲーム開始
  void beginPlaying() {
    if (_state.gameStatus != GameStatus.countdown) return;

    _state = _state.startPlaying();
    notifyListeners();
  }

  /// ユーザー入力を処理（設計書 5.2 & 7.2）
  void handleInput(String rawInput) {
    if (_state.gameStatus != GameStatus.playing) return;

    final validation = InputValidator.validateInput(rawInput);
    if (!validation.isValid || validation.normalizedChar == null) {
      return; // 不正な入力は無視（設計書 7.1）
    }

    final updated = _state.checkInput(
      validation.normalizedChar!,
      onJudge: (isCorrect) {
        // UI側でフィードバックしたい場合はここでハンドル
      },
    );

    // 単語完了 → 0.5秒後に次へ（設計書 4.3 step 5）
    if (_state != updated &&
        updated.isWordCompleted &&
        !updated.isGameFinished) {
      _scheduleNextQuestion();
    } else if (updated.isGameFinished) {
      _completeGame(updated);
    } else {
      _state = updated;
      notifyListeners();
    }
  }

  /// 強制的に次の問題へ進める（必要ならUIから呼ぶ）
  void nextQuestion() {
    _cancelWordDelay();
    if (_state.isGameFinished) return;

    final updated = _state
        .copyWith(currentCharIndex: _state.currentWordss.length)
        .checkInput('', onJudge: null); // 既存ロジック再利用
    _state = updated.isGameFinished ? updated : updated;
    notifyListeners();
  }

  /// ゲームをリセット（スタート画面へ戻る）
  void reset() {
    _cancelWordDelay();
    _state = GameState.initial(const []);
    _lastResult = null;
    notifyListeners();
  }

  void dispose() {
    _cancelWordDelay();
    super.dispose();
  }

  // --- 内部処理 ---

  void _scheduleNextQuestion() {
    _cancelWordDelay();
    _wordDelayTimer = Timer(const Duration(milliseconds: 500), () {
      _wordDelayTimer = null;
      final nextState = _state
          .copyWithCurrentCharIndex(_state.currentWords.length)
          .checkInput('', onJudge: null);
      if (nextState.isGameFinished) {
        _completeGame(nextState);
      } else {
        _state = nextState;
        notifyListeners();
      }
    });
  }

  void _completeGame(GameState finishedState) {
    _cancelWordDelay();
    final result = ScoreCalculator.calculateResult(
      finishedState,
      endTime: DateTime.now(),
    );
    _state = finishedState.finish();
    _lastResult = result;
    notifyListeners();
  }

  void _cancelWordDelay() {
    _wordDelayTimer?.cancel();
    _wordDelayTimer = null;
  }
}
