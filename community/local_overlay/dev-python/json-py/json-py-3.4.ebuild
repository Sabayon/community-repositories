# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit distutils

MY_PV=${PV/./_}
MY_P=${PN}-${MY_PV}
S=${WORKDIR}

DESCRIPTION="JSON (JavaScript Object Notation) is a lightweight data-interchange format"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.zip"
HOMEPAGE="http://json.org/"
SLOT="0"

DEPEND=""
KEYWORDS="~amd64 ~x86"
LICENSE="LGPL"
IUSE=""


src_unpack() {
	unpack ${A}
	cp "${FILESDIR}/${P}-setup.py" "${WORKDIR}/setup.py"
}
