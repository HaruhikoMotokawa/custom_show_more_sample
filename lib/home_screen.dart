import 'package:custom_show_more_sample/constants.dart';
import 'package:custom_show_more_sample/expandable_show_more.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:gap/gap.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scrollController = useMemoized(ScrollController.new);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            children: [
              ExpandableShowMore(
                scrollController: scrollController,
                child: Text(
                  'One Piece',
                  style: textTheme.titleLarge,
                ),
              ),
              const Gap(8),
              Image.asset('assets/image.png'),
              const Gap(16),
              Text('作者: 尾田栄一郎', style: textTheme.titleMedium),
              const Gap(16),
              ElevatedButton(
                onPressed: () {},
                child: const Text('お気に入り作品集に登録だぞ'),
              ),
              const Gap(16),
              ExpandableShowMore(
                scrollController: scrollController,
                // HTMLを表示するWidget
                child: HtmlWidget(
                  onePieceHtml,
                  onTapUrl: (url) async {
                    // urlをコピーする
                    await Clipboard.setData(ClipboardData(text: url));
                    if (!context.mounted) return false;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('URLをコピーしました: $url')),
                    );
                    return true;
                  },
                ),
              ),
              const Gap(16),
              Text('連載開始日: 1997年12月24日', style: textTheme.titleSmall),
              const Gap(8),
              Text('連載誌: 週刊少年ジャンプ', style: textTheme.titleSmall),
              const Gap(8),
              Text('ジャンル: 少年漫画', style: textTheme.titleSmall),
              const Gap(8),
              Text(
                '公式サイト: https://one-piece.com/',
                style: textTheme.titleSmall,
              ),
              const Gap(16),
              Text('単行本', style: textTheme.titleMedium),
              const Gap(8),
              const ExpandableShowMore(
                child: Text(onePieceVolumes),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
