# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit eutils

DESCRIPTION="Genymotion is a fast and easy-to-use Android emulator to run and test your Android apps"
HOMEPAGE="https://www.genymotion.com"

SRC_URI="
	amd64? (
		http://files2.genymotion.com/${PN}/${P}/${P}-linux_x64.bin
	)
	x86? (
		http://files2.genymotion.com/${PN}/${P}/${P}-linux_x86.bin
	)
"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"
DEPEND=""
RDEPEND="${DEPEND} virtual/opengl media-libs/libpng || ( >=app-emulation/virtualbox-4.1.1 >=app-emulation/virtualbox-bin-4.1.1 )"

S=${DISTDIR}

src_install() {
	mkdir "${D}/opt"

	if use amd64; then
		yes | bash ${P}-linux_x64.bin -d "${D}/opt"
	elif use x86; then
		yes | bash ${P}-linux_x86.bin -d "${D}/opt"
	fi

	mkdir -p "${D}/usr/bin"
	ln -s "/opt/genymotion/genymotion" "${D}/usr/bin" 
	ln -s "/opt/genymotion/genymotion-shell" "${D}/usr/bin" 
	ln -s "/opt/genymotion/player" "${D}/usr/bin/genymotion-player"
	ln -s "/opt/genymotion/gmtool" "${D}/usr/bin"
	make_desktop_entry genymotion "Genymotion" "/opt/genymotion/icons/icon.png" "System;Emulator"
}

