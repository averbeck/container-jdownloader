SRC_XPRA = $(shell find ./xpra -type f)
SRC_JDOWNLOADER = $(shell find ./jdownloader -type f)

.DEFAULT_GOAL := .build/jdownloader-image.marker

.build/xpra-image.marker: $(SRC_XPRA)
	mkdir -p .build
	buildah build -f ./xpra/containerfile -t averbeck/xpra-base:latest ./xpra
	touch $(@)

.PHONY: xpra-container-image
xpra-container-image: .build/xpra-image.marker

.build/jdownloader-image.marker: .build/xpra-image.marker $(SRC_JDOWNLOADER)
	buildah build -f ./jdownloader/containerfile -t averbeck/jdownloader-xpra:latest --build-arg REGISTRY=localhost ./jdownloader 
	touch $(@)

.PHONY: jdownloader-container-image
jdownloader-container-image: .build/jdownloader-image.marker

