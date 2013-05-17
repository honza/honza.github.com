all:
	rm .post-cache.json
	socrates -g _blog

force:
	rm .post-cache.json
	socrates -g _blog

resume:
	pandoc -sS --variable=fontsize:12pt -o resume.tex _blog/pages/resume.rst
	xelatex resume.tex
