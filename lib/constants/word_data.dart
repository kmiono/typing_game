// lib/constants/words.dart
import 'dart:collection';

import '../models/word_data.dart';

const List<WordData> _wordPool = [
  WordData(id: 1, word: 'code', meaning: 'コード'),
  WordData(id: 2, word: 'data', meaning: 'データ'),
  WordData(id: 3, word: 'file', meaning: 'ファイル'),
  WordData(id: 4, word: 'loop', meaning: 'ループ'),
  WordData(id: 5, word: 'array', meaning: '配列'),
  WordData(id: 6, word: 'bug', meaning: 'バグ'),
  WordData(id: 7, word: 'test', meaning: 'テスト'),
  WordData(id: 8, word: 'debug', meaning: 'デバッグ'),
  WordData(id: 9, word: 'input', meaning: '入力'),
  WordData(id: 10, word: 'output', meaning: '出力'),
  WordData(id: 11, word: 'api', meaning: 'API'),
  WordData(id: 12, word: 'app', meaning: 'アプリ'),
  WordData(id: 13, word: 'web', meaning: 'ウェブ'),
  WordData(id: 14, word: 'net', meaning: 'ネット'),
  WordData(id: 15, word: 'link', meaning: 'リンク'),
  WordData(id: 16, word: 'git', meaning: 'Git'),
  WordData(id: 17, word: 'html', meaning: 'HTML'),
  WordData(id: 18, word: 'css', meaning: 'CSS'),
  WordData(id: 19, word: 'json', meaning: 'JSON'),
  WordData(id: 20, word: 'sql', meaning: 'SQL'),
];

final UnmodifiableListView<WordData> wordPool = UnmodifiableListView<WordData>(
  _wordPool,
);

List<WordData> fallbackWordPool({int count = 5}) {
  if (wordPool.isEmpty) {
    return const [
      WordData(id: 1, word: 'code'),
      WordData(id: 2, word: 'data'),
      WordData(id: 3, word: 'file'),
      WordData(id: 4, word: 'loop'),
      WordData(id: 5, word: 'array'),
    ];
  }
  return selectRandomWords(count: count);
}
