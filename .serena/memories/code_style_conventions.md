# Circle Marker コードスタイル・規約

## リント設定

### ベース
- `package:flutter_lints/flutter.yaml` を include

### エラー防止ルール
- `always_declare_return_types`: 戻り値の型を明示
- `avoid_print`: print 文を避ける（デバッグ用途以外）
- `avoid_returning_null_for_void`: void で null を返さない
- `cancel_subscriptions`: サブスクリプションをキャンセル
- `close_sinks`: Sink をクローズ
- `hash_and_equals`: hashCode と == を両方オーバーライド
- `no_duplicate_case_values`: switch 文で重複を避ける
- `prefer_void_to_null`: null より void を優先
- `use_key_in_widget_constructors`: ウィジェットコンストラクタで key を使用

### コードスタイルルール
- `prefer_const_constructors`: const コンストラクタを優先
- `prefer_const_constructors_in_immutables`: 不変クラスで const を優先
- `prefer_const_declarations`: const 宣言を優先
- `prefer_const_literals_to_create_immutables`: 不変リテラルで const を使用
- `prefer_final_fields`: final フィールドを優先
- `prefer_final_locals`: final ローカル変数を優先
- `sort_constructors_first`: コンストラクタを最初に配置
- `sort_unnamed_constructors_first`: 無名コンストラクタを最初に配置
- `curly_braces_in_flow_control_structures`: フロー制御構文で波括弧を使用

### パフォーマンスルール
- `avoid_unnecessary_containers`: 不要な Container を避ける
- `sized_box_for_whitespace`: 空白には SizedBox を使用
- `use_full_hex_values_for_flutter_colors`: 色に完全な HEX 値を使用

### ドキュメント
- `public_member_api_docs`: 現在コメントアウト（将来有効化予定）

## アナライザー設定

### 厳格モード
- `implicit-casts: false`: 暗黙的キャストを禁止
- `implicit-dynamic: false`: 暗黙的 dynamic を禁止

### エラー扱い
- `missing_return: error`: 戻り値の欠落をエラーとして扱う
- `dead_code: error`: デッドコードをエラーとして扱う

### 除外ファイル
- `**/*.g.dart`: コード生成ファイル
- `**/*.freezed.dart`: Freezed 生成ファイル

## コード生成規約

### Riverpod (@riverpod)
```dart
@riverpod
class MapDetailViewModel extends _$MapDetailViewModel {
  // ViewModel クラスは生成ベースクラスを継承
}
```

### Freezed (@freezed)
```dart
@freezed
class MapDetail with _$MapDetail {
  const factory MapDetail({
    required int mapId,
    required String title,
    // ...
  }) = _MapDetail;
  
  factory MapDetail.fromJson(Map<String, dynamic> json) =>
      _$MapDetailFromJson(json);
}
```

### JSON シリアライゼーション (@JsonSerializable)
- Freezed モデルに自動的に統合される

## 命名規則

### クラス・型
- PascalCase（例: `MapDetailViewModel`, `CircleRepository`）

### ファイル
- snake_case（例: `map_detail_view_model.dart`）
- 生成ファイルは元のファイル名に接尾辞:
  - `.g.dart`: Riverpod/JSON 生成
  - `.freezed.dart`: Freezed 生成

### 変数・関数
- camelCase（例: `mapId`, `saveMapImage`）

### プライベートメンバー
- アンダースコアプレフィックス（例: `_database`, `_initDatabase`）

## 一般的なパターン

### 不変性
- Freezed を使用して不変モデルを定義
- `const` コンストラクタを優先

### 非同期処理
- `Future` と `async/await` を使用
- エラーハンドリングは try-catch で実施

### ウィジェット構造
- ステートレスウィジェットを優先
- 状態管理は Riverpod に委譲
- 長押しで編集モードを有効化する UI パターン

### 座標変換
- `PixelPositioned` ウィジェットを使用して元画像座標と表示座標を変換
