EAPI=8

DESCRIPTION="Linux Kernel with cjkpatch"
HOMEPAGE="https://github.com/barrensea/barrensea-overlay"
SRC_URI="https://mirrors.tuna.tsinghua.edu.cn/kernel/v6.x/linux-${PV}.tar.xz
https://ghproxy.net/https://github.com/donjuanplatinum/notes/blob/main/config
https://ghproxy.net/https://github.com/bigshans/cjktty-patches/blob/master/cjktty-add-cjk32x32-font-data.patch
https://ghproxy.net/https://github.com/bigshans/cjktty-patches/blob/master/v6.x/cjktty-6.9.patch
"
LICENSE="GPL-2"
SLOT=0
KEYWORDS="amd64 ~arm arm64 ~hppa ~loong ~ppc ppc64 ~riscv ~sparc x86"
BDEPEND="
	app-alternatives/bc
	app-alternatives/lex
	dev-util/pahole
	virtual/libelf
	app-alternatives/yacc
	app-crypt/sbsigntools
"
PDEPEND="
	sys-kernel/linux-firmware
"
S=${WORKDIR}/linux-${PV}

src_prepare() {
	cp ${DISTDIR}/*.patch ${S}/
	cp ${DISTDIR}/config ${S}/.config || die
	cd ${S}
	patch -Np1 <cjktty-6.9.patch ||die
	patch -Np1 <cjktty-add-cjk32x32-font-data.patch ||die
	default
}

src_compile() {
	cd ${S}
	ARCH="x86_64"
	make || die

}
src_install(){
	cd ${S}
	make INSTALL_MOD_PATH=${ED}/lib/modules INSTALL_MOD_STRIP=1 modules_install ||die
	make INSTALL_PATH=${ED}/boot install ||die
}
