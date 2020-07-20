# floating-point-unit

VHDL implementation of multiplier and adder/substracter for IEEE floating point standard.

## Setup

You can install [GHDL](https://ghdl.readthedocs.io/en/latest/), [GTKWave](http://gtkwave.sourceforge.net/) and [VSG](https://github.com/jeremiah-c-leary/vhdl-style-guide) on your machine, or you can use the _Vagrantfile_ (you need [Vagrant](https://www.vagrantup.com/) installed) to run all this tools inside that _VM_.

## Components

### Run

```bash
$ ./scripts/tester.py OPERATION TEST_FILE [LINE]

	OPERATION: it could be `add`, `sub` or `mul`
	TEST_FILE: the file containing the inputs and expected outputs
	LINE: the line in test file to begin the simulation (available for add/sub, not mul)
		default: 0
```

## Subcomponents

### Run

It runs the simulation using [GHDL](https://ghdl.readthedocs.io/en/latest/).

```bash
$ ./scripts/run COMPONENT_NAME SUBCOMPONENT_NAME [TEST_FILE]
```

Where `COMPONENT_NAME` can be one of _multiplier_ or _adder_. Then the `SUBCOMPONENT_NAME` can be one of the sub-components that the previous ones use to work. 

### Compile

```bash
$ ./scripts/compile COMPONENT_NAME SUBCOMPONENT_NAME
```

### Simulate

```bash
$ ./scripts/simul SUBCOMPONENT_NAME
```

## Visualize

It runs [GTKWave](http://gtkwave.sourceforge.net/) to show the simulation.

```bash
$ make view COMPONENT=COMPONENT_NAME
```

## Linter

It runs [VSG](https://github.com/jeremiah-c-leary/vhdl-style-guide) _python_ module utility to force a style.

```bash
$ make lint
```

## Clean

To remove output generated files

```bash
$ make clean
```
