INPUT=$(shell find part* -iname "*.md")
all: pdf mobi
epub: $(INPUT) 
	pandoc -o chef-book.epub --toc --toc-depth=2 title.txt $^
mobi: epub
	kindlegen chef-book.epub
pdf: $(INPUT)
	pandoc -o chef-book.pdf --latex-engine=xelatex $^
clean:
	rm -f chef-book.{epub,mobi,pdf}

