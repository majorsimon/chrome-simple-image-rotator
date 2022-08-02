.PHONY: clean build publish upload

clean:
	if test -d dist; then rm -rf dist; fi 	

build: clean
	mkdir dist
	( \
		cd src && \
		zip -r ../dist/simple-image-rotator.zip \
		manifest.json \
		content.js \
		main.js \
	)

publish: 
	bash scripts/publish.sh

upload: 
	bash scripts/upload.sh

