import 'package:custom_show_more_sample/expandable_show_more.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:gap/gap.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Image.asset('assets/image.png'),
              const Gap(8),
              Text(
                'One Piece',
                style: textTheme.titleLarge,
              ),
              const Gap(8),
              Text('作者: 尾田栄一郎', style: textTheme.titleMedium),
              const Gap(16),
              ElevatedButton(
                onPressed: () {},
                child: const Text('お気に入り作品集に登録だぞ'),
              ),
              const Gap(16),
              ExpandableShowMore(
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
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

const onePieceHtml = '''
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>
    <iframe width="560" height="315" 
        src="https://www.youtube.com/embed/b_sQ9bMltGU" 
        frameborder="0" 
        allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" 
        allowfullscreen>
    </iframe>
    <div>
        <h1>ワンピース登場キャラクター</h1>
        <div>
            <h2>モンキー・D・ルフィ</h2>
            <p><strong>概要:</strong> 麦わらの一味の船長で、ゴムゴムの実の能力者。自由を愛し、どんな困難にも立ち向かう不屈の精神を持つ。海賊王を目指し、仲間と共に航海を続けている。</p>
            <p><strong>ストーリー:</strong> 幼い頃、シャンクスから受け取った麦わら帽子を大切にし、「いつか必ず返しに行く」と誓った。グランドラインを進む中で、仲間を増やし、強敵たちと戦いながら成長していく。</p>
        </div>

        <div>
            <h2>ロロノア・ゾロ</h2>
            <p><strong>概要:</strong> 麦わらの一味の剣士で、三刀流を操る剣の達人。剣士としての誇りを持ち、世界最強の剣士になることを目標にしている。</p>
            <p><strong>ストーリー:</strong> 幼少期に亡き親友くいなの夢を受け継ぎ、剣の修行に励んできた。ルフィに助けられ仲間となり、数々の戦いを乗り越えながら強さを磨いている。</p>
        </div>

        <div>
            <h2>ナミ</h2>
            <p><strong>概要:</strong> 麦わらの一味の航海士で、天候を読み解く天才的な能力を持つ。お金を愛し、世界地図を作るという夢を持っている。</p>
            <p><strong>ストーリー:</strong> 幼い頃に育ての親を海賊に奪われ、借金を返すために海賊専門の泥棒をしていたが、ルフィに救われ仲間となる。その後も航海の知識を活かし、仲間を支え続けている。</p>
        </div>

        <div>
            <h2>ウソップ</h2>
            <p><strong>概要:</strong> 麦わらの一味の狙撃手で、ホラ吹きだが実は仲間想いの優しい性格。勇敢な海の戦士を目指している。</p>
            <p><strong>ストーリー:</strong> 幼い頃から父親の影響で海賊に憧れを持ち、ルフィたちと出会い仲間になる。弱気な部分もあるが、勇気を出して戦う姿は仲間たちにとって心強い存在となっている。</p>
        </div>

        <div>
            <h2>サンジ</h2>
            <p><strong>概要:</strong> 麦わらの一味のコックで、蹴り技を駆使して戦う紳士的な男。女性に優しく、料理への情熱が強い。</p>
            <p><strong>ストーリー:</strong> 幼い頃、命を救われたゼフから料理と生きる意味を学び、グランドラインの「オールブルー」を探す夢を抱く。仲間のために料理を作り、戦闘でも活躍する。</p>
        </div>

        <div>
            <h2>トニートニー・チョッパー</h2>
            <p><strong>概要:</strong> ヒトヒトの実を食べた青鼻のトナカイで、麦わらの一味の医者。人間の言葉を話し、医療知識が豊富。</p>
            <p><strong>ストーリー:</strong> 幼少期、恩師のドクター・ヒルルクの教えを胸に刻み、医者としての道を歩む。ルフィたちと出会い、仲間として共に冒険することを決意する。</p>
        </div>

        <div>
            <h2>ニコ・ロビン</h2>
            <p><strong>概要:</strong> 麦わらの一味の考古学者で、ハナハナの実の能力者。歴史の真実を解き明かすために旅をしている。</p>
            <p><strong>ストーリー:</strong> 幼少期にオハラの考古学者として育つも、世界政府に追われる身となる。ルフィたちと出会い、仲間として受け入れられたことで、自身の存在意義を見つける。</p>
        </div>

        <div>
            <h2>フランキー</h2>
            <p><strong>概要:</strong> 麦わらの一味の船大工で、サイボーグの体を持つ。自らの体を改造し、強力な武器を内蔵している。</p>
            <p><strong>ストーリー:</strong> 幼少期に海賊に捨てられた過去を持ち、トムの弟子として船大工の技術を学ぶ。エニエス・ロビーの戦いの後、ルフィたちと共に旅をすることを決意し、新たな船「サウザンド・サニー号」を建造した。</p>
        </div>

        <div>
            <h2>ブルック</h2>
            <p><strong>概要:</strong> 麦わらの一味の音楽家で、ヨミヨミの実の能力者。死後に復活したガイコツで、剣士としても戦闘に参加する。</p>
            <p><strong>ストーリー:</strong> 元はルンバー海賊団の音楽家だったが、クルーを失い、一人さまよっていた。スリラーバークでルフィたちと出会い、仲間に加わる。ラブーンとの再会を目指しながら旅を続けている。</p>
        </div>
    </div>
<p>
    <a href="https://one-piece.com/" target="_blank" rel="noopener noreferrer">
        ワンピース公式サイトはこちら
    </a>
</p>
</body>
</html>
''';

const String onePieceVolumes = '''
1巻: 1997年12月24日 - ROMANCE DAWN -冒険の夜明け-
2巻: 1998年4月9日 - その男、“海賊狩り”
3巻: 1998年8月9日 - 偽れぬもの
4巻: 1998年12月9日 - 三日月
5巻: 1999年5月1日 - 反逆者
6巻: 1999年8月4日 - 誰が為に鐘は鳴る
7巻: 1999年12月2日 - クソジジイ
8巻: 2000年4月4日 - 本性
9巻: 2000年7月4日 - 涙
10巻: 2000年12月1日 - OK, Let's STAND UP!
11巻: 2001年6月4日 - “東一番の悪”
12巻: 2001年12月4日 - 伝説は始まった
13巻: 2002年4月4日 - それぞれの冒険
14巻: 2002年11月1日 - 本物
15巻: 2002年12月4日 - 倒すべき敵
16巻: 2003年3月4日 - 受け継がれる夢
17巻: 2003年7月4日 - ヒートアップ
18巻: 2003年12月5日 - エース登場
19巻: 2004年4月30日 - 反乱
20巻: 2004年9月3日 - 決戦はアルバーナ
21巻: 2004年12月3日 - 理想郷
22巻: 2005年3月4日 - “偉大なる航路”
23巻: 2005年7月4日 - ビビの冒険
24巻: 2005年10月4日 - 人の夢
25巻: 2005年12月2日 - 脱出
26巻: 2006年4月4日 - 祭り屋
27巻: 2006年7月4日 - お前らァ
28巻: 2006年12月4日 - “海賊同盟”
29巻: 2007年4月4日 - オハラの悪魔
30巻: 2007年7月4日 - もう誰にも止められない
31巻: 2007年12月4日 - 我ここに至る
32巻: 2008年4月4日 - ウソップの花道
33巻: 2008年7月4日 - Davy Back Fight
34巻: 2008年12月4日 - 神の島の冒険
35巻: 2009年3月4日 - 9番目の正義
36巻: 2009年6月4日 - 第3の戦士
37巻: 2009年9月4日 - 未来国の冒険
38巻: 2009年12月4日 - 海賊旗
39巻: 2010年3月4日 - スリラーバーク
40巻: 2010年6月4日 - ギア
41巻: 2010年9月3日 - 宣戦布告
42巻: 2010年12月3日 - 海賊王と大剣豪
43巻: 2011年3月4日 - ルフィの夢
44巻: 2011年6月3日 - もう誰にも止められない
45巻: 2011年9月2日 - 目指せ！海賊王
46巻: 2011年12月2日 - 500の海賊
47巻: 2012年3月2日 - 8番目の仲間
48巻: 2012年6月4日 - 冒険の始まり
49巻: 2012年9月4日 - ナミの決意
50巻: 2012年12月4日 - 伝説の海賊
''';
