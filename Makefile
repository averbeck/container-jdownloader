.PHONY: xpra-container-image
xpra-container-image:
	cd ./xpra && docker build -t averbeck/xpra-base:latest -f containerfile .

.PHONY: jdownloader-container-image
jdownloader-container-image:
	cd ./jdownloader && docker build -t averbeck/jdownloader-xpra:latest -f containerfile .
