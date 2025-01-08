--- test/ruby/test_thread.rb.orig       2024-12-25 16:43:20.000000000 +0900
+++ test/ruby/test_thread.rb
@@ -1498,10 +1498,6 @@
       # opt = {new_pgroup: true}
     end
 
-    if /freebsd/ =~ RUBY_PLATFORM
-      omit "[Bug #18613]"
-    end
-
     assert_separately([], "#{<<~"{#"}\n#{<<~'};'}", timeout: 120)
     {#
       n = 1000
