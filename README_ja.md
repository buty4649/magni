[EN](./README.md) | JA

---

# Magni

Magniは、mrubyでCLIツールを開発するためのフレームワークです。mrubyでCLIツールを構築するために必要なファイルを同梱しており、最低限の設定でCLIツールをビルドすることができます。また、CRubyの著名なCLIフレームワークである[Thor](https://github.com/rails/thor)と類似したAPIを提供しているため、同ツールの利用経験があれば効率的に開発を進めることができます。

## 特徴
- mruby上で動作する軽量なCLIフレームワーク
- [Thor](https://github.com/rails/thor)ライクなAPI
- CLIツールのビルドに必要なコードを同梱

## クイックスタート

### 1. コンパイラの準備
mrubyのビルドにはCコンパイラが必要です。詳細は[mruby公式ガイド](https://github.com/mruby/mruby/blob/master/doc/guides/compile.md)を参照してください。

### 2. プロジェクトディレクトリの作成
任意のディレクトリ名でプロジェクト用ディレクトリを作成してください。
このディレクトリ名がデフォルトでビルド後の実行ファイル名となります。

```sh
mkdir mycli
cd mycli
```

### 3. mrubyのソースコードを取得
以下のいずれかの方法でmrubyのソースコードを取得してください。

#### (A) git cloneで取得
```sh
git clone https://github.com/mruby/mruby.git

# または git submodule (推奨)
git submodule add https://github.com/mruby/mruby.git
```

#### (B) 公式サイトからダウンロード
[mruby公式ダウンロードページ](https://mruby.org/downloads/) からアーカイブをダウンロードし、展開してください。

### 4. build\_config.rbの作成
プロジェクトルートに `build_config.rb` を作成し、Magniのgemを追加してください。

```ruby
# build_config.rb
MRuby::Build.new do |conf|
  conf.toolchain
  conf.gembox 'default'
  conf.gem github: 'buty4649/magni', branch: 'main'
  conf.build_dir File.join(__dir__, 'build')
end
```

### 5. スクリプトの作成
スクリプトを作成してください。名前は任意ですが、ここでは例として*cli.rb*としています。
スクリプトには必ずMagniクラスを継承したクラスを1つ定義する必要があります(ここではCliクラスとしています)。

```ruby
# cli.rb
class Cli < Magni
  package_name 'mycli'

  desc 'hello', 'say hello'
  def hello
    puts 'hello'
  end
end
```

### 6. ビルドとバイナリ生成
プロジェクトルートで以下を実行してください。
```sh
rake -f mruby/Rakefile
```

`./build/bin/mycli` というバイナリが生成されます(ディレクトリ名が `mycli` の場合)。

```sh
$ ./build/bin/mycli
Usage:
  mycli [command]

Commands:
  hello      say hello
  help       show this message

Options:
  -h, --help                        show this message and exit
```

## Tips

### バイナリのファイル名を変更する
以下のようにmagniを読み込む際に**bins**を指定することで、出力するバイナリファイル名を変更することができます。以下の例では、*awesome-cli-tool*に変更しています。

```ruby
MRuby::Build.new do |conf|
-- snip --
  conf.gem github: 'buty4649/magni', branch: 'main' do |g|
    g.bins = %w[awesome-cli-tool]
  end

-- snip --
end
```

### スクリプトを分割したい / 複数のファイルを読み込みたい

mrubyでは標準では `require` / `require_relative` を使用できません。しかし、ビルド時にすべてのスクリプトファイルを読み込んでビルドを実行します。ビルド対象となるファイルは以下の通りです。

* `./*.rb`
* `./app/**/*.rb`
* `./lib/**/*.rb`
* `./mrblib/**/*.rb`

> [!TIP]
> これらのパスは`build_config.rb`があるディレクトリを基準とした相対パスです。

## LICENSE

詳細は[LICENSE](LICENSE)ファイルを参照してください。
