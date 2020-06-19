# floating-point-unit

VHDL implementation of multiplier and adder/substracter for IEEE floating point standard.

## Setup

You can install [GHDL](https://ghdl.readthedocs.io/en/latest/), [GTKWave](http://gtkwave.sourceforge.net/) and [VSG](https://github.com/jeremiah-c-leary/vhdl-style-guide) on your machine, or you can use the _Vagrantfile_ (you need [Vagrant](https://www.vagrantup.com/) installed) to run all this tools inside that _VM_.

## Compile

```bash
$ make COMPONENT=[]
```

## Simulate

It runs the simulation using [GHDL](https://ghdl.readthedocs.io/en/latest/).

```bash
$ make sim STOPTIME=time COMPONENT=[]
```

`time` defaults to _500 ns_

## Visualize

It runs [GTKWave](http://gtkwave.sourceforge.net/) to show the simulation.

```bash
$ make view COMPONENT=[]
```

## Linter

It runs [VSG](https://github.com/jeremiah-c-leary/vhdl-style-guide) _python_ module utility to force a style.

```bash
$ make lint
```
