#!/bin/bash
##
#  Copyright (C) 2015, Samsung Electronics, Co., Ltd.
#  Written by System S/W Group, S/W Platform R&D Team,
#  Mobile Communication Division.
##

set -e -o pipefail

####################################################################################################
# You need to create build_config.local for toolchain and modpath selection!
# Example`
# ###################################################################################################
## build_config.local ###############################################################################
## export CROSS_COMPILE=/mnt/android-workspace/prebuilts/gcc/linux-x86/arm/arm-eabi-4.8/bin/arm-eabi-
## export ARCH=arm
## MODULE_PATH=/mnt/android-workspace/out/target/product/gtexslte/root/lib/modules
#####################################################################################################
if [ ! -f 'build_config.local' ]; then
	echo "No build_config.local found. Aborting."
	exit 1
fi

source 'build_config.local'

PLATFORM=sc8830
DEFCONFIG=gtexslte_defconfig
KERNEL_PATH=$(pwd)
EXTERNAL_MODULE_PATH=${KERNEL_PATH}/external_module

JOBS=`grep processor /proc/cpuinfo | wc -l`

function build_kernel() {
	make "$DEFCONFIG"
	make headers_install
    make -j$((${JOBS}+1))
	make modules
	make dtbs
	./scripts/mkdtimg.sh -i ${KERNEL_PATH}/arch/arm/boot/dts/ -o dt.img
	make -C ${EXTERNAL_MODULE_PATH}/wifi KDIR=${KERNEL_PATH}
	make -C ${EXTERNAL_MODULE_PATH}/mali MALI_PLATFORM=${PLATFORM} BUILD=release KDIR=${KERNEL_PATH}

	[ -d ${MODULE_PATH} ] && rm -rf ${MODULE_PATH}
	mkdir -p ${MODULE_PATH}

	find ${KERNEL_PATH}/drivers -name "*.ko" -exec cp -f {} ${MODULE_PATH} \;
	find ${EXTERNAL_MODULE_PATH} -name "*.ko" -exec cp -f {} ${MODULE_PATH} \;
}

function clean() {
	[ -d ${MODULE_PATH} ] && rm -rf ${MODULE_PATH}
	make distclean
}

function main() {
	[ "${1}" = "clean" ] && clean || build_kernel
}

main $@
