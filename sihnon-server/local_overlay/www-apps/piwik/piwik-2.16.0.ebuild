# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:
EAPI=2

inherit webapp depend.php

DESCRIPTION="Piwik is a downloadable, open source (GPL licensed) real time web analytics software program."
HOMEPAGE="http://www.piwik.org/"
SRC_URI="http://builds.piwik.org/piwik-${PV}.zip"

LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="dev-lang/php[pdo,ctype,xml] || ( <dev-lang/php-5.3[spl,reflection] >=dev-lang/php-5.3 )"

need_httpd_cgi
need_php_httpd

pkg_setup() {
	webapp_pkg_setup
}

src_install() {
	webapp_src_preinst

	insinto "${MY_HTDOCSDIR}"
	dodir "${MY_HTDOCSDIR}/"{tmp,config}
	doins -r piwik/*

	webapp_serverowned -R "${MY_HTDOCSDIR}/"{tmp,config}
	webapp_postinst_txt en "${FILESDIR}"/installdoc.txt
	webapp_configfile "${MY_HTDOCSDIR}/config/"{global.ini.php,manifest.inc.php}
	webapp_src_install
	fperms -R 0660 "${MY_HTDOCSDIR}/"{tmp,config}
}

pkg_postinst() {
	elog "Install and upgrade instructions can be found here:"
	elog "  http://piwik.org/docs/installation-optimization/"
	webapp_pkg_postinst
}
