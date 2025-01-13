ruby34-freebsd
==============

変更履歴
---------------

* [2025/01/10] yaml, repl_type_completor のportsを作成
* [2025/01/13] make check が正常に完了するようになりました！

----------

FreeBSD に Ruby 3.4 をインストールするためのportsのテストコードです。

使い方
----------

1. /usr/ports/Mk/Uses/ruby.mk にパッチを当てます。
   ```
   # cd /usr/ports
   # patch < /path/to/ruby34-freebsd/Mk_Uses_ruby.mk.patch
   ```
2. (オプション)Ruby3.4 をデフォルトのRubyにする場合、/etc/make.conf に以下の行を追加します。
   ```
   # vim /etc/make.conf
   -----
   DEFAULT_VERSIONS+=ruby=3.4
   -----
   ```
3. ruby34 ディレクトリを/usr/ports/lang の下にコピーします
   ```
   # cp -r /path/to/ruby34-freebsd/ruby34 /usr/ports/lang
   ```
4. ビルド・インストールします
   ```
   # cd /usr/ports/lang/ruby34
   # make && make install
   ```
5. 手順2.でデフォルトRuby指定してインストールした場合、依存しているportsもインストールでき（ると思い）ます。
   ```
   # cd /usr/ports/devel/ruby-gems
   # make && make install
   ```

説明
----------

デフォルトの'pkg-message', 'pkg-plist'ファイルは'pkg-message.full', 'pkg-plist.full'になっており、この組み合わせではRubyのソースに含まれる default gem や bundled gem をインストールするようになっています。

'pkg-message.minimum'と'pkg-plist.minimum'は同梱gemをインストールしない、これまでのFreeBSDのRuby portsの流儀に沿った設定ファイルで、以下の手順でビルドします。
```
# cd /usr/ports/lang/ruby34
# cp patch-tool_rbinstall.rb files/
# cp pkg-message.minimum pkg-message
# cp pkg-plist.minimum pkg-plist
# make && make install
```
こちらの手順でインストールした場合、pkg-message.minimum に記載されているgemを個別にインストールする必要があります（未確認）。

補足
----------

* files/patch-test_io_console_test__io__console.rb
* files/patch-test_ruby_test__thread__queue.rb
* files/patch-test_ruby_test__thread.rb 

の3つのファイルはRubyの[Bug #18613](https://bugs.ruby-lang.org/issues/18613)が直っているかどうかを確認するためのパッチです。

これらの不具合はOS側の問題だったようで、13.3-RELEASEで修正されたようです（直接的ではないですが、[参考](https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=277429) のバグレポートで[Bug #18613]と同様な現象の報告と、13.3-RELEASEで修正された（再発しなかったのでクローズ）との回答あり）。
手元の環境で、このパッチを当てテストを有効化した状態で "make test-all" を数十回走らせてみましたが、ランダムに止まるという状況は再発しませんでした。

* files/patch-common.mk 

は、make test-all がエラーで止まる問題の修正です。FreeBSDで'make -n test-all'で実行される処理を確認すると、最後の3行は
```
: 
exec ./miniruby -I./lib -I. -I.ext/common  ./tool/runruby.rb --extout=.ext  -- --disable-gems -r./tool/lib/_tmpdir "./test/runner.rb" --ruby="./miniruby -I./lib -I. -I.ext/common  ./tool/runruby.rb --extout=.ext  -- --disable-gems" --excludes-dir=./test/.excludes --name=!/memory_leak/  
:
```
となり一見問題なさそうですが、exec行の末尾に2個のスペース文字があるためにエラーで失敗するようでした。<br>
回避策としては、パッチのように行の最後に'--'というダミーオプションを追加するか、common.mkの317行目にある
```
TEST_EXCLUDES = --excludes-dir=$(TESTSDIR)/.excludes --name=!/memory_leak/
```
の--nameオプションを、
```
TEST_EXCLUDES = --excludes-dir=$(TESTSDIR)/.excludes --name="!/memory_leak/"
```
のようにダブルクォートで囲むと回避できるようでした。


現状で、以下の点に配慮すれば、make checkが最後まで正常に完了します(make-check-result_20250113.txt)。

* /etc/hosts に IPv6 のlocalhost設定('::1 localhost ...')行がある場合、コメントアウトないし削除する。
* パスなしの'ruby'コマンドの実体が3.4のバイナリになるようにする。<br>
FreeBSDの場合、/etc/make.confでRubyのデフォルトバージョンを3.4にするか、ソースにpatch-ruby34-testを当てて以下の2ファイルを修正します。<br>
  * test/reline/test_reline.rb の449行目
  * bin/gem のshebang(1行目)

