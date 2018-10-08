# bbsl

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

# FAQ

* **Why should I use `bbsl`?**

Simplicity, safety and reliablity. You can rest easy knowing that the code you upload to your device will be free of syntactic issues. 

* **What does bbsl stand for?**

Better Brightscript linter.

# Development

## Requirements

* OpenJDK 8
* CMake 3.5 or higher
* Clang

To build the project, you simply need to invoke the `make` command in the root directory. You may optionally use the `-j` flag to parallelize the build.

```
$ make -j5
```

