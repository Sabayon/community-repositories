# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Derived from bug 65084

EAPI=3
inherit eutils python games
[ "$PV" == "9999" ] && inherit subversion

ESVN_REPO_URI="https://vegastrike.svn.sourceforge.net/svnroot/vegastrike/trunk"
ESVN_PROJECT="vegastrike"

DESCRIPTION="A 3D space simulator that allows you to trade and bounty hunt"
HOMEPAGE="http://vegastrike.sourceforge.net/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

S="${WORKDIR}"

pkg_setup() {
	games_pkg_setup
}

src_unpack() {
	cd "${S}"
	local svn=${ESVN_TOP_DIR}

	if ([ ! -d "${svn}/data" ] && [ ! -d "${svn}/data" ]); then
		ESVN_MODULE="data"
		ESVN_MODULE_DIR="${ESVN_REPO_URI}/${ESVN_MODULE}"
		subversion_fetch $ESVN_MODULE_DIR $ESVN_MODULE || die "Fetching data failed"
	fi

	einfo "Copying data to work directory..."
	cp -a "${svn}"/{data} "${S}" >&/dev/null
}

src_prepare() {
	cd "${S}"/data
	# Clean up data dir
	esvn_clean "${S}"
	find "${S}" -name "*.pyc" -type f -exec rm -f '{}' \; >&/dev/null

	# Sort out directory references
	sed -i \
		-e "s!/usr/local/share/doc!/usr/share/doc!" \
		-e "s!/usr/local/share/vegastrike!${GAMES_DATADIR}/vegastrike!" \
		-e "s!/usr/local/bin!${GAMES_BINDIR}!" \
		-e "s!/usr/local/lib/man!/usr/share/man!" \
		"${S}/data/documentation/vegastrike.1" \
		|| die "sed data/documentation/vegastrike.1 failed"

	# Adding DATADIR to config
	sed -i \
		-e "s!<section name=\"data\">!<section name=\"data\"><var name=\"datadir\" value=\"${GAMES_DATADIR}/vegastrike/data\" />!" \
		"${S}/data/vegastrike.config" \
		|| die "sed data/vegastrike.config failed"

	# Intro Monologue
	sed -i \
		-e "s!\"documentation/IntroMonologue.txt!\"${GAMES_DATADIR}/vegastrike/data/documentation/IntroMonologue.txt!" \
		"${S}/data/bases/main_menu.py" \
		|| die "sed data/bases/main_menu.py failed"
}

src_compile() {
	einfo "Nothing to compile."
}

src_install() {
	doman "${S}"/data/documentation/*.1
	dodoc "${S}"/data/documentation/*.txt

	doicon  "${S}/data/vegastrike.xpm"

	insinto "$(games_get_libdir)"/vegastrike
	doins -r data/bases data/modules || die "doins py failed"

	insinto "${GAMES_DATADIR}"/vegastrike/data
	doins -r data/{ai,animations,cgi-accountserver,cockpits,communications,documentation,history,meshes,mission,movies,music,parts,programs,sectors,sounds,sprites,techniques,textures,units,universe} || die "doins data failed"
	doins data/{New_Game,Vega.icns,Version.txt,cursor1.cur,factions.xml,favicon.ico,setup.config,uninstall.ico,vega-license.txt,vega.ico,vegastrike.config,vegastrike.ico,vegastrike.xpm,vsinstall.sh,vslogo.xpm,weapon_list.xml} || die "doins data failed"

	dosym "$(games_get_libdir)"/vegastrike/bases "${GAMES_DATADIR}"/vegastrike/data/bases
	dosym "$(games_get_libdir)"/vegastrike/modules "${GAMES_DATADIR}"/vegastrike/data/modules

	prepgamesdirs
}

pkg_postinst() {
	python_mod_optimize "$(games_get_libdir)/vegastrike"
	games_pkg_postinst
}

pkg_postrm() {
	python_mod_cleanup "$(games_get_libdir)/vegastrike"
}
