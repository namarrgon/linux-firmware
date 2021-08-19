#!/bin/sh
# SPDX-License-Identifier: GPL-2.0
#
# Copy firmware files based on WHENCE list
#

verbose=:
prune=no
compress=no
extension=""

while test $# -gt 0; do
    case $1 in
        -v | --verbose)
            verbose=echo
            shift
            ;;

        -P | --prune)
            prune=yes
            shift
            ;;
        -C | --compress)
            compress=yes
            extension=".xz"
            shift
            ;;

        *)
            if test "x$destdir" != "x"; then
                echo "ERROR: unknown command-line options: $@"
                exit 1
            fi

            destdir="$1"
            shift
            ;;
    esac
done

grep '^File:' WHENCE | sed -e's/^File: *//g' -e's/"//g' | while read f; do
    test -f "$f" || continue
    mkdir -p "$destdir/$(dirname "$f")"

    if test "$compress" == yes; then
        $verbose "compressing file $f"
        xz --check crc32 --stdout "$f" > "$destdir/$f$extension"
    else
        $verbose "copying file $f"
        cp -d "$f" "$destdir/$f"
    fi
done

grep -E '^Link:' WHENCE | sed -e's/^Link: *//g' -e's/-> //g' | while read f d; do

    if test -L "$f"; then
        $verbose "WARNING: link already exists: $f"
        
        target=$(readlink "$f")
        if test "$target" != "$d"; then
            $verbose "WARNING: inconsistent link target: $f/$target/$target"
        fi
    fi

    mkdir -p "$destdir/$(dirname "$f")"
    $verbose "creating link $f$extension -> $d$extension"
    ln -sf "$d$extension" "$destdir/$f$extension"

done

exit 0
# vim: et sw=4 sts=4 ts=4
