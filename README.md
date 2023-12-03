# algofoogle-multi-caravel

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

This is Anton's repo for individually hardening several projects that will target a single GFMPW-1 submission (GF180 Open PDK).

For more info, see: [0181 &sect; 'What I did'](https://github.com/algofoogle/journal/blob/master/0181-2023-12-02.md#what-i-did).

**NOTE:** Whichever `gf180-*` branch you're on reflects which project you're in, specifically, and all should be branching from [`gf180-base`](https://github.com/algofoogle/algofoogle-multi-caravel/tree/gf180-base) (which should hopefully be the default).

The idea is that if general updates are required to `gf180-base`, they should be easy enough to merge to each of the project branches, to keep everything consistent.

## Hardening

Say you want to harden one of the `gf180-*` project branches... let's use `gf180-rbz-fsm` as an example. Here's a very high-level overview, assuming you already have at least *something* of a working OpenLane environment (or at least the prerequisites installed; see [the original efabless guide](https://github.com/efabless/caravel_user_project/blob/gfmpw-1c/docs/source/index.rst) for more info, but note that the PDK version in that doco might be outdated):

> NOTE: Zero to ASIC VM also redirects certain other things (`MGMT_AREA_ROOT`, `DESIGNS`, `CARAVEL_ROOT`, etc. to subdirectories of `~/asic_tools/caravel_user_project`). Check your `~/.bashrc` for details. I've been trying to make this a bit more flexible (see [Tip 2312A](https://github.com/algofoogle/journal/blob/master/tips/2312A.md) point 5) but note that I've not completed this work yet.

1.  Switch to the branch and set it up for the first time:
    ```bash
    git checkout gf180-rbz-fsm
    mkdir -p dependencies
    # Changing OPENLANE_ROOT & PDK_ROOT optional if using Zero to ASIC VM:
      export OPENLANE_ROOT=$(pwd)/dependencies/openlane_src
      export PDK_ROOT=$(pwd)/dependencies/pdks
    # Required:
    export PDK=gf180mcuD
    # This will download and install caravel, the PDK, required OpenLane version, etc.
    make setup
    ```
2.  Each time you want to harden:
    ```bash
    # Optional, as above:
      export OPENLANE_ROOT=$(pwd)/dependencies/openlane_src
      export PDK_ROOT=$(pwd)/dependencies/pdks
    # Required:
    export PDK=gf180mcuD

    # MAIN HARDENING STEP:
    make top_ew_algofoogle
    ```

## Finalisation

**NOTE:** It is expected that each *individual* hardened project branch will be copied into one consolidated caravel_user_project when it is considered stable.

You should find that the information above does not deviate per branch, but the information below intentionally does.


# Specific project for branch `gf180-rbz-fsm`: raybox-zero FSM version

You are on the branch `gf180-rbz-fsm`.

**This design implements a simple hardware ray caster**

It instantiates a version of [raybox-zero] that uses and extra reciprocal module FSM to try and get better timing for GF180. According to OpenLane, the macro hardens successfully with a target of 22.72MHz (44ns period), which is slow for VGA but still good enough for my monitor to sync.

**NOTE:** At the time of writing, the top macro name is `top_ew_algofoogle` but I plan on changing this to probably just `raybox_zero_fsm`.

[raybox-zero]: https://github.com/algofoogle/raybox-zero/tree/gf180
