--- common.mk.orig	2024-12-25 16:43:20.000000000 +0900
+++ common.mk
@@ -962,7 +962,7 @@
 	$(ACTIONS_GROUP)
 	$(gnumake_recursive)$(Q)$(exec) $(RUNRUBY) -r$(tooldir)/lib/_tmpdir \
 	"$(TESTSDIR)/runner.rb" --ruby="$(RUNRUBY)" \
-	$(TEST_EXCLUDES) $(TESTOPTS) $(TESTS)
+	$(TEST_EXCLUDES) $(TESTOPTS) $(TESTS) --
 	$(ACTIONS_ENDGROUP)
 TESTS_BUILD = mkmf
 no-test-all: PHONY
