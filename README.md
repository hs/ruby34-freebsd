ruby34-freebsd
==============

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

現状で、以下の点に配慮すれば、make test-all のテストは全てパスします。

* /etc/hosts に IPv6 のlocalhost設定('::1 localhost ...')行がある場合、コメントアウトないし削除する。
* パスの通った ruby コマンド(/usr/local/bin/ruby)でruby34が実行されるようにする(test/reline/test_reline.rb の 449行目に'ruby'というコマンドを実行するテストがある）

