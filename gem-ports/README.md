ruby34-freebsd/gem-ports
====================

Ruby 3.4 のソースコードに含まれているgemでFreeBSDにportsが無いもの。

使い方
----------

1. /usr/ports/ 以下にportsをコピーします
   ```
   # tar cf - devel textproc | tar xfC - /usr/ports/
   ```
2. gem のソースを/usr/ports/distfiles/rubygem にコピーします
   ```
   # mkdir -p /usr/ports/distfiles/rubygem
   # gem fetch yaml -v '=0.4.0'
   Fetching yaml-0.4.0.gem
   Downloaded yaml-0.4.0
   # gem fetch repl_type_completor -v '=0.1.9'
   Fetching repl_type_completor-0.1.9.gem
   Downloaded repl_type_completor-0.1.9
   ```
3. ビルド・インストールします
   ```
   # cd /usr/ports/devel/rubygem/rubygem-repl_type_completor
   # make && make install && make clean
   # cd /usr/ports/textproc/rubygem-yaml
   # make && make install && make clean
   ```

補足: gem のports化手順
-----------------------

1. /usr/ports の下のディレクトリ一覧から、ports化するgemのカテゴリを決めてディレクトリを作成します
   portsの命名規則としては'rubygem-'というprefixの後ろにgemの名前を付ける、という形式が標準的なようです。
   ```
   # cd /usr/ports/
   # mkdir textproc/rubygem-yaml
   ```

2. Makefile を作成します
   ```
   PORTNAME=	yaml
   PORTVERSION=	0.4.0
   CATEGORIES=	textproc rubygems
   MASTER_SITES=	RG

   MAINTAINER=	hs@on-sky.net
   COMMENT=	YAML Ain't Markup Language
   WWW=		https://github.com/ruby/yaml

   LICENSE=	BSD2CLAUSE RUBY
   LICENSE_COMB=	dual
   LICENSE_FILE_BSD2CLAUSE=	${WRKSRC}/BSDL
   LICENSE_FILE_RUBY=		${WRKSRC}/COPYING

   USES=		gem

   NO_ARCH=	yes

   .include <bsd.port.mk>
   ```

   * PORTNAME はgemの名前を書きます('rubygem-'というプレフィックスは付けません)
   * PORTVERSION はgemのバージョンを書きます
   * CATEGORIES は手順1.で決めたカテゴリと'rubygems'
   * MASTER_SITES には通常配布元のURLが入ります('RG'が何を意味するのかは不明)
   * MAINTAINER にはportsの管理者(自分)のメールアドレス
   * COMMENT には1行説明を書きます。上の例では https://rubygems.org/ で表示される説明をコピーしています。
   * WWW にはgemの開発元のURLを書きます
   * LICENSE* にはgemのライセンスを調べて記載します（他のgemのライセンスと対応するportsのMakefileを見比べて真似しています）
   * USES= gem という行を書けば、gemコマンドを使ってPORTNAME/PORTVERSIONのgemがインストールされます
   * NO_ARCH= yes はこのportsがアーキテクチャに依存していない、という意味になります
   * 上の例にはありませんが、他のgemに依存している場合、'RUN_DEPENDS= ...' という記述が使えます

3. gemをダウンロードしてdistinfoファイルを作成します
   ```
   # gem fetch yaml
   # mv yaml-0.4.0.gem /usr/ports/distfiles/rubygem/
   # make makesum
   ```

4. pkg-descr を作ります。gemのREADME等に記載されている説明をコピーしています。

