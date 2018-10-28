# bbsl

[![Travis (.org)](https://img.shields.io/travis/nishtahir/bbsl.svg?style=flat-square)](https://travis-ci.org/nishtahir/bbsl/)



`bbsl` is an opinionated anti-bikeshedding linter for the BrightScript Programming Language. 

# Philosophy
Unlike `wist` which aims for full compliance with the Brightscript language specification, `bbsl` aims for speed and consistency over . While this means that `bbsl` will report valid Brightscript that does not conform to its ruleset as invalid, this does not make it incorrect; it makes it heavily opinionated on how you should write your code.

Conforming to `bbsl` rules will ensure that your codebase is readable and consistent.

# Standard rules

* Commas (`,`) must always delimit array and associative array elements.

* `?` cannot be used in place of `print`

* Keywords must conform to all lower case. `function` as opposed to `Function`

* Code indentation should be done with 4 spaces

# Usage

```
$ bbsl [OPTION...] <source files>

  -v, --verbose      Show verbose output
  -h, --help         Print help
      --print-tree   Print parse tree
      --no-lint      Disable error reporting
      --sources arg  Source files
```

To lint your project, you need to invoke `bbsl` on your source files. 

```
$ bbsl my/path/MyFile.brs my/path/MySecondFile.brs
```

`bbsl` also supports the glob file pattern for passing in multiple sources

```
$ bbsl my/path/*.brs
```

You can get verbose output using the `-v` flag. This will log the files that it finds 
before it begins linting

```
$ bbsl -v my/path/*.brs
my/path/MyFile.brs 
my/path/MySecondFile.brs
```

# Building

In order to build the project you need the following installed

* OpenJDK 8
* CMake 3.5 or higher
* Clang

A `Vagrantfile` has been provided with a properly configured linux environment as an alternative.

To build the project, you simply need to invoke the `make` command in the root directory. You may optionally use the `-j` flag to parallelize the build.

```
$ make -j5
```

# FAQ

* **Why should I use `bbsl`?**

Simplicity, safety and reliablity. You can rest easy knowing that the code you upload to your device will be free of syntactic issues. 

* **What does bbsl stand for?**

Better Brightscript linter.


# License

```
   Copyright 2018 Nish Tahir Inc.

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.

```

