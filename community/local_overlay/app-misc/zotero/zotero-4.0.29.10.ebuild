# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

if [ "${ARCH}" = "amd64" ] ; then
		LNXARCH="linux-x86_64"
else
		LNXARCH="linux-i686"
fi 

DESCRIPTION="Zotero [zoh-TAIR-oh] is a free, easy-to-use tool to help you collect, organize, cite, and share your research sources."
HOMEPAGE="https://www.zotero.org/"
SRC_URI="https://download.zotero.org/standalone/${PV}/Zotero-${PV}_${LNXARCH}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64? ( https://download.zotero.org/standalone/${PV}/Zotero-${PV}_linux-x86_64.tar.bz2 ) x86? ( https://download.zotero.org/standalone/${PV}/Zotero-${PV}_linux-i686.tar.bz2 ) "
RESTRICT="mirror strip"

RDEPEND=""

S="${WORKDIR}/${PN}_${LNXARCH}"

ZOTERO_INSTALL_DIR="/opt/${PN}"

src_install() {

	# install zotero files to /opt/Zotero
	dodir ${ZOTERO_INSTALL_DIR}
	cp -a ${S}/. ${D}${ZOTERO_INSTALL_DIR} || die "Installing files failed"

	# install zotero-start.sh in /opt/Zotero
	touch $D${ZOTERO_INSTALL_DIR}/zotero-start.sh

	# give it some instructions to start zotero
	echo "#!/bin/sh" >> $D${ZOTERO_INSTALL_DIR}/zotero-start.sh
	echo "exec "/opt/Zotero/zotero"" >>  $D${ZOTERO_INSTALL_DIR}/zotero-start.sh

	# make zotero-start.sh executable
	fperms +x ${ZOTERO_INSTALL_DIR}/zotero-start.sh

	# sym link /opt/Zotero/zotero-start.sh to /opt/bin/zotero
	dosym ${ZOTERO_INSTALL_DIR}/zotero-start.sh /opt/bin/zotero

}
