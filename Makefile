.PHONY: test lint
test:
	nvim --headless -c "PlenaryBustedDirectory tests/ {options}"

lint:
	luacheck lua/diagon
