#!/bin/bash

echo "Preparatore per Aptosid 1.3 by Mte90 - www.mte90.net"

UTENTE="mte90"
cd /home/$UTENTE/Desktop

echo "Aggiunta Repo"
echo "deb http://backports.debian.org/debian-backports squeeze-backports main
deb http://ftp.bononia.it/debian/ experimental main contrib non-free
deb http://mozilla.debian.net/ squeeze-backports iceweasel-beta
deb http://packages.siduction.org/experimental unstable main contrib non-free
deb-src http://packages.siduction.org/experimental unstable main contrib non-free
deb http://qt-kde2.debian.net/debian experimental-snapshots main
deb http://download.webmin.com/download/repository sarge contrib
deb http://download.opensuse.org/repositories/isv:ownCloud:ownCloud2012/Debian_6.0/ /
" >> /etc/apt/sources.list

wget http://www.webmin.com/jcameron-key.asc
apt-key add jcameron-key.asc
rm ./jcameron-key.asc
wget http://download.opensuse.org/repositories/isv:/ownCloud:/ownCloud2012/Debian_6.0/Release.key
apt-key add ./Release.key
rm ./Release.key
wget http://packages.siduction.org/siduction/pool/main/s/siduction-keyring/siduction-archive-keyring_2012.03.23_all.deb
dpkg -i ./siduction-archive-keyring_2012.03.23_all.deb
rm ./siduction-archive-keyring_2012.03.23_all.deb

#sfondi
#script da github

echo "Fix & tips"

echo 'CONCURRENCY=makefile' >> /etc/default/rcS

#fix per avvio gui da root in console
echo "
export XAUTHORITY=/home/$UTENTE/.Xauthority
export \$(dbus-launch)

alias update='apt-get update'
alias upgrade='apt-get upgrade'
alias search='apt-cache search'
alias policy='apt-cache policy'
alias deb64='dpkg --force-architecture -i'
alias apts='(kate /etc/apt/sources.list &)'
alias casa='cd /home/$UTENTE/Desktop'
alias ex='unp'
function exr() { unp $1 ; rm $1;}

echo -e '\e[1;31m';
echo \"  ______  _____   _____  _______\";
echo \" |_____/ |     | |     |    |\";
echo \" |    \_ |_____| |_____|    |\";
echo -e '\e[m';
" >> /root/.bashrc

