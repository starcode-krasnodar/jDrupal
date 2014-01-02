# To run this makefile, you must have all the necessary tools installed.
#
# To install all the necessary tools, simply run the following...
#
#		 sudo make -B tools
#

# Create the list of files
lintfiles = src/drupal.js\
				src/comment.js\
				src/entity.js\
				src/node.js\
				src/taxonomy_term.js\
				src/taxonomy_vocabulary.js\
				src/user.js\
				src/services.js\
        src/services.comment.js\
				src/services.entity.js\
				src/services.node.js\
				src/services.system.js\
				src/services.taxonomy_term.js\
				src/services.taxonomy_vocabulary.js\
				src/services.user.js\

files =				 src/drupal.js\
				src/comment.js\
				src/entity.js\
				src/node.js\
				src/taxonomy_term.js\
				src/taxonomy_vocabulary.js\
				src/user.js\
				src/services.js\
        src/services.comment.js\
				src/services.entity.js\
				src/services.node.js\
				src/services.system.js\
				src/services.taxonomy_term.js\
				src/services.taxonomy_vocabulary.js\
				src/services.user.js\

.DEFAULT_GOAL := all

all: jslint js

# Perform a jsLint on all the files.
jslint: ${lintfiles}
				gjslint $^

# Create an aggregated js file and a compressed js file.
js: ${files}
				@echo "Generating aggregated bin/jdrupal.js file"
				@cat > bin/jdrupal.js $^
				@echo "Generating compressed bin/jdrupal.min.js file"
				curl -s \
					-d compilation_level=SIMPLE_OPTIMIZATIONS \
					-d output_format=text \
					-d output_info=compiled_code \
					--data-urlencode "js_code@bin/jdrupal.js" \
					http://closure-compiler.appspot.com/compile \
					> bin/jdrupal.min.js

# Create the documentation from source code.
jsdoc: ${files}
				@echo "Generating documetation."
				@java -jar tools/jsdoc-toolkit/jsrun.jar tools/jsdoc-toolkit/app/run.js -a -t=tools/jsdoc-toolkit/templates/jsdoc -d=doc $^

# Fix the js style on all the files.
fixjsstyle: ${files}
				fixjsstyle $^

# Install the necessary tools.
tools:
				apt-get install python-setuptools
				apt-get install unzip
				easy_install http://closure-linter.googlecode.com/files/closure_linter-latest.tar.gz
				wget http://jsdoc-toolkit.googlecode.com/files/jsdoc_toolkit-2.4.0.zip -P tools
				unzip tools/jsdoc_toolkit-2.4.0.zip -d tools
				mv tools/jsdoc_toolkit-2.4.0/jsdoc-toolkit tools/jsdoc-toolkit
				rm -rd tools/jsdoc_toolkit-2.4.0
				rm tools/jsdoc_toolkit-2.4.0.zip
