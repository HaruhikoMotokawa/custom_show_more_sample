import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// ラップしたWidgetを折りたたみ表示するWidget
///
/// このWidgetは、ラップしたWidgetの高さが指定した高さを超えた場合に
/// 折りたたみ表示を行います。
///
/// INFO: 画像関連のWidgetには未対応です。
class ExpandableShowMore extends HookWidget {
  const ExpandableShowMore({
    required this.child,
    this.scrollController,
    this.collapsedHeight = 300.0,
    super.key,
  });

  /// 折りたたむ高さの基準
  ///
  /// デフォルトは300.0
  final double collapsedHeight;

  /// ラップするWidget
  final Widget child;

  /// スクロール位置を制御するためのコントローラ
  ///
  /// 呼び出し側のスクロール位置を制御するために使用
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    /// この要素内の状態が画面外に出ても破棄されないように保持する
    useAutomaticKeepAlive();

    /// 要素に一意のキーを設定
    final contentKey = useMemoized(GlobalKey.new);

    /// 折りたたみが必要かどうか
    final shouldCollapse = useState(true);

    /// 展開している状態かどうか
    final isExpanded = useState(false);

    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final box =
              contentKey.currentContext?.findRenderObject() as RenderBox?;
          // 要素の高さが折りたたみ基準の高さより小さい場合は折りたたみ不要
          if (box != null && box.size.height < collapsedHeight) {
            shouldCollapse.value = false;
          }
        });
        return null;
      },
      [],
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 画面を閉じた場合に親のAnimatedSizeの高さが正確に反映されない問題を解決するため
        // にIntrinsicHeightを使用
        IntrinsicHeight(
          child: AnimatedSize(
            duration: const Duration(milliseconds: 300),
            alignment: AlignmentDirectional.bottomCenter,
            curve: Curves.easeInOut,
            child: SizedBox(
              // 折りたたみが必要 かつ 折りたたみ状態の場合は高さを制限
              height: (shouldCollapse.value && isExpanded.value == false)
                  ? collapsedHeight
                  : null,
              child: Stack(
                children: [
                  // 主にHtmlWidgetなどのColumn要素を内包するWidgetの
                  // オーバーフローを制御するためにSingleChildScrollViewでラップ
                  SingleChildScrollView(
                    // このキーを指定されている要素の高さを取得するために使用
                    key: contentKey,
                    physics: const NeverScrollableScrollPhysics(),
                    // ここにラップ対象のWidgetが入る
                    child: child,
                  ),
                  // 折りたたみが必要 かつ 折りたたみ状態の場合はグラデーションを表示
                  if (shouldCollapse.value && isExpanded.value == false)
                    const _GradientMask(),
                ],
              ),
            ),
          ),
        ),
        // 折りたたみが必要の場合はボタンを表示
        if (shouldCollapse.value)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => onButtonPressed(contentKey, isExpanded),
              child: Text(isExpanded.value ? '閉じる' : 'もっと見る'),
            ),
          ),
      ],
    );
  }
}

/// 折りたたまれている場合に要素のタブにグラデーションをかける
class _GradientMask extends StatelessWidget {
  const _GradientMask();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.surface.withValues(alpha: 0),
              colorScheme.surface.withValues(alpha: 0.5),
              colorScheme.surface.withValues(alpha: 1),
            ],
          ),
        ),
      ),
    );
  }
}

extension on ExpandableShowMore {
  /// 'もっと見る' または '閉じる' ボタンの処理
  void onButtonPressed(
    GlobalKey contentKey,
    ValueNotifier<bool> isExpanded,
  ) {
    isExpanded.value = !isExpanded.value;

    // コントローラーを渡されている　かつ　折りたたみ状態になった場合
    if (scrollController != null && isExpanded.value == false) {
      // キーを指定されている要素（ExpandableShowMoreの子）のレンダーオブジェクトを取得
      final objectBox =
          contentKey.currentContext?.findRenderObject() as RenderBox?;

      if (objectBox != null) {
        // `objectBox` の現在のスクリーン座標（`Offset.zero` は左上の座標）を取得
        // `ancestor` にはスクロールビューのコンテキストを指定し、相対位置を計算する
        final offset = objectBox.localToGlobal(
          Offset.zero,
          ancestor: scrollController!.position.context.storageContext
              .findRenderObject(),
        );
        // `offset.dy` を加算して、スクロール位置を調整
        // `scrollController!.offset` は現在のスクロール位置
        // `offset.dy` は `objectBox` の現在のスクリーン上のY座標（= スクロール位置から見た要素の位置）
        final targetScrollOffset = scrollController!.offset + offset.dy;
        // 目標のスクロール位置へアニメーションで移動
        scrollController!.animateTo(
          targetScrollOffset,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }
}
