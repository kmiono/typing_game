import 'dart:math';

import '../models/word_data.dart';

class WordSelector {
  WordSelector({Random? random, List<WordData>? wordPool})
    : _random = random ?? Random(),
      _wordPool = wordPool ?? kWordPool;

  final Random _random;
  final List<WordData> _wordPool;

  /// 出題単語を count 個選ぶ。デフォルトは 5 問。
  /// - allowDuplicates=true で重複許可（設計書 5.1の注意事項）
  /// - プールが空の場合は空リストを返す（設計書 7.1「単語データが空」対策）
  List<WordData> pick({int count = 5, bool allowDuplicates = true}) {
    if (_wordPool.isEmpty || count <= 0) {
      return const [];
    }

    if (allowDuplicates) {
      return List<WordData>.generate(
        count,
        (_) => _wordPool[_random.nextInt(_wordPool.length)],
      );
    }
    // 重複禁止の場合（将来の拡張を想定）
    final shuffled = List<WordData>.from(_wordPool)..shuffle(_random);
    if (count >= shuffled.length) {
      return shuffled;
    }
    return shuffled.take(count).toList();
  }

  /// 5問固定で取得するショートカット。
  List<WordData> pickFive({bool allowDuplicates = true}) =>
      pick(count: 5, allowDuplicates: allowDuplicates);

  /// グローバルに使えるデフォルトインスタンス。
  final WordSelector defaultWordSelector = WordSelector();

  /// 既存の `selectRandomWords` 互換APIが必要な場合に利用。
  List<WordData> selectRandomWords({
    int count = 5,
    Random? random,
    bool allowDuplicates = true,
  }) {
    return WordSelector(
      random: random,
    ).pick(count: count, allowDuplicates: allowDuplicates);
  }
}
