# nhk-netlingual
NHK 語学講座番組の番組を聞き逃し配信サービスからダウンロードします。

## 名前
nhk-netlingual.rb

## Description
NHK 語学講座番組は放送終了後も聞き逃し配信サービスで聞くことができますが、ファイルにダウンロードすることはできません。このソフトウェアは NHK 語学講座番組の聞き逃し配信サービスから番組音声データをダウンロードしてファイルに保存することができます。

聞き逃し配信サービスからダウンロードするので、ダウンロードできるのは前の週の放送分のみです。すべての放送回をダウンロードしたい場合、少なくとも毎週 1 回は実行する必要があります。

## 書式
```
$ nhk-netlingual.rb 番組パス
```
とすると、指定された番組の音声がカレント・ディレクトリに MP3 形式で保存されます。

### 指定可能な番組パス
2019年12月8日現在。番組改編により変更されることがあります。
```
    english/basic0      基礎英語0
    english/gakusyu     遠山顕の英会話楽習
    english/kaiwa       ラジオ英会話
    english/enjoy       エンジョイ・シンプル・イングリッシュ
    english/timetrial   英会話タイムトライアル
    english/gendai      高校生からはじめる「現代英語」
    english/business1   入門ビジネス英語
    english/business2   実践ビジネス英語
    english/basic1      基礎英語１
    english/basic2      基礎英語２
    english/basic3      基礎英語３
    hangeul/omotenashi  おもてなしのハングル
    chinese/kouza       まいにち中国語
    chinese/levelup     レベルアップ 中国語
    chinese/omotenashi  おもてなしの中国語
    hangeul/kouza       まいにちハングル講座
    hangeul/levelup     レベルアップ ハングル講座
    russian/kouza       まいにちロシア語（入門編）
    russian/kouza2      まいにちロシア語（応用編）
    italian/kouza       まいにちイタリア語（入門編）
    italian/kouza2      まいにちイタリア語（応用編）
    french/kouza        まいにちフランス語（入門編）
    french/kouza2       まいにちフランス語（応用編）
    german/kouza        まいにちドイツ語（入門編）
    german/kouza2       まいにちドイツ語（応用編）
    spanish/kouza       まいにちスペイン語（入門編）
    spanish/kouza2      まいにちスペイン語（応用編）
```

### 例
「ラジオ英会話」の各放送回をダウンロード
```
$ nhk-netlingua.rb english/kaiwa
```
「まいにち中国語」の各放送回をダウンロード
```
$ nhk-netlingua.rb chinese/kouza
```
使い方を表示
```
$ nhk-netlingua.rb
```

## 制限事項
NHK の聞き逃し配信サービスの仕様により、ダウンロードできるのはこのプログラムを実行した時点で聞き逃し配信サービスの対象となっている番組と放送回のみです（通常、前の週の放送分）。それより前の放送分は取得できません。すべての放送回をダウンロードしたい場合、少なくとも毎週 1 回は実行する必要があります。

## 注意事項
エラー処理は甘いです。必要に応じて追加してください。

## インストール
```
# make install
```
### Windows 版の場合
以下のファイルを同じディレクトリ（フォルダ）に保存します。

```
nhk-netlingual.exe
program-list.conf
cacert.pem
ffmpeg.exe
```

ディレクトリにパスを通しておくと便利です。

nhk-netlingual.exe の実行時に system という名前のディレクトリが自動的に作成されます。これは動作に必要なものです。ですから、nhk-netlingual.exe をコピーするディレクトリは書き込み許可のあるディレクトリにしてください。

## 他に必要なソフトウェア
rexml

入ってなかったら、
```
# gem install rexml
```
などとしてインストール。

ffmpeg https://www.ffmpeg.org/

## Windows 版でのビルド

### RubyInstaller+DevKit のインストール
RubyInstaller+DevKit for Windows https://rubyinstaller.org/

※ RubyInstaller+DevKit をインストールする時に、インストーラで MSYS2 and development toolchain にチェックを入れてください。その後に自動的に開くコマンドプロンプトで、

Which components shall be installed? If unsure press ENTER [1,2,3]

と出たら、

1 - MSYS2 base installation

を選択し Enter を押します。。次にまた同じ質問が表示されるので、

3 - MSYS2 and MINGW development toolchain

を選択します。

neri

neri は RubyInstaller のインストール後に次のようにしてインストールします。

```
> PATH=%PATH%;<RI-dir>\RubyInstaller\Ruby26-x64\bin;<RI-dir>\RubyInstaller\Ruby26-x64\msys64\mingw64\bin
> gem install neri
```

※ <RI-dir> は RubyInstaller をインストールしたディレクトリとします。

そして、

```
> make-win.bat
```

とします。

## ライセンス
The MIT License.

## Author
Shimaden <shimaden@shimaden.homelinux.net>
Twitter https://twitter.com/SHIMADEN (94380019)
