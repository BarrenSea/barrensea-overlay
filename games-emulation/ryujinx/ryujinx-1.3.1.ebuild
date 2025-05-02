# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_PKG_COMPAT=9.0
NUGETS="
avalonia.angle.windows.natives@2.1.0.2023020321
avalonia.buildservices@0.0.29
avalonia@11.0.13
avalonia.controls.datagrid@11.0.13
avalonia.desktop@11.0.13
avalonia.diagnostics@11.0.13
avalonia.markup.xaml.loader@11.0.13
avalonia.svg@11.0.0.19
avalonia.svg.skia@11.0.0.19
microsoft.build.framework@17.11.4
microsoft.build.utilities.core@17.12.6
newtonsoft.json@13.0.3
projektanker.icons.avalonia@9.4.0
projektanker.icons.avalonia.fontawesome@9.4.0
projektanker.icons.avalonia.materialdesign@9.4.0
commandlineparser@2.9.1
communitytoolkit.mvvm@8.4.0
concentus@2.2.2
discordrichpresence@1.2.1.24
dynamicdata@9.0.4
fluentavaloniaui@2.0.5
humanizer@2.14.1
libhac@0.19.0
microsoft.codeanalysis.analyzers@3.3.4
microsoft.codeanalysis.csharp@4.9.2
microsoft.identitymodel.jsonwebtokens@8.3.0
microsoft.net.test.sdk@17.9.0
microsoft.io.recyclablememorystream@3.0.1
msgpack.cli@1.0.1
netcoreserver@8.0.7
nunit@3.13.3
nunit3testadapter@4.1.0
opentk.core@4.8.2
opentk.graphics@4.8.2
opentk.audio.openal@4.8.2
opentk.windowing.graphicslibraryframework@4.8.2
open.nat.core@2.1.0.5
ryujinx.audio.openal.dependencies@1.21.0.1
ryujinx.graphics.nvdec.dependencies.allarch@6.1.2-build3
ryujinx.graphics.vulkan.dependencies.moltenvk@1.2.0
ryujinx.sdl2-cs@2.30.0-build32
gommon@2.7.1.1
securifybv.shelllink@0.1.0
sep@0.6.0
shaderc.net@0.1.0
sharpziplib@1.4.2
silk.net.vulkan@2.22.0
silk.net.vulkan.extensions.ext@2.22.0
silk.net.vulkan.extensions.khr@2.22.0
skiasharp@2.88.9
skiasharp.nativeassets.linux@2.88.9
spb@0.0.4-build32
system.io.hashing@9.0.2
system.management@9.0.2
unicornengine.unicorn@2.0.2-rc1-fb78016"

inherit check-reqs desktop dotnet-pkg xdg

DESCRIPTION="Experimental Nintendo Switch Emulator written in C#"
HOMEPAGE="https://ryujinx.app/
	https://git.ryujinx.app/ryubing/ryujinx/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://git.ryujinx.app/ryubing/${PN}.git"
else
	SRC_URI="https://git.ryujinx.app/ryubing/${PN}/-/archive/${PV}/${PN}-${PV}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${P^}"

	KEYWORDS="amd64"
fi

SRC_URI+=" ${NUGET_URIS} "

LICENSE="MIT"
SLOT="0"

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

CHECKREQS_DISK_BUILD="3G"
DOTNET_PKG_BUILD_EXTRA_ARGS=( -p:ExtraDefineConstants=DISABLE_UPDATER )
DOTNET_PKG_PROJECTS=(
	"src/${PN^}/${PN^}.csproj"
)
PATCHES=(
	"${FILESDIR}/${P}-better-defaults.patch"
)

DOCS=( README.md distribution/legal/THIRDPARTY.md )

pkg_setup() {
	check-reqs_pkg_setup
	dotnet-pkg_pkg_setup
}

src_unpack() {
	dotnet-pkg_src_unpack

	if [[ -n "${EGIT_REPO_URI}" ]] ; then
		git-r3_src_unpack
	fi
}

src_prepare() {
	sed "s|1.0.0-dirty|${PV}|g" -i src/*/*.csproj || die

	dotnet-pkg_src_prepare
}

src_test() {
	dotnet-pkg-base_test src/Ryujinx.Tests.Memory
}

src_install() {
	# Bug https://bugs.gentoo.org/933075
	# and bug https://github.com/Ryujinx/Ryujinx/issues/5566
	dotnet-pkg-base_append-launchervar "GDK_BACKEND=x11"

	dotnet-pkg-base_install

	# "Ryujinx.sh" launcher script is only copied for "linux-x64" RID,
	# let's copy it unconditionally. Bug: https://bugs.gentoo.org/923817
	exeinto "/usr/share/${P}"
	doexe "distribution/linux/${PN^}.sh"
	dotnet-pkg-base_dolauncher "/usr/share/${P}/${PN^}.sh"

	newicon distribution/misc/Logo.svg "${PN^}.svg"
	domenu "distribution/linux/${PN^}.desktop"

	insinto /usr/share/mime/packages
	doins "distribution/linux/mime/${PN^}.xml"

	einstalldocs
}
