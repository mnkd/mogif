# mogif
mogif — a command for creating a animated GIF with characters for macOS.

# Requirements
* mogif requires macOS 10.12 or greater.
* Xcode 9 + Swift 4

# Installation
To install the latest version of mogif, you can download [here](https://github.com/m-nakada/mogif/releases).

# Usage

```
Usage: mogif [options]
  -c, --characters:
      Characters for creating GIF image.
  -o, --output:
      Path to the output file.
  -f, --frameDelay:
      Frame Delay. 1 means 1 second, 0.5 means half a second. (Default: 1.0)
  -l, --loopCount:
      Loop Count. 0 means loop forever. (Default: 0)
  -h, --help:
      Prints a help message.
```

## Example

- `$ mogif -c ABC`
- `$ mogif -f 0.5 -c 🙎🙆`
- `$ mogif -f 0.8 -c 😴💤`
- `$ mogif -f 0.3 -c 🌕🌖🌗🌘🌑🌒🌓🌔`

# Build

```
$ swift build
```

# License
[MIT](https://github.com/m-nakada/mogif/blob/master/LICENSE)
