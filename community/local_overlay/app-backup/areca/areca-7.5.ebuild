# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

JAVA_PKG_IUSE="source"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Areca personal backup solution"
KEYWORDS="~x86 ~amd64"
LICENSE="GPL-2"
IUSE=""
SLOT="0"

SRC_URI="mirror://sourceforge/project/${PN}/${PN}-stable/${P}/${P}-src.tar.gz"

RDEPEND=">=virtual/jre-1.4.2"
DEPEND=">=virtual/jdk-1.4.2
        dev-java/ant-core
        >=dev-java/swt-3.5.2
        >=dev-java/commons-codec-1.7
        >=dev-java/commons-net-1.4.1-r1
        >=dev-java/sun-javamail-1.4.3
        >=dev-java/sun-jaf-1.1.1
        >=dev-java/jakarta-oro-2.0.8-r3
        >=dev-java/jsch-0.1.49"

EANT_BUILD_TARGET="compileall"

src_unpack() {
    mkdir ${S}
    cd ${S}
    unpack ${A}
}

src_prepare() {
    java-pkg-2_src_prepare
    sed -i -e "s%<arg value=\"-fPIC\"/>%<arg value=\"-fPIC\"/>\n<arg value=\"-I${JAVA_HOME}/include\"/>\n<arg value=\"-I${JAVA_HOME}/include/linux\"/>%" \
	   -e 's%<fileset file=\"${swtfile}\"/>%%' \
	   build.xml || die 'Sed failed to add include directory'
    sed -i -e 's/CLASSPATH="${CLASSPATH}:${LIB_PATH}commons-net-1.4.1.jar"/CLASSPATH="${CLASSPATH}:${LIB_PATH}commons-net.jar"/' \
	   -e 's/CLASSPATH="${CLASSPATH}:${LIB_PATH}commons-codec-1.4.jar"/CLASSPATH="${CLASSPATH}:${LIB_PATH}commons-codec.jar"/' \
	   -e 's/CLASSPATH="${CLASSPATH}:${LIB_PATH}jakarta-oro-2.0.8.jar"/CLASSPATH="${CLASSPATH}:${LIB_PATH}jakarta-oro.jar"/' \
	   -e 's;CLASSPATH="${CLASSPATH}:/usr/lib/java/swt.jar";;' \
	   -e 's;CLASSPATH="${CLASSPATH}:/usr/lib64/java/swt.jar";;' \
	   -e 's;CLASSPATH="${CLASSPATH}:/usr/share/java/swt.jar";;' \
	   bin/areca_run.sh || die 'Sed failed to adapt lib names'
    cd ${S}/lib
    rm commons-codec-1.4.jar
    rm commons-net-1.4.1.jar
    rm mail.jar
    rm activation.jar
    rm jakarta-oro-2.0.8.jar
    rm jsch.jar
    java-pkg_jar-from swt-3.7 swt.jar
    java-pkg_jar-from commons-codec
    java-pkg_jar-from commons-net
    java-pkg_jar-from sun-javamail
    java-pkg_jar-from sun-jaf
    java-pkg_jar-from jakarta-oro-2.0
    java-pkg_jar-from jsch
}

src_install() {
    use source && java-pkg_dosrc src/com
    
    rm -rf "${S}/jni"
    rm -rf "${S}/src"
    rm "${S}/build.xml"

    mkdir -p ${D}/opt
    cp -a ${S} ${D}/opt/${P}
    find -iname "*sh" -exec chmod +x {} \;
    mkdir -p  ${D}/usr/bin/
    echo -e '#!/bin/bash \ncd /opt/areca-7.5 \n ./areca.sh ' > ${D}/usr/bin/areca
    chmod +xr-w ${D}/usr/bin/areca
    
    
    
    insinto /usr/share/icons/hicolor/16x16/apps
    newins "${S}/icons/ico_16.png" "${PN}.png"
    insinto /usr/share/icons/hicolor/72x72/apps
    newins "${S}/icons/ico_72.png" "${PN}.png"
    #domenu "${FILESDIR}/areca.desktop"
    make_desktop_entry /usr/bin/areca "Areca Backup" "areca" "System;Utility;Archiving;" 
}
