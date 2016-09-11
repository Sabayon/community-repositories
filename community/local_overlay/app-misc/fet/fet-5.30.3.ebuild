# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils qt4-r2

DESCRIPTION="A timetabling software for educational institutions"
HOMEPAGE="http://lalescu.ro/liviu/fet/"
SRC_URI="http://lalescu.ro/liviu/fet/download/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RDEPEND="dev-qt/qtgui:4
	dev-qt/qtcore:4"
DEPEND="${RDEPEND}
	dev-util/desktop-file-utils"

src_install() {
	dobin fet
	doman doc/fet.1
	insinto /usr/share/${PN}/translations
	doins translations/*.qm
	dodoc AUTHORS ChangeLog CONTRIBUTORS README REFERENCES THANKS TODO TRANSLATORS
	insinto /usr/share/doc/${P}
	doins -r doc/*
	rm ${D}/usr/share/doc/${P}/fet.1
	if use examples; then
		doins -r examples
	fi
	make_desktop_entry ${PN} FET ${PN} Education
}
