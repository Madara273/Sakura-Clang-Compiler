#!/usr/bin/env bash
#
# Copyright (C) 2026 Madara273 <ravenhoxs@gmail.com>. All rights reserved.
# SPDX-License-Identifier: GPL-3.0-or-later
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#

set -eou pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RESET='\033[0m'

install_arch() {
	echo -e "${GREEN}[+] Installing packages for Arch-like system: ${CYAN}${PRETTY_NAME:-$ID}${RESET}"
	sudo pacman -Syu --noconfirm
	sudo pacman -S --needed --noconfirm \
		base-devel \
		cmake \
		ninja \
		git \
		patchelf \
		pkgconf \
		libelf \
		bison \
		flex \
		openssl \
		ncurses \
		texinfo \
		bc \
		aarch64-linux-gnu-gcc \
		aarch64-linux-gnu-glibc \
		aarch64-linux-gnu-binutils
}

install_debian() {
	echo -e "${GREEN}[+] Installing packages for Debian-like system: ${CYAN}${PRETTY_NAME:-$ID}${RESET}"
	sudo apt update
	sudo apt install -y \
		build-essential \
		cmake \
		ninja-build \
		git \
		patchelf \
		pkg-config \
		libelf-dev \
		bison \
		flex \
		libssl-dev \
		libncurses5-dev \
		texinfo \
		bc \
		libunwind-dev \
		libc++-dev \
		libc++abi-dev
	sudo dpkg --add-architecture arm64
	sudo apt update
	sudo apt install -y \
		gcc-aarch64-linux-gnu \
		g++-aarch64-linux-gnu \
		libc6-dev-arm64-cross \
		libstdc++-13-dev-arm64-cross \
		zlib1g-dev:arm64 \
		libelf-dev:arm64 \
		libssl-dev:arm64
}

source /etc/os-release

echo -e "${YELLOW}[i] Detected OS: ${CYAN}${PRETTY_NAME:-$ID}${RESET}"

case "${ID:-}" in
	arch|manjaro|endeavouros)
		install_arch
		;;
	debian|ubuntu|pop|kali)
		install_debian
		;;
	*)
		echo -e "${RED}[!] Unsupported OS: ${CYAN}${PRETTY_NAME:-${ID:-Unknown}}${RESET}"
		exit 1
		;;
esac
