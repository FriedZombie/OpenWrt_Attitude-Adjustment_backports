#!/usr/bin/env bash
export LANG=C
export LC_ALL=C
[ -n "$TOPDIR" ] && cd $TOPDIR

try_backport() {
        [ -f backport ] || return 1
        BPRT="$(cat backport)"
        [ -n "$BPRT" ]
}

try_git() {
	BPRT="$(git describe --tags --exact-match HEAD 2> /dev/null)"
	if [ -z "${BPRT}" ]; then
		for i in `git log --pretty=format:'%H'`; do
			BPRT="$(git describe --tags --exact-match $i 2> /dev/null)"
			if [ -n "$BPRT" ]; then
				BPRT="$BPRT+$(git log --pretty=format:'%h' -n 1)"
				break
			fi
		done
		[ -z "$BPRT" ] && BPRT="$(git log --pretty=format:'%h' -n 1)"
	fi
	[ -z "${BPRT}" ] && return 1
	[ -n "$(git diff --name-only)" ] && BPRT="$BPRT+"
	return 0
}


try_backport || try_git || BPRT="unknown"
echo "$BPRT"
