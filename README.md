# mogif
mogif — a command for creating a animated GIF with characters for OS X.

# Requirements
mogif requires OS X 10.11 or greater.

# Installation
To install the latest version of mogif, you can download [here](https://github.com/m-nakada/mogif/files/249881/mogif.zip).

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
- `$ mogif -c ありがとう -f 0.5`
- `$ mogif -c 😴💤`

# Build

1. `$ git submodule init`
2. `$ git submodile update`
3. Open `mogif.xcodeproj`
4. Build (command + B)
