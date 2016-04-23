# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils

DESCRIPTION="Most feature-rich GUI for net-libs/tox using Qt5"
HOMEPAGE="https://github.com/tux3/qtox"
BUILD="570"

# Unfortunately qTox depends on ffmpeg, so our live version will be the static one.
SRC_URI="
	amd64? (
		https://build.tox.chat/view/Clients/job/qTox_build_linux_x86-64_release/${BUILD}/artifact/qTox_build_linux_x86-64_release.tar.xz
	)
"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"
DEPEND=""
RDEPEND=""
S="${WORKDIR}"
QA_PREBUILT="usr/bin/qtox"

src_install() {
	dobin qtox
	make_desktop_entry qtox qTox
}

