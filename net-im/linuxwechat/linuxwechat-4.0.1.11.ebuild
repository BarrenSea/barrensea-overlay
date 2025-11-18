EAPI=8

inherit unpacker desktop xdg-utils

DESCRIPTION="wechat from Tencent"
MYPN="WeChatLinux"
HOMEPAGE="https://linux.weixin.qq.com/"
SRC_URI="https://dldir1.qq.com/weixin/Universal/Linux/${MYPN}_x86_64.deb -> wechat.deb"
KEYWORDS="amd64"
LICENSE="Tencent"
SLOT="0"
IUSE=""
DEPEND=""
RDEPEND="

"
S="${WORKDIR}"
src_unpack() {
	unpack_deb ${DISTDIR}/wechat.deb
}

src_install() {
	dodir /opt
	dodir /usr
	sed -i 's/Exec=\/usr\/bin\/wechat/Exec=QT_IM_MODULE="fcitx" GTK_IM_MODULE="fcitxc" XMODIFIERS="@im=fcitx" \/opt\/wechat\/wechat/g' ${S}/usr/share/applications/* ||die
	fperms -wx ${S}/opt/wechat/libandromeda.so
	fperms -wx ${S}/opt/wechat/libowl.so
	fperms -wx ${S}/opt/wechat/libvoipCodec.so
	cp -a ${S}/* ${ED}/
	cd ${S}
	gzip -d usr/share/doc/wechat/changelog.gz || die
	dodoc usr/share/doc/wechat/changelog
	rm -rf ${ED}/usr/share/doc/wechat/

}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update

}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update

}
