.PHONY: xpra-container-image
xpra-container-image:
	buildah build -f ./xpra/containerfile -t averbeck/xpra-base:latest ./xpra

.PHONY: jdownloader-container-image
jdownloader-container-image:
	buildah build -f ./jdownloader/containerfile -t averbeck/jdownloader-xpra:latest --build-arg REGISTRY=localhost ./jdownloader 
