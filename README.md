# Magni

Magniは、強力なCLIツールをmrubyで構築するためのフレームワークです。

このプロジェクトは、CRubyの有名なCLIフレームワークであるThorにインスパイアされています。

## 特徴
- mruby上で動作する軽量なCLIフレームワーク
- コマンドやオプションの定義が簡単
- Thorライクな記法
- C言語のエントリーポイント(main関数)が含まれており、CLIに必要な定義が既に実装済み

## クイックスタート

### 1. コンパイラの準備
mrubyのビルドにはCコンパイラが必要です。詳細は[mruby公式ガイド](https://github.com/mruby/mruby/blob/master/doc/guides/compile.md)を参照してください。

### 2. プロジェクトディレクトリの作成
任意のディレクトリ名でプロジェクト用ディレクトリを作成します。
このディレクトリ名がデフォルトでビルド後の実行ファイル名になります。
例:
```sh
mkdir mycli
cd mycli
```

### 3. mrubyのソースコードを取得
以下のいずれかの方法でmrubyのソースコードを取得します。

#### (A) git cloneで取得
```sh
git clone https://github.com/mruby/mruby.git
```

#### (B) 公式サイトからダウンロード
[mruby公式ダウンロードページ](https://mruby.org/downloads/) からアーカイブをダウンロードし、展開してください。

### 4. build_config.rbの作成
プロジェクトルートに `build_config.rb` を作成し、Magniのgemを追加します。
例:
```ruby
MRuby::Build.new do |conf|
  conf.toolchain
  conf.gembox 'default'
  conf.gem 'magni', github: 'buty4649/magni', branch: 'main'
end
```

### 5. CLIスクリプト(cli.rb)の作成
例:
```ruby
class Cli < Magni
  package_name 'mycli'

  desc 'hello', 'say hello'
  def hello
    puts 'hello'
  end
end
```

### 6. ビルドとバイナリ生成
プロジェクトルートで以下を実行:
```sh

```
`./build/host/bin/mycli` というバイナリが生成されます（ディレクトリ名が `mycli` の場合）。
