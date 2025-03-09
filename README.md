# 📌 ExpandableShowMore Sample Project

このプロジェクトは、 **Flutterで折りたたみ可能なウィジェット (`ExpandableShowMore`) を試すためのサンプルプロジェクト** です。

## 🚀 概要

`ExpandableShowMore` は、ラップしたウィジェットの高さが一定の値を超えた場合に、
「もっと見る」ボタンを表示し、折りたたみ/展開の切り替えを可能にします。

**✅ 主な特徴**
- 指定した高さ (`collapsedHeight`) を超える場合のみ、折りたたみ機能を適用
- アニメーション付きの開閉 (`AnimatedSize` を使用)
- 閉じたときに要素の上端を **スクロール位置の上端に揃える**
- **グラデーションエフェクト** で折りたたみを示す
- `ScrollController` に対応し、外部の `ListView` などと連携可能
