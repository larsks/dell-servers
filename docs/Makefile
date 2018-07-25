SRC = $(wildcard *.md.in)
DOC = $(SRC:.md.in=.md)

# Replace #include and #exec statements in documents with corresponding
# content.
%.md: %.md.in
	@echo "$< -> $@"
	@awk -f include.awk $< > $@ || rm -f $@

all: $(DOC)

clean:
	rm -f $(DOC)
