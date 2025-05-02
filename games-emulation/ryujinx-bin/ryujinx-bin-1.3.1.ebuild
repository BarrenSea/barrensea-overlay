EAPI=8

inherit desktop xdg-utils

DESCRIPTION="Experimental Nintendo Switch Emulator written in C#"
MYPN="ryujinx"
HOMEPAGE="https://ryujinx.app/
	https://git.ryujinx.app/ryubing/ryujinx/"
SRC_URI="https://ghproxy.net/https://github.com/Ryubing/Stable-Releases/releases/download/${PV}/${MYPN}-${PV}-linux_x64.tar.gz -> ${MYPN}.tar.gz"

KEYWORDS="amd64"
RESTRICT="strip"

LICENSE="MIT"

SLOT="0"
IUSE=""
DEPEND=""
RDEPEND="
	app-arch/brotli
	dev-libs/expat
	dev-libs/icu
	dev-libs/libxml2
	dev-libs/openssl
	dev-libs/wayland
	media-gfx/graphite2
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/freetype
	media-libs/harfbuzz
	media-libs/libglvnd[X]
	media-libs/libpng
	media-libs/libpulse
	media-libs/libsdl2
	media-video/pipewire
	x11-libs/gtk+:3
	x11-libs/libX11
"

DOCS=( "${FILESDIR}/README.md" "${FILESDIR}/THIRDPARTY.md" )
pkg_pretend() {
	use amd64 || die "only works on amd64"
}

src_unpack() {
   unpack ${MYPN}.tar.gz
}

S="${WORKDIR}/publish"
src_install() {
	# ryujinx into /opt/ryujinx
	dodir /opt/${MYPN}-${PV}
	rm -rf "${S}"/{mime,THIRDPARTY.md}
	cp -a "${S}"/* "${ED}"/opt/${MYPN}-${PV}/ || die "Failed to copy"

	# Ryujinx into /usr/bin/ryujinx
	dosym   /opt/${MYPN}-${PV}/${MYPN^} /usr/bin/${MYPN}
	dosym   /opt/${MYPN}-${PV}/${MYPN^}.sh /usr/bin/${MYPN^}.sh

	newicon "${FILESDIR}/Logo.svg" "${MYPN^}.svg"

	domenu "${FILESDIR}/${MYPN^}.desktop"

	insinto /usr/share/mime/packages
	doins "${FILESDIR}/${MYPN^}.xml"
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
