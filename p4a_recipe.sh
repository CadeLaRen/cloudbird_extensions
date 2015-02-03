#!/bin/bash

# dependencies of this recipe
DEPS_cloudbird_extensions=(python)

# version
VERSION_cloudbird_extensions=${VERSION_cloudbird_extensions:-master}

# url of the package
URL_cloudbird_extensions=https://github.com/Davideddu/cloudbird_extensions/archive/$VERSION_cloudbird_extensions.zip

# md5 of the package
MD5_cloudbird_extensions=

# default build path
BUILD_cloudbird_extensions=$BUILD_PATH/cloudbird_extensions/$(get_directory $URL_cloudbird_extensions)

# default recipe path
RECIPE_cloudbird_extensions=$RECIPES_PATH/cloudbird_extensions

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_cloudbird_extensions() {
	true
}

# function called to build the source code
function build_cloudbird_extensions() {
    cd $BUILD_cloudbird_extensions

	push_arm

	export LDFLAGS="$LDFLAGS -L$LIBS_PATH"
	export LDSHARED="$LIBLINK"

	# fake try to be able to cythonize generated files
	$HOSTPYTHON setup.py build_ext
	try find . -iname '*.pyx' -exec $CYTHON {} \;
	try $HOSTPYTHON setup.py build_ext -v
	try find build/lib.* -name "*.o" -exec $STRIP {} \;
	try $HOSTPYTHON setup.py install -O2

	try rm -rf $BUILD_PATH/python-install/lib/python*/site-packages/cloudbird_extensions/tools

	unset LDSHARED
	pop_ar
}

# function called after all the compile have been done
function postbuild_cloudbird_extensions() {
	true
}
