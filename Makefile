
.PHONY: xpra-container
xpra-container:
	cd ./xpra && docker build -t xpra-base:latest -f containerfile .

.PHONY: jdownloader-container
jdownloader-container:
	cd ./jdownloader && docker build -t jdownloader-xpra:latest -f containerfile .