import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ExpandableShowMore extends HookWidget {
  const ExpandableShowMore({
    required this.child,
    this.scrollController,
    super.key,
    this.collapsedHeight = 300.0,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  final double collapsedHeight;
  final Widget child;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    /// この要素内の状態が画面外に出ても破棄されないように保持する
    useAutomaticKeepAlive();

    /// 要素に一意のキーを設定
    final contentKey = useMemoized(GlobalKey.new);

    /// 折りたたみが必要かどうか
    final shouldExpandable = useState(true);

    /// 折りたたみ状態
    final isExpanded = useState(true);

    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final box =
              contentKey.currentContext?.findRenderObject() as RenderBox?;
          // 要素の高さが折りたたみ基準の高さより小さい場合は折りたたみ不要
          if (box != null && box.size.height < collapsedHeight) {
            shouldExpandable.value = false;
            isExpanded.value = false;
          }
        });
        return null;
      },
      [child],
    );

    /// このchildの高さを条件によって変更する
    final height = switch ((shouldExpandable.value, isExpanded.value)) {
      (false, _) => null,
      (true, true) => collapsedHeight,
      (true, false) => null,
    };
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        // 画面を閉じた場合に親のAnimatedSizeの高さが正確に反映されない問題を解決するため
        // にIntrinsicHeightを使用
        IntrinsicHeight(
          child: AnimatedSize(
            duration: const Duration(milliseconds: 300),
            alignment: AlignmentDirectional.bottomCenter,
            curve: Curves.easeInOut,
            child: SizedBox(
              height: height,
              child: Stack(
                children: [
                  // 主にHtmlWidgetなどのColumn要素を内包するWidgetの
                  // オーバーフローを制御するために使用SingleChildScrollViewでラップ
                  SingleChildScrollView(
                    key: contentKey,
                    physics: const NeverScrollableScrollPhysics(),
                    child: child,
                  ),
                  if (shouldExpandable.value && isExpanded.value)
                    const _GradientMask(),
                ],
              ),
            ),
          ),
        ),
        if (shouldExpandable.value)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => onButtonPressed(contentKey, isExpanded),
              child: Text(isExpanded.value ? 'もっと見る' : '閉じる'),
            ),
          ),
      ],
    );
  }
}

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
  void onButtonPressed(
    GlobalKey contentKey,
    ValueNotifier<bool> isExpanded,
  ) {
    isExpanded.value = !isExpanded.value;

    // クリック時に現在のスクロール位置を保存
    if (scrollController != null && isExpanded.value) {
      final objectBox =
          contentKey.currentContext?.findRenderObject() as RenderBox?;

      if (objectBox != null) {
        final offset = objectBox.localToGlobal(
          Offset.zero,
          ancestor: scrollController!.position.context.storageContext
              .findRenderObject(),
        );
        // 画面上端に `child` の上端を揃える
        final targetScrollOffset = scrollController!.offset + offset.dy;

        scrollController!.animateTo(
          targetScrollOffset,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }
}
