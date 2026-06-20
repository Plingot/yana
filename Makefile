default: clean yana

%:
	@$(MAKE) --no-print-directory -C src/ $@
