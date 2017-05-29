# FVLIW_verilog

## Building

Simply import the project in the Quartus Prime and build it. That should work.

## Major TO-DO's

- add more commands from the FVLIW standart
- add support for external instruction memory
- add more MMIO devices
- separate datapath and controller
- add actual VLIW support 

## Major problems

- Now we can display only one same digit for all 7-segment indicators
- Have only one single core

## "wkhs" (who-knows how to sole) problems

- avoid Quartus automatic optimization (reduces generated design by removing and simplifying unused modules/parts) (e.g. for simple 2-command program for showing a single digit on the 7-seg indicator the whole microcontroller is replaced by a single constant of the given digit).

## License

Copyright 2017 Sergey Dubovyk

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
