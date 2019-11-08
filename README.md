# 6502-max

![GPLv3](https://img.shields.io/github/license/Sodaware/6502-max.svg)

`6502-max` is a simulator for the 6502 processor that is written in BlitzMax.


## Quick Links

Project Homepage:
: https://www.sodaware.net/6502-max/

Source Code
: https://github.com/sodaware/6502-max/


## Overview

This project isn't meant for serious work, but it may be useful if you're
attempting to build a 6502 simulator in another language.

There is currently no assembler included with the project.


## Important memory locations

  - Files are loaded into `$0600`
  - The stack is located at `$0100` to `$01FF`. There is no stack overflow
    protection.
  - The visual display is 32x32 pixels and 16 colours. It displays memory
    located at `$0200`
  - Address `$FF` contains the ASCII code for the previously pressed key.
  - Address `$FE` contains a random value between 0 and 255


## Usage

Calling `simulator --file=<binary file>` will load an assembled binary file into
RAM and execute it.

Pressing `ESC` during execution will halt the simulator. 

Press any key to exit once the program is finished to quit.


## Building

### Prerequisites

  - BlitzMax
  - Modules required (not including built-in brl.mod and pub.mod):
    - [sodaware.mod](https://github.com/sodaware/sodaware.mod)
      - sodaware.console\_color
      - sodaware.console\_commandline

### Compiling

To build the app in release mode, run the following from the command line:

```bash
bmk makeapp -h -r -o build/simulator src/main.bmx
```

This will create the `simulator` executable in the `build` directory.

Alternatively, use [blam](https://www.sodaware.net/blam/) to compile it by
calling `blam build:simulator`..


## Licence

Released under the GPLv3. See `COPYING` for the full licence.
