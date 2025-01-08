--- tool/mkconfig.rb.orig	2024-12-25 16:43:20.000000000 +0900
+++ tool/mkconfig.rb
@@ -170,8 +170,9 @@
   val.replace(newval) unless newval == val
   val
 end
-prefix = vars.expand(vars["prefix"] ||= +"")
-rubyarchdir = vars.expand(vars["rubyarchdir"] ||= +"")
+prefix = vars.expand(vars["rubyarchdir"])
+major, minor, *rest = RUBY_VERSION.split('.')
+rubyarchdir = "/lib/ruby/#{major}.#{minor}/#{arch}"
 relative_archdir = rubyarchdir.rindex(prefix, 0) ? rubyarchdir[prefix.size..-1] : rubyarchdir
 
 puts %[\
