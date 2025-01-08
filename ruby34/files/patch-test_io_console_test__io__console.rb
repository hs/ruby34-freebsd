--- test/io/console/test_io_console.rb.orig     2024-12-25 16:43:20.000000000 +0900
+++ test/io/console/test_io_console.rb
@@ -382,7 +382,6 @@
     # TestIO_Console#test_intr [/usr/home/chkbuild/chkbuild/tmp/build/20220304T163001Z/ruby/test/io/console/test_io_console.rb:387]:
     # <"25"> expected but was
     # <"-e:12:in `p': \e[1mexecution expired (\e[1;4mTimeout::Error\e[m\e[1m)\e[m">.
-    omit if /freebsd/ =~ RUBY_PLATFORM
 
     run_pty("#{<<~"begin;"}\n#{<<~'end;'}") do |r, w, _|
       begin;
