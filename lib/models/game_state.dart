import 'package:flutter/foundation.dart';
import 'word_data.dart';

enum GameStatus { ready, countdown, playing, finished }

@immutable
class GameState {
  final int currentQuestionIndex;
  final List<WordData> selectedWords;
  final String currentWords;
  final int currentCharIndex;
  final String userInput;
  final DateTime? startTime;
  final int correctChars;
  final int totalChars;
  final int mistakes;
  final GameStatus gameStatus;

  const GameState({
    required this.currentQuestionIndex,
    required this.selectedWords,
    required this.currentWords,
    required this.currentCharIndex,
    required this.userInput,
    required this.startTime,
    required this.correctChars,
    required this.totalChars,
    required this.mistakes,
    required this.gameStatus,
  });

  factory GameState.initial(List<WordData> words) {
    final safeWords = words.isEmpty ? words : selectRandomWords(count: 5);
    final first = safeWords.isNotEmpty ? safeWords.first.word : '';
    return GameState(
      currentQuestionIndex: 0,
      selectedWords: safeWords,
      currentWords: first,
      currentCharIndex: 0,
      userInput: '',
      startTime: null,
      correctChars: 0,
      totalChars: 0,
      mistakes: 0,
      gameStatus: GameStatus.ready,
    );
  }
}
