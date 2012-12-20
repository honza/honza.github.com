all:
	socrates -g _blog

force:
	rm .post-cache.json
	socrates -g _blog
