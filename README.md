# floating-point-unit

VHDL implementation of multiplier and adder/substracter for IEEE floating point standard.

## Setup

You can install [GHDL](https://ghdl.readthedocs.io/en/latest/), [GTKWave](http://gtkwave.sourceforge.net/) and [VSG](https://github.com/jeremiah-c-leary/vhdl-style-guide) on your machine, or you can use the _Vagrantfile_ (you need [Vagrant](https://www.vagrantup.com/) installed) to run all this tools inside that _VM_.

## Float Multiplier

### Run

It runs the simulation using [GHDL](https://ghdl.readthedocs.io/en/latest/).

```bash
$ ./scripts/run-multiplier TEST_FILE
```

## Components

### Compile

```bash
$ ./scripts/compile COMPONENT_NAME
```

### Simulate

```bash
$ ./scripts/simul COMPONENT_NAME
```

### Run

It executes both _scripts_, compilation and simulation

```bash
$ ./scripts/run COMPONENT_NAME
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
