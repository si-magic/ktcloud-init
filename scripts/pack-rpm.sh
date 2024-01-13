#!/bin/bash
set -e
NAME="ktcloud-init"
VER="$(cat VERSION)"
SPEC_FILE="$NAME-$VER.spec"
SRC_NAME="$NAME-$VER"
SRC_FILE="$SRC_NAME.tar.gz"

pushd "$(dirname "${BASH_SOURCE[0]}")/.."
SRC_DIR_NAME="$(basename "$PWD")"

rpmlint "specs/$SPEC_FILE"

pushd ..
tar \
	-cf "$HOME/rpmbuild/SOURCES/$SRC_FILE" \
	--transform "s/^$SRC_DIR_NAME/$SRC_NAME/" \
	--exclude-vcs \
	"$SRC_DIR_NAME"
popd
cp "specs/$SPEC_FILE" "$HOME/rpmbuild/SPECS"
rpmbuild -ba "$HOME/rpmbuild/SPECS/$SPEC_FILE"
