import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ExpandableShowMore extends HookWidget {
  const ExpandableShowMore({
    required this.child,
    super.key,
    this.collapsedHeight = 300.0,
  });

  final double collapsedHeight;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    useAutomaticKeepAlive();
    final contentKey = useMemoized(GlobalKey.new);

    final shouldExpandable = useState(true);
    final isExpanded = useState(true);

    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final box =
              contentKey.currentContext?.findRenderObject() as RenderBox?;
          if (box != null && box.size.height < collapsedHeight) {
            // 折りたたみ不要
            shouldExpandable.value = false;
            isExpanded.value = false;
          }
        });
        return null;
      },
      [child],
    );
    final maxHeight = switch ((shouldExpandable.value, isExpanded.value)) {
      (false, _) => double.infinity,
      (true, true) => collapsedHeight,
      (true, false) => double.infinity,
    };
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: maxHeight,
            ),
            child: Stack(
              children: [
                IntrinsicHeight(
                  key: contentKey,
                  child: child,
                ),
                if (shouldExpandable.value && isExpanded.value)
                  Positioned(
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
                            Theme.of(context)
                                .colorScheme
                                .surface
                                .withValues(alpha: 0),
                            Theme.of(context)
                                .colorScheme
                                .surface
                                .withValues(alpha: 0.5),
                            Theme.of(context)
                                .colorScheme
                                .surface
                                .withValues(alpha: 1),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (shouldExpandable.value)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                isExpanded.value = !isExpanded.value;
              },
              child: Text(
                isExpanded.value ? 'もっと見る' : '閉じる',
              ),
            ),
          ),
      ],
    );
  }
}
