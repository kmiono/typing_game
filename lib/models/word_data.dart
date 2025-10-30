import 'dart:math';

class WordData {
  final int id;
  final String word;
  final String? meaning;

  const WordData({required this.id, required this.word, this.meaning});
}

const List<WordData> kWordPool = [
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

List<WordData> selectRandomWords({int count = 5, Random? random}) {
  final rng = random ?? Random();
  if (kWordPool.isEmpty) {
    return [];
  }

  return List<WordData>.generate(
    count,
    (_) => kWordPool[rng.nextInt(kWordPool.length)],
  );
}
