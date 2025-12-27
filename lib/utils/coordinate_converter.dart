import 'dart:math';
import 'package:flutter/material.dart';

/// 画像座標とディスプレイ座標の変換を行う Pure Function クラス
///
/// BoxFit.contain を前提とした座標変換を提供します。
/// このクラスは状態を持たず、すべてのメソッドは純粋関数として実装されています。
class CoordinateConverter {
  const CoordinateConverter({
    required this.imageSize,
    required this.containerSize,
  });

  final Size imageSize;
  final Size containerSize;

  /// BoxFit.contain を考慮したスケール係数を計算
  ///
  /// 画像のアスペクト比とコンテナのアスペクト比を比較し、
  /// 画像全体が表示される最大のスケールを返します。
  double get scale {
    final widthScale = containerSize.width / imageSize.width;
    final heightScale = containerSize.height / imageSize.height;
    return min(widthScale, heightScale);
  }

  /// BoxFit.contain を考慮したオフセットを計算
  ///
  /// 画像がコンテナの中央に配置される場合のオフセットを返します。
  Offset get offset {
    final scaledWidth = imageSize.width * scale;
    final scaledHeight = imageSize.height * scale;
    return Offset(
      (containerSize.width - scaledWidth) / 2,
      (containerSize.height - scaledHeight) / 2,
    );
  }

  /// BoxFit.contain を考慮した実際の画像表示サイズを取得
  Size get displaySize {
    return Size(imageSize.width * scale, imageSize.height * scale);
  }

  /// 画像座標をディスプレイ座標に変換
  ///
  /// [pixelPosition] 元画像上のピクセル座標
  /// 戻り値: コンテナ内での表示座標
  Offset pixelToDisplay(Offset pixelPosition) {
    return Offset(
      pixelPosition.dx * scale + offset.dx,
      pixelPosition.dy * scale + offset.dy,
    );
  }

  /// 整数座標版: 画像座標をディスプレイ座標に変換
  ///
  /// [pixelX] 元画像上のX座標（ピクセル）
  /// [pixelY] 元画像上のY座標（ピクセル）
  /// 戻り値: コンテナ内での表示座標
  Offset pixelToDisplayInt(int pixelX, int pixelY) {
    return pixelToDisplay(Offset(pixelX.toDouble(), pixelY.toDouble()));
  }

  /// ディスプレイ座標を画像座標に変換
  ///
  /// [displayPosition] コンテナ内での表示座標
  /// 戻り値: 元画像上のピクセル座標
  Offset displayToPixel(Offset displayPosition) {
    return Offset(
      (displayPosition.dx - offset.dx) / scale,
      (displayPosition.dy - offset.dy) / scale,
    );
  }

  /// ディスプレイ座標を画像座標に変換（整数で返す）
  ///
  /// [displayPosition] コンテナ内での表示座標
  /// 戻り値: 元画像上のピクセル座標（整数に丸められる）
  Offset displayToPixelRounded(Offset displayPosition) {
    final pixel = displayToPixel(displayPosition);
    return Offset(pixel.dx.roundToDouble(), pixel.dy.roundToDouble());
  }

  /// サイズを画像座標からディスプレイ座標に変換
  ///
  /// [pixelSize] 元画像上のサイズ
  /// 戻り値: コンテナ内での表示サイズ
  Size sizePixelToDisplay(Size pixelSize) {
    return Size(pixelSize.width * scale, pixelSize.height * scale);
  }

  /// サイズをディスプレイ座標から画像座標に変換
  ///
  /// [displaySize] コンテナ内での表示サイズ
  /// 戻り値: 元画像上のサイズ
  Size sizeDisplayToPixel(Size displaySize) {
    return Size(displaySize.width / scale, displaySize.height / scale);
  }
}
