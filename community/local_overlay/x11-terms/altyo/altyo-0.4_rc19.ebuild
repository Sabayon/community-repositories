# Lara Maia <dev@lara.click> 2014~2016
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit vala

DESCRIPTION="A drop-down terminal emulator, written in vala"
HOMEPAGE="https://github.com/linvinus/AltYo"
SRC_URI="https://github.com/linvinus/AltYo/archive/debian/${PV}-linvinus1.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
DOCS="AUTHORS README.md"

RDEPEND="x11-libs/vte:2.91[introspection,vala]
		 >=x11-libs/gtk+-3.4
		 >=dev-libs/glib-2.32"

DEPEND="${RDEPEND}
		$(vala_depend)"

S="${WORKDIR}/AltYo-debian-$PV-linvinus1"

src_prepare() {
	default
	vala_src_prepare
	sed "s|valac|valac-$(vala_best_api_version)|g" -i Makefile
}
