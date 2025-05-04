EAPI=8

DESCRIPTION="Barrensea Emacs Configures .emacs.d"
HOMEPAGE="https://github.com/barrensea/.emacs.d"

if [[ "${PV}" == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://ghproxy.net/https://github.com/barrensea/.emacs.d"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="+ebuild +rime"
DOCS="README.org"
BDEPEND="
	app-editors/emacs
	ebuild? (
		app-emacs/ebuild-mode
)
	rime? (
		app-i18n/librime
)
"

src_unpack() {
	git-r3_src_unpack
}
S="${WORKDIR}/${P}"
src_install() {
	dodir /usr/share/${PN}
	cp -a "${S}"/* "${ED}"/usr/share/${PN} || die "Failed to copy"
	dosym   /usr/share/${PN}/install.sh /usr/bin/install-${PN}.sh
	fperms +x /usr/share/${PN}/install.sh
	einstalldocs
}