echo "
function renmp3() {
	eyeD3 --rename="%A - %t" ./*
}
alias casa='cd /home/$UTENTE/Desktop'
alias ex='unp'
alias yt2mp3='youtube-dl -l --extract-audio --audio-format=mp3 -w -c'
" >> /home/$UTENTE/.bashrc

echo "Caricamento Alias"
. /root/.bashrc

dpkg-reconfigure locales

echo "Aggiornamento ed installazione programmi"
apt-get update
apt-get remove kde-l10n-de kaffeine aptosid-manual* aptosid-irc install-usb-gui gparted bluez bluez-pcmcia-support
apt-get -y install kde-l10n-it pkg-mozilla-archive-keyring
apt-get upgrade
#Librerie KDE
apt-get -y install kdelibs5-dev kde-workspace-dev plasma-scriptengine-python plasma-scriptengine-javascript plasma-widgets-workspace plasma-widgets-addons konq-plugins virtuoso-minimal strigi-client python-kde4 python-qt4 libqt4-core libqt4-gui python3-pyqt4 appmenu-qt kdepim-groupware kdepim-kresources kdepim-wizards
#Librerie
apt-get -y install ia32-libs ia32-libs-gtk cmake cmake-curses-gui libtool libtag-extras-dev libflac++-dev libtag1-dev libavutil51 libflac++-dev libxml-twig-perl
apt-get -y install libx11-dev libxfixes-dev libxrender-dev mesa-common-dev libsdl1.2-dev libpcap0.8-dev libgraphicsmagick++3 libhighgui2.3 libraw1394-11 libdc1394-22 libcv2.1
apt-get -y install intltool libwnck-dev libnoise-dev libgsl0-dev libfftw3-dev libgif-dev libmagick++-dev libgl1-mesa-dev gettext libosmesa6
#Multimedia
apt-get install vlc audacity soundkonverter kdenlive w64codecs kid3 openshot transmageddon mediainfo qtractor picard lame libid3-tools melt python-mlt3 libmlt++3 libmlt4 libdvdcss2 transcode tupi
#Grafica
apt-get install gimp gimp-data-extras gimp-plugin-registry agave trimage kcolorchooser kruler inkscape kdegraphics-strigi-plugins okular-extra-backends kipi-plugins imagemagick create-resources python-uniconvertor
#Internet
apt-get install emesene amule amule-daemon amule-utils plasma-widget-amule deluged deluge-web icedove icedove-l10n-it akregator choqok
#Ufficio
apt-get install libreoffice-writer libreoffice-l10n-it libreoffice-kde libreoffice-impress libreoffice-calc libreoffice-draw tellico korganizer
#Mozilla/Chromium :-(
apt-get install -t squeeze-backports iceweasel iceweasel-l10n-it
apt-get install myspell-it mozilla-libreoffice mozplugger flashplugin-nonfree chromium-browser mozilla-plugin-vlc
#Sistema
apt-get install update-notifier-kde kde-config-gtk-style apt-rdepends webmin imwheel gtk2-engines-pixbuf gtk2-engines-oxygen file-roller bum acetoneiso virtualbox virtualbox-ose-qt virtualbox-dkms qt4-qmake kde-notification-colibri kuser ksystemlog
#Programmazione
apt-get install filezilla lokalize kompare scite universalindentgui qtcreator php5 php5-gd apache2 mysql-server phpmyadmin kate arduino node-less
#Tools
apt-get install gprename yakuake preload wine gksu unrar partitionmanager ruby rubygems gdb kmenuedit subversion git mercurial openjdk-7-jre localepurge kdesudo owncloud-client exfat-fuse exfat-utils
#Font
apt-get install ttf-mscorefonts-installer ttf-droid ttf-dejavu ttf-freefont ttf-bitstream-vera ttf-freefont ttf-linux-libertine ttf-inconsolata
apt-get clean

echo "Fix"
modprobe vboxdrv
modprobe vboxnetflt
a2enmod rewrite
localepurge

while true; do
    read -n 1 -p "Vuoi proseguire?" sn
    case $sn in
        [Ss]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Si o no.";;
    esac
done

mkdir install_
cd ./install_

echo "
installo BeShadowed"
wget -b -O beshadowed.txz http://kde-apps.org/CONTENT/content-files/121607-beshadowed-kwin-fx-0.8a.txz
exr ./beshadowed.txz
cd ./beshadowed-kwin-fx && ./configure
cd build; make -j16 && make install
cd ../

while true; do
    read -n 1 -p "Vuoi proseguire?" sn
    case $sn in
        [Ss]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Si o no.";;
    esac
done

echo "
Installo qualche plasmoide"
wget -b http://download.opensuse.org/repositories/home:/pinters/Debian_6.0/amd64/netspeed-plasma_0.2-1_amd64.deb
dpkg -i ./netspeed-plasma_0.2-1_amd64.deb

wget -b -O playctrl.plasmoid http://kde-apps.org/CONTENT/content-files/144437-playctrl.plasmoid
plasmapkg -i ./playctrl.plasmoid

while true; do
    read -n 1 -p "Vuoi proseguire?" sn
    case $sn in
        [Ss]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Si o no.";;
    esac
done

echo "
Qualche chicca"

wget -b http://kde-apps.org/CONTENT/content-files/141946-MediaInfoKDE.desktop
mv ./141946-MediaInfoKDE.desktop /usr/share/kde4/services/ServiceMenus/MediaInfoKDE.desktop

wget -b http://download.tuxfamily.org/ramielinux/aMuleKollection/amuleKollection-0.4.tar.gz
exr ./amuleKollection-0.4.tar.gz
cd ./amuleKollection-0.4 && ./install.sh
cd ../

wget -b http://dl.dropbox.com/u/23646728/BlaQuave.tar.gz
exr ./BlaQuave.tar.gz
mv ./BlaQuave /usr/share/icons/BlaQuave

wget -b -O robots.xml http://kde-files.org/CONTENT/content-files/124969-robots.xml
mv ./robots.xml /usr/share/apps/katepart/syntax/

mkdir ./audiothumbs && cd ./audiothumbs
wget -b -O AudioThumbs-0.2.tar.gz http://kde-apps.org/CONTENT/content-files/145088-AudioThumbs-0.2.tar.gz
exr ./AudioThumbs-0.2.tar.gz
mkdir ./build
cd ./build
cmake -DCMAKE_INSTALL_PREFIX=`kde4-config --prefix` ..
make && make install
cd ../

wget -b -O ofwvlc.tar.gz http://kde-apps.org/CONTENT/content-files/146621-ofwvlc-0.3.tar.gz
exr ./ofwvlc.tar.gz
cd ./ofwvlc; cp vlc.desktop /usr/share/kde4/services/ServiceMenus/
cd it; cp ofwvlc /usr/sbin
chmod +x /usr/sbin/ofwvlc /usr/share/kde4/services/ServiceMenus/vlc.desktop
cd ../

wget -b -O kate-folder-service-menu.tar.gz http://kate-folder-service-menu.googlecode.com/files/kate-folder-service-menu0.2.tar.gz
exr ./kate-folder-service-menu.tar.gz
cd ./kate-folder-service-menu
./install
cd ../

echo "
Avvio FileZilla, Wine, Gimp per inizializzarli!"

su $UTENTE -c "filezilla"
su $UTENTE -c "wine"
su $UTENTE -c "gimp"

while true; do
    read -n 1 -p "Vuoi proseguire?" sn
    case $sn in
        [Ss]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Si o no.";;
    esac
done

echo "
Kdeizziamo FileZilla, Wine, Gimp"

wget -b -O filezilla-theme.tar.gz http://kde-look.org/CONTENT/content-files/141546-filezilla-oxygen-theme.tar.gz
exr ./filezilla-theme.tar.gz
mv ./oxygen /usr/share/filezilla/resources/oxygen

wget -b http://dl.dropbox.com/u/17620616/linki/Oxywine_3.1.msstyles
mkdir /home/$UTENTE/.wine/drive_c/windows/Resources
mkdir /home/$UTENTE/.wine/drive_c/windows/Resources/Themes
mkdir /home/$UTENTE/.wine/drive_c/windows/Resources/Themes/Oxywine_3.1
chmod -R 777 /home/$UTENTE/.wine/drive_c/windows/Resources
mv ./Oxywine_3.1.msstyles /home/$UTENTE/.wine/drive_c/windows/Resources/Themes/Oxywine_3.1

wget -b -O gimp.tar.gz http://downloads.sourceforge.net/project/chakra/Tools/Gimp-Oxygen/Gimp-Oxygen-0.1.tar.gz
exr ./gimp.tar.gz
mv ./Gimp-Oxygen /usr/share/gimp/2.0/themes/Gimp-Oxygen

while true; do
    read -n 1 -p "Vuoi proseguire?" sn
    case $sn in
        [Ss]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Si o no.";;
    esac
done

echo "
installo i Google Font - Impiega diverso tempo"
cd /home/$UTENTE/
wget -b http://webupd8.googlecode.com/files/install-google-fonts
chmod +x install-google-fonts
echo "Intanto devi settare Gimp, Filezilla e Wine per usare i temi scaricati, link per universalindentgui."

while true; do
    read -n 1 -p "Vuoi proseguire?" sn
    case $sn in
        [Ss]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Si o no.";;
    esac
done

./install-google-fonts
cd /home/$UTENTE/Desktop/install_

echo "
installo Grub2 KCM"
wget -b http://anongit.kde.org/kcmgrub2/kcmgrub2-latest.tar.gz
exr ./kcmgrub2-latest.tar.gz
cd kcmgrub2/
./initrepo.sh
mkdir build && cd build
cmake ..
make -j16 && make install
cd ../../

while true; do
    read -n 1 -p "Vuoi proseguire?" sn
    case $sn in
        [Ss]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Si o no.";;
    esac
done

echo "
installo SVG Cleaner"
wget -b -O svgcleaner.tar.gz https://github.com/RazrFalcon/SVGCleaner/tarball/master
exr ./svgcleaner.tar.gz
cd `tar tzf svgcleaner.tar.gz | head -1`
qmake
make -j16 && make install
cd ../

while true; do
    read -n 1 -p "Vuoi proseguire?" sn
    case $sn in
        [Ss]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Si o no.";;
    esac
done

echo "
installo Converseen"
wget -b -O converseen-0.5.tar.bz2 http://sourceforge.net/projects/converseen/files/Converseen/Converseen%200.5/0.5.0/converseen-0.5.tar.bz2/download
exr ./converseen-0.5.tar.bz2
cd ./converseen-0.5
mkdir build
cd build
cmake .. && make -j16 && make install
cd ../../

while true; do
    read -n 1 -p "Vuoi proseguire?" sn
    case $sn in
        [Ss]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Si o no.";;
    esac
done

echo "
installo la cagata di Skype"
wget -b -O skype-install.deb http://www.skype.com/go/getskype-linux-deb-64
dpkg -i ./skype-install.deb

echo "
Installiamo Orta come tema per GTK"
wget -b http://www.deviantart.com/download/184118297/orta_by_skiesofazel-d31mal5.zip
exr ./orta_by_skiesofazel-d31mal5.zip
tar zxvf ./extractme.tar.gz
cd ./extractme
python ./OrtaSettingsManager.py

while true; do
    read -n 1 -p "Vuoi proseguire?" sn
    case $sn in
        [Ss]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Si o no.";;
    esac
done

echo "
installo Bespin"
cd /home/mte90
svn co https://cloudcity.svn.sourceforge.net/svnroot/cloudcity
cd cloudcity && ./configure
cd build && make -j16 && make install
cd /home/$UTENTE/Desktop/install_

while true; do
    read -n 1 -p "Vuoi proseguire?" sn
    case $sn in
        [Ss]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Si o no.";;
    esac
done

echo "
Setto imwheel"

cat >/etc/X11/imwheel/imwheelrc <<EOF
".*"
None,   Thumb1,   Alt_L|Left
None,   Thumb2,   Alt_L|Right
EOF

rm -f /etc/X11/Xsession.d/999imwheel_start
rm -f /etc/X11/imwheel/startup.conf
cat > /etc/X11/imwheel/startup.conf <<EOF

IMWHEEL_START=1
IMWHEEL_PARAMS="-b 0 0 0 0 8 9"

/usr/bin/killall imwheel 2>/dev/null
EOF

echo "
Installo Brother MFC620CN"
#http://welcome.solutions.brother.com/bsc/public_s/id/linux/en/index.html
#http://welcome.solutions.brother.com/bsc/public_s/id/linux/en/download_prn.html#MFC-620CN
wget -b http://www.brother.com/pub/bsc/linux/dlf/mfc620cnlpr-1.0.2-1.i386.deb
wget -b http://www.brother.com/pub/bsc/linux/dlf/cupswrapperMFC620CN-1.0.2-3.i386.deb
dpkg -i --force-architecture ./mfc620cnlpr-1.0.2-1.i386.deb
dpkg -i --force-architecture ./cupswrapperMFC620CN-1.0.2-3.i386.deb
#file fixato per i margini
wget -b http://dl.dropbox.com/u/21763079/MFC620CN.ppd
mv ./MFC620CN.ppd /etc/cups/ppd/MFC620CN.ppd

echo "Download HotKeys"
wget -b -O preset.hotkeys http://kde-look.org/CONTENT/content-files/148793-preset.khotkeys

su $UTENTE -c "kcmshell4 khotkeys"

echo "
Avvio Bum"
bum

echo "
Configura Bespin"

su $UTENTE -c "bespin config"

echo "
Carico la configurazione di Samba"
wget -b http://dl.dropbox.com/u/21763079/smb.conf
mv ./smb.conf /etc/samba/smb.conf

echo "
Carico la configurazione di Konversation"
su $UTENTE -c "konversation"
wget -b http://dl.dropbox.com/u/21763079/konversationrc
mv ./konversationrc /home/mte90/.kde/share/config/konversationrc

echo "
Carico la configurazione di Kate"
su $UTENTE -c "kate"
wget -b http://dl.dropbox.com/u/21763079/katerc
mv ./katerc /home/mte90/.kde/share/config/katerc

echo "
Carico la configurazione di Choqok"
su $UTENTE -c "choqok"
wget -b http://dl.dropbox.com/u/21763079/choqokrc
mv ./choqokrc /home/mte90/.kde/share/config/choqokrc

echo "
Imposto Yakuake all'avvio"
wget -b http://dl.dropbox.com/u/21763079/Yakuake.desktop
cp ./Yakuake.desktop /home/mte90/.config/autostart/Yakuake.desktop

echo "
Configuro Firefox"
ff_path=`grep Path /home/$UTENTE/firefox/profiles.ini`
ff_path=`sed "s/Path=//g"`
cd /home/$UTENTE/.mozilla/firefox/$ff_path/
echo '//support for ed2k link
user_pref("network.protocol-handler.app.ed2k", "/usr/bin/ed2k");
user_pref("network.protocol-handler.expose.ed2k", false);
user_pref("network.protocol-handler.external.ed2k", true);
//webgl library
user_pref("webgl.osmesalib", "/usr/lib/x86_64-linux-gnu/libOSMesa.so.6");
//homepage
user_pref("browser.startup.homepage", "http://www.mte90.net");
user_pref("network.dns.disableIPv6", false);
user_pref("http.proxy.pipelining", true);
user_pref("network.http.pipelining", true);
user_pref("network.http.pipelining.maxrequests", 10);
user_pref("content.switch.threshold", 250000);
user_pref("middlemouse.contentLoadURL", false);
' > ./user.js

while true; do
    read -n 1 -p "Vuoi proseguire?" sn
    case $sn in
        [Ss]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Si o no.";;
    esac
done

echo "
Salvo i vari script"

echo "Monitor.sh - Ripristina i settaggi dei monitor"
echo '
#!/bin/bash
xrandr --output "HDMI-0" --pos 1360x0 --mode 1280x1024 --refresh 75.0762 --output "VGA-0" --pos 0x0 --mode 1360x768 --refresh 60.0152 --primary
'
> /home/$UTENTE/monitor.sh

chmod +x /home/$UTENTE/monitor.sh

echo "Trash.sh - Svuota il cestino, utile quando ci sono file con permessi sbagliati"
echo '
#!/bin/bash
rm -rfvI ~/.local/share/Trash/files/
rm -rfvI ~/.local/share/Trash/info/'
> /home/$UTENTE/trash.sh

chmod +x /home/$UTENTE/trash.sh

echo "Recoveryfont.sh - Ricarica la conf dei font di kde, utile dopo aver aggiornato i font succede che si sputanna tutto"
cp /home/$UTENTE/.kde/share/config/kdeglobals /home/$UTENTE/.kde/share/config/_kdeglobals
echo "
#!/bin/bash
cd /home/$UTENTE/.kde/share/config/
cp ./_kdeglobals ./kdeglobals
kcmshell4 fonts"
> /home/$UTENTE/recoveryfont.sh

chmod +x /home/$UTENTE/recoveryfont.sh

echo "Gmic.sh - Aggiornare Gmic"
echo '
#!/bin/bash
wget http://downloads.sourceforge.net/gmic/gmic_gimp_linux64.zip
unzip ./gmic_gimp_linux64.zip
mv ./gmic_gimp /usr/lib/gimp/2.0/plug-ins/
rm ./gmic_gimp_linux64.zip
rm ./README
'
> /home/$UTENTE/gmic.sh

chmod +x /home/$UTENTE/gmic.sh

while true; do
    read -n 1 -p "Vuoi proseguire?" sn
    case $sn in
        [Ss]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Si o no.";;
    esac
done


echo "
installo Gmic per Gimp"
/home/$UTENTE/gmic.sh

echo "Gimp - Palette, Patterns, Brushes, Gradients"
cd /home/$UTENTE/Desktop/install_
mkdir ./gimp
wget -b http://gimp-tutorials.net/files/130-UltimateWeb2-0-Gradients-for-Gimp.zip
exr ./130-UltimateWeb2-0-Gradients-for-Gimp.zip
wget -b http://www.deviantart.com/download/244975649/30_gimp_gradients_by_frostbo-d41uof5.zip
exr ./30_gimp_gradients_by_frostbo-d41uof5.zip
mv ./Gimp\ Gradient\ pack\ 30\ by\ frost/* /usr/share/gimp/2.0/gradients/
wget -b http://gps-gimp-paint-studio.googlecode.com/files/GPS%201_5_final%20release.zip
exr ./GPS\ 1_5_final\ release.zip
cd ./brushes
wget -b http://www.deviantart.com/download/124578466/3D_Gimp_Brush_set_by_DimondDoves.zip
exr 3D_Gimp_Brush_set_by_DimondDoves.zip
rm wget_log
cd ../
mv gradients/* /usr/share/gimp/2.0/gradients/
mv brushes/* /usr/share/gimp/2.0/brushes/
mv patterns/* /usr/share/gimp/2.0/patterns/
mv palettes/* /usr/share/gimp/2.0/palettes/
mv tool-options/* /home/$UTENTE/.gimp-2.8/tool-options/

echo "Gimp - Scripts"
mkdir ./scripts
cd ./scripts
wget -b http://www.deviantart.com/download/30316704/GLASS_SCRIPT_FU_runs_on_2_4_by_kward1979uk.scm
wget -b http://shallowsky.com/software/pandora/pandora-combine-0.9.3.scm
wget -b http://registry.gimp.org/files/layers-slices_1.scm
wget -b http://www.deviantart.com/download/74282791/Retro_Background_Script_by_fence_post.scm
wget -b http://www.deviantart.com/download/77556760/GIMP_2_6_and_2_4_Satin_Script_by_fence_post.zip
wget -b http://www.deviantart.com/download/123319582/Electronic_GIMP_Script_by_mikethedj4.scm
wget -b http://www.deviantart.com/download/71646868/Add_Border_Script_by_Insanity_Prevails.scm
wget -b http://www.deviantart.com/download/273071819/gimp_script___fit_all_layers_to_image_size_by_elheartista-d4ikvkb.zip
exr ./GIMP_2_6_and_2_4_Satin_Script_by_fence_post.zip
exr ./gimp_script___fit_all_layers_to_image_size_by_elheartista-d4ikvkb.zip
rm ./GIMP_2_6_and_2_4_Satin_Script_by_fence_post.zip
rm ./gimp_script___fit_all_layers_to_image_size_by_elheartista-d4ikvkb.zip
rm ./wget_log
cd ../
mv scripts/* /usr/share/gimp/2.0/scripts

echo "Gimp - Plugin"
wget -b http://files.myopera.com/area42/files/cssdev.py
chmod +x ./cssdev.py
mv ./cssdev.py /usr/lib/gimp/2.0/plug-ins/
wget -b http://registry.gimp.org/files/gimp-plugin-toy-1.0.4.tar.gz
exr ./gimp-plugin-toy-1.0.4.tar.gz
cd ./gimp-plugin-toy-1.0.4
./configure
make && make install
cd ../
wget -b -O resynth.tar.gz https://github.com/bootchk/resynthesizer/tarball/master
exr ./resynth.tar.gz
cd `tar tzf resynth.tar.gz | head -1`
./autogen.sh
make -j16 && make install

echo "Rimozione file scaricati"
cd /home/$UTENTE/Desktop/
rm -r ./install_

su $UTENTE -c "kdebugdialog"

echo "Installazione finita"
