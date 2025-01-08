--- test/net/http/test_http.rb.orig	2024-12-25 16:43:20.000000000 +0900
+++ test/net/http/test_http.rb	2025-01-07 21:37:11.467883000 +0900
@@ -1285,6 +1285,8 @@
 
 class TestNetHTTPLocalBind < Test::Unit::TestCase
   CONFIG = {
+    # for FreeBSD
+    # check /etc/hosts and delete IPv6('::1 localhost ...') line
     'host' => 'localhost',
     'proxy_host' => nil,
     'proxy_port' => nil,
@@ -1322,6 +1324,8 @@
 
 class TestNetHTTPForceEncoding < Test::Unit::TestCase
   CONFIG = {
+    # for FreeBSD
+    # check /etc/hosts and delete IPv6('::1 localhost ...') line
     'host' => 'localhost',
     'proxy_host' => nil,
     'proxy_port' => nil,
