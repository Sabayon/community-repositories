# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_P=lib${P}

DESCRIPTION="Free Finnish spellchecking and hyphenation library"
HOMEPAGE="http://voikko.sf.net"
SRC_URI="http://www.puimula.org/voikko-sources/libvoikko/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-misc/malaga
	>=dev-libs/suomi-malaga-1.4
	virtual/libiconv"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_compile() {
	econf CXXFLAGS=-Wno-error || die "econf failed"
	emake || die "emake failed"
}


src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc README || die "docs missing"
}
