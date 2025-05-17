EAPI=8

DESCRIPTION="Script to enable audio support on many Chrome devices"
HOMEPAGE="https://github.com/WeirdTreeThing/chromebook-linux-audio"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
BDEPEND="
"
PDEPEND="
	media-video/wireplumber
	dev-lang/python
	media-libs/alsa-lib
	media-libs/alsa-ucm-conf
	media-plugins/alsa-plugins
	media-sound/alsa-utils
"
S=${WORKDIR}
src_install() {
	git clone https://ghproxy.net/https://github.com/WeirdTreeThing/alsa-ucm-conf-cros
	git clone https://ghproxy.net/https://github.com/WeirdTreeThing/chromebook-linux-audio
	dodir /usr/share/alsa/ucm2
	cp -a ${S}/alsa-ucm-conf-cros/ucm2 ${ED}/usr/share/alsa/ucm2

	dodir /usr/share/alsa/ucm2/conf.d
	cp -a ${S}/alsa-ucm-conf-cros/overrides ${ED}/usr/share/alsa/ucm2/conf.d

	dodir /lib/firmware/amd/sof/community
	cp -a ${S}/chromebook-linux-audio/blobs/mdn/fw ${ED}/lib/firmware/amd/sof/community

	dodir /lib/firmware/amd/sof-tplg
	cp -a ${S}/chromebook-linux-audio/blobs/mdn/tplg ${ED}/lib/firmware/amd/sof-tplg

	dodir /lib/firmware/intel/avs
	tar xf ${S}/chromebook-linux-audio/blobs/avs-topology_{avs_tplg_ver}.tar.gz -C  ${S}/avs_tplg

	cp -a ${S}/avs_tplg/avs-topology/lib/firmware/intel/avs ${ED}/lib/firmware/intel/avs

	doins /etc/modprobe.d/hifi2-sof.conf
	cp -a ${S}/chromebook-linux-audio/conf/sof/hifi2-sof.conf ${ED}/etc/modprobe.d/hifi2-sof.conf

	dodir /etc/wireplumber/wireplumber.conf.d
	cp -a ${S}/chromebook-linux-audio/conf/common/51-increase-headroom.conf ${ED}/etc/wireplumber/wireplumber.conf.d/51-increase-headroom.conf
}
