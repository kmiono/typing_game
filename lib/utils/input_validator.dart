import 'package:flutter/material.dart';

/// 入力バリデーション結果
class ValidationResult {
  final bool isValid;
  final String? normalizedChar;

  const ValidationResult({required this.isValid, this.normalizedChar});

  /// 有効な入力
  factory ValidationResult.valid(String char) {
    return ValidationResult(isValid: true, normalizedChar: char.toLowerCase());
  }

  /// 無効な入力
  factory ValidationResult.invalid() {
    return const ValidationResult(isValid: false);
  }
}

/// 入力バリデーションユーティリティ
/// 設計書 7.2「バリデーション」に準拠
class InputValidator {
  /// 設計書 7.2: 入力文字のバリデーション
  /// 正規表現: ^[a-z]$
  /// 不正な入力は処理をスキップ（設計書 7.1）
  ///
  /// [input] ユーザーが入力した文字列（1文字以上でも可）
  ///
  /// 返り値: ValidationResult（有効な場合は正規化済み文字を含む）
  static ValidationResult validateInput(String input) {
    if (input.isEmpty) {
      return ValidationResult.invalid();
    }

    // 最初の1文字のみを取得
    final firstChar = input.characters.first;

    // 小文字に変換（設計書 5.2）
    final lowerChar = firstChar.toLowerCase();

    // 正規表現でバリデーション: ^[a-z]$
    // 設計書 7.2: 英字小文字のみを許可
    final isValid = RegExp(r'^[a-z]$').hasMatch(lowerChar);

    if (isValid) {
      return ValidationResult.valid(lowerChar);
    } else {
      // 設計書 7.1: 英字小文字以外は無視（処理をスキップ）
      return ValidationResult.invalid();
    }
  }

  /// 入力が有効かどうかを簡易チェック
  /// バリデーション結果の詳細が不要な場合に使用
  static bool isValidInput(String input) {
    return validateInput(input).isValid;
  }

  /// 入力文字を正規化（小文字に変換）
  /// バリデーション済みの文字列に対して使用
  static String normalizeChar(String input) {
    if (input.isEmpty) {
      return '';
    }
    return input.characters.first.toLowerCase();
  }
}
