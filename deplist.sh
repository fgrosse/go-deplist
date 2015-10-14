#/bin/bash

panic () {
    echo >&2 "$@"
    exit 1
}

# Check arguments
[ "$#" -eq 1 ] || panic "1 argument required, $# provided"
[ -d "$GOPATH" ] || panic "GOPATH \"$GOPATH\" is not set or directory does not exist"

# Do magic
go list -f '{{.Deps}}' $1/... \
  | tr -d "[]" \
  | xargs go list -f '{{if not .Standard}}{{.ImportPath}}{{end}}' \
  | xargs -I package bash -c "cd $GOPATH/src/package && git ls-remote --get-url | xargs echo -n && echo -n \": \" && git describe --tags --always" \
  | sort -t ' ' -k 1,1 -u
