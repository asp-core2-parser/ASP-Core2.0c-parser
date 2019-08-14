# ASP-Core2.0c-parser
## What is it?
This parsers are 1:1 to the [ASP Core 2.0c standard](https://www.mat.unical.it/aspcomp2013/files/ASP-CORE-2.03c.pdf) ("the standard" from now).

## Why?

We saw that other parsers from the most used Answer Set Programming solvers like [clingo](https://potassco.org/), [DLV](http://www.dlvsystem.com/dlv/) and [DLV2](https://www.mat.unical.it/DLV2/) even though they recognize a super-set of the grammar they aren't 1:1 with the standard.

## How?

We decided to make 2 different parsers:

- An LALR(1) parser made with [Flex](https://github.com/westes/flex) for the lexical analysis and [Bison](https://www.gnu.org/software/bison/) for the parser generation.
- An ALL(k) parser generated with [ANTLR v4](https://www.antlr.org/).
