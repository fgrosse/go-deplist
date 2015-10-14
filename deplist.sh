#/bin/bash

usage()
{
cat << EOF
usage: deplist [<flags>] <package>

Find all non standard dependencies of a go package and report them
grouped by their corresponding repository and installed version.

Currently only git repositories are supported.

Flags:
   -r      Show recursive dependencies as well
   -d      Show the exectuted commands (debug)
   -h      Show this help
EOF
exit 1
}

panic () {
    echo >&2 "$@"
    exit 1
}

LIST_TEMPLATE='{{.Imports}}'

while getopts "rdh" opt; do
  case $opt in
    r)
      LIST_TEMPLATE='{{.Deps}}'
      ;;
    d)
      set -x
      ;;
    h)
      usage
      ;;
    ?)
      usage
      ;;
  esac
done

shift $(($OPTIND - 1))
PKG=$1

# Some checks
[ -d "$GOPATH" ] || panic "GOPATH \"$GOPATH\" is not set or directory does not exist"
[ ! -z "$PKG" ] || panic "No package given. Please provide a go package as last argument"
[ -d "$GOPATH/src/$PKG" ] || panic "Package \"$GOPATH/src/$PKG\" is no directory"

# Do magic
go list -f $LIST_TEMPLATE $PKG/... \
  | tr -d "[]" \
  | xargs go list -f '{{if not .Standard}}{{.ImportPath}}{{end}}' \
  | xargs -I package bash -c "cd $GOPATH/src/package && git ls-remote --get-url | xargs echo -n && echo -n \": \" && git describe --tags --always" \
  | sort -t ' ' -k 1,1 -u
