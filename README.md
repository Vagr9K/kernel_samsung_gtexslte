# Samsung Galaxy A6 7" (2016) Kernel (SM-T285)

NOTE: This project is based on [jedld's work](https://github.com/jedld/kernel_samsung_gtexslte), and was supposed to be the personal kernel I use, but might also interest other people. Commits are partially based on jedld's patches, but are refactored and squashed toghether to make updating base sources/making changes easier.

## Current differences from original repo

* CFQ as default IO scheduler
* Intercative as default CPU governor
* CPU hotplugging support via SPRD_CPU_DYNAMIC_HOTPLUG
* Modified build scripts for the kernel
* Different build string naming
* Some removed patches (zRAM, kmod checks, etc)

## Branches

* master (Where most changes are made.)
* stock  (Original stock kernel sources. Update commits are later cherry-picked into the master branch.)

## Battery life

* Standby (deep sleep, WiFi searching for networks, no SIM) -> 1% drained per 2.5 hours
* Youtube (NewPipe 720p60fps) -> 1% drained per 4-5 minutes