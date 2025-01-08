--- test/ruby/test_thread_queue.rb.orig 2024-12-25 16:43:20.000000000 +0900
+++ test/ruby/test_thread_queue.rb
@@ -213,7 +213,6 @@
   end
 
   def test_thr_kill
-    omit "[Bug #18613]" if /freebsd/ =~ RUBY_PLATFORM
 
     bug5343 = '[ruby-core:39634]'
     Dir.mktmpdir {|d|
