#Deplist

Deplist is a tiny shell script that can be used to find all non standard dependencies of a go package and report them grouped by their corresponding repository and installed version.

Currently only git repositories are supported.

### Usage

Print help text:
```
$ deplist.sh -h
usage: deplist [<flags>] <package>

Find all non standard dependencies of a go package and report them
grouped by their corresponding repository and installed version.

Currently only git repositories are supported.

Flags:
   -r      Show recursive dependencies as well
   -d      Show the exectuted commands (debug)
   -h      Show this help
```


Show only direct dependencies:
```
$ deplist.sh github.com/fgrosse/goldi
git@github.com:fgrosse/goldi.git: 0.9.0-48-gbf0e8d7
https://gopkg.in/alecthomas/kingpin.v2: v2.0.12
https://gopkg.in/yaml.v2: 7ad95dd
```

Show recursive dependencies:
```
$ deplist.sh -r github.com/fgrosse/goldi
git@github.com:fgrosse/goldi.git: 0.9.0-48-gbf0e8d7
https://github.com/alecthomas/template: b867cc6
https://github.com/alecthomas/units: 6b4e7dc
https://gopkg.in/alecthomas/kingpin.v2: v2.0.12
https://gopkg.in/yaml.v2: 7ad95dd
```
