# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Derived from bug 65084

EAPI=2

inherit cmake-utils flag-o-matic eutils games
[ "$PV" == "9999" ] && inherit subversion

ESVN_REPO_URI="https://vegastrike.svn.sourceforge.net/svnroot/vegastrike/trunk"
ESVN_PROJECT="vegastrike"
#ESVN_BOOTSTRAP="vegastrike/bootstrap-sh"
ESVN_BOOTSTRAP="echo 'skipping bootstrap'"

DESCRIPTION="A 3D space simulator that allows you to trade and bounty hunt"
HOMEPAGE="http://vegastrike.sourceforge.net/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="+boost +ffmpeg +gtk threads mesher server debug"

# FIXME: check dependencies
RDEPEND="
	virtual/opengl
	virtual/jpeg
	media-libs/libpng
	boost? ( dev-libs/boost[python] )
	dev-libs/expat
	media-libs/openal
	media-libs/libsdl
	media-libs/libvorbis
	media-libs/libogg
	media-libs/sdl-mixer
	ffmpeg? ( media-video/ffmpeg )
	media-libs/freeglut
	virtual/glu
	gtk? ( x11-libs/gtk+ )
	games-simulation/vegastrike-data"
#	dev-games/ogre
DEPEND="${RDEPEND}
	>=sys-devel/autoconf-2.58"

S="${WORKDIR}"

CMAKE_USE_DIR="${S}/${PN}"
#CMAKE_VERBOSE=true

pkg_setup() {
	games_pkg_setup

#	# FIXME: is this still a problem?
#	einfo "If compiling fails for you on gl_globals.h, try to replace your"
#	einfo "glext.h (usually found in /usr/include/GL/ with this one"
#	einfo "http://oss.sgi.com/projects/ogl-sample/ABI/glext.h"
#	einfo "remember to make backup of the original though"
}

src_unpack() {
	cd "${S}"
	local svn=${ESVN_TOP_DIR}

	if [ ! -d "${svn}/vegastrike" ]; then
		ESVN_MODULE="vegastrike"
		ESVN_MODULE_DIR="${ESVN_REPO_URI}/${ESVN_MODULE}"
		subversion_fetch $ESVN_MODULE_DIR $ESVN_MODULE || \
			die "Fetching vegastrike failed"
	fi

	einfo "Copying source to work directory..."
	cp -a "${svn}"/${PN}/* "${S}" >&/dev/null
}

src_prepare() {
	# Sort out directory references
	cd "${S}/${PN}"
	sed -i \
		-e "s!/usr/games/vegastrike!${GAMES_DATADIR}/${PN}!" \
		-e "s!/usr/local/bin!${GAMES_BINDIR}!" \
		launcher/saveinterface.cpp \
		|| die "sed launcher/saveinterface.cpp failed"
	#sed -i \
	#	-e '/^SUBDIRS =/s:tools::' \
	#	Makefile.am \
	#	|| die "sed Makefile.am failed"

	#	vssetup doesn't find "readme.txt"
	sed -i \
	"s!\"readme.txt\"! \"${GAMES_DATADIR}/${PN}/data/documentation/readme.txt\"!" \
		setup/src/include/display_gtk.cpp \
		|| die "sed setup/src/include/display_gtk.cpp failed"
}

src_compile() {
	mycmakeargs=(
		"NV_CUBE_MAP"
		"BOOST_PYTHON_NO_PY_SIGNATURES"
		-DUSE_SYSTEM_BOOST=ON
		)
#		-DBOOST_PYTHON_STATIC_LIB
#		-DDATA_DIR=\"${GAMES_DATADIR}/${PN}/data\"

	if use threads; then
		CPU_SMP=4
		einfo "Configuring for use with ${CPU_SMP} CPUs."
	fi

	if use debug; then
		CMAKE_BUILD_TYPE="Debug"
	else
		CMAKE_BUILD_TYPE="Release"
	fi

	cmake-utils_src_configure

	if use threads; then
		sed -i \
			-e "s!CPU_SMP:STRING=1!CPU_SMP:STRING=${CPU_SMP}!" \
			${P}_build/CMakeCache.txt
	fi

	cmake-utils_src_make vssetup || die "Failed to build vssetup"
	if use server; then
		cmake-utils_src_make vegaserver
	fi
	if use mesher; then
		cmake-utils_src_make mesh_tool
	fi
	cmake-utils_src_make vegastrike || die "Failed to build vegastrike"
}

src_install() {

	cat << EOF > vsinstall
#!/bin/sh
(
mkdir \${HOME}/.vegastrike 2> /dev/null
cd \${HOME}/.vegastrike
cp "${GAMES_DATADIR}/vegastrike/data/setup.config" .
cp -r "${GAMES_DATADIR}/vegastrike/data/.vegastrike/*" .
cp "${GAMES_DATADIR}/vegastrike/data/vegastrike.config" .
vssetup
)
echo "If you wish to have your own music edit ~/.vegastrike/*.m3u"
echo "Each playlist represents a place or situation in Vega Strike"
exit 0
EOF

	dogamesbin ${P}_build/vegastrike \
		|| die "Creation of vegastrike (the binary) failed"
	dogamesbin vsinstall \
		|| die "Creation of vsinstall failed"

	if use server; then
		dogamesbin ${P}_build/vegaserver \
			|| die "Creation of vegaserver failed"
	fi
	if use mesher; then
		dogamesbin ${P}_build/objconv/mesh_tool \
			|| die "Creation of mesher failed"
	fi

#	cmake-utils_src_install

	newgamesbin ${P}_build/setup/vssetup vssetup \
		|| { ewarn "vssetup was not built.  You will have to"; \
			 ewarn "manually edit ~/.vegastrike/vegastrike.config."; }

	make_desktop_entry "vegastrike" "Vegastrike" \
		"${GAMES_DATADIR}/${PN}/data/vegastrike.xpm"

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	einfo "First run vsinstall to install your account into ~/.vegastrike,"
	if [ -e "${GAMES_BINDIR}/vssetup" ]; then
		einfo "then run vssetup to configure Vega Strike."
	else
		einfo "then edit ~/.vegastrike/vegastrike.config."
	fi
	einfo "Run vegastrike to start Vega Strike."
	if use server; then
		einfo "To start Vega Strike Server run vegaserver."
	fi
}
