#!/bin/bash

echo "Preparatore per Aptosid 1.3 by Mte90 - www.mte90.net"

UTENTE="mte90"
cd /home/$UTENTE/Desktop

echo "deb http://www.debian-multimedia.org sid main non-free
deb http://backports.debian.org/debian-backports lenny-backports main contrib non-free
deb http://ftp.bononia.it/debian/ experimental main contrib non-free
deb http://packages.siduction.org/experimental unstable main contrib non-free
deb http://download.webmin.com/download/repository sarge contrib
" >> /etc/apt/sources.list

wget http://www.webmin.com/jcameron-key.asc
apt-key add jcameron-key.asc
rm ./jcameron-key.asc

#sfondi

echo "Repo aggiunti"

echo 'CONCURRENCY=makefile' >> /etc/default/rcS

#fix per avvio gui da root in console
echo "
export XAUTHORITY=/home/$UTENTE/.Xauthority
export \$(dbus-launch)

alias update='apt-get update'
alias upgrade='apt-get upgrade'
alias search='apt-cache search'
alias deb64='dpkg --force-architecture -i'
alias casa='cd /home/$UTENTE/Desktop'

echo -e '\e[1;31m';
echo \"  ______  _____   _____  _______\";
echo \" |_____/ |     | |     |    |\";
echo \" |    \_ |_____| |_____|    |\";
echo -e '\e[m';
" >> /root/.bashrc

echo "
alias casa='cd /home/$UTENTE/Desktop
alias renamemp3='eyeD3 --rename=\"%A - %t\" ./*'
" >> /home/$UTENTE/.bashrc

dpkg-reconfigure locales

apt-get update
apt-get remove kde-l10n-de kaffeine aptosid-manual* aptosid-irc install-usb-gui gparted bluez bluez-pcmcia-support
apt-get -y install kde-l10n-it debian-multimedia-keyring
apt-get upgrade
#Librerie KDE
apt-get -y install kdelibs5-dev kdebase-workspace-dev plasma-scriptengine-python plasma-scriptengine-javascript plasma-widgets-workspace plasma-widgets-addons konq-plugins virtuoso-minimal strigi-client python-kde4 python-qt4 libqt4-core libqt4-gui
#Librerie
apt-get -y install ia32-libs ia32-libs-gtk cmake cmake-curses-gui libtool libtag-extras-dev libflac++-dev libtag1-dev libavutil51 libflac++-dev
apt-get -y install libx11-dev libxfixes-dev libxrender-dev mesa-common-dev libsdl1.2-dev libpcap0.8-dev libgraphicsmagick++3 libhighgui2.3 libraw1394-11 libdc1394-22 libcv2.1
apt-get -y install intltool libwnck-dev libnoise-dev libgsl0-dev libfftw3-dev libgif-dev libmagick++-dev libgl1-mesa-dev  gettext libosmesa6
#Multimedia
apt-get install vlc audacity soundkonverter kdenlive w64codecs kid3 openshot transmageddon mediainfo qtractor picard lame libid3-tools melt python-mlt3 libmlt++3 libmlt4 libdvdcss2 transcode tupi
#Grafica
apt-get install gimp gimp-data-extras gimp-plugin-registry agave trimage kcolorchooser kruler inkscape inkscape kdegraphics-strigi-plugins okular-extra-backends kipi-plugins imagemagick create-resources python-uniconvertor
#Internet
apt-get install emesene amule amule-daemon amule-utils plasma-widget-amule deluged deluge-web icedove icedove-l10n-it akregator choqok
#Ufficio
apt-get install libreoffice-writer libreoffice-l10n-it libreoffice-kde libreoffice-impress libreoffice-calc libreoffice-draw tellico korganizer
#Mozilla/Chromium :-(
apt-get install myspell-it mozilla-libreoffice mozplugger flashplugin-nonfree chromium-browser mozilla-plugin-vlc iceweasel iceweasel-l10n-it
#Sistema
apt-get install update-notifier-kde kde-config-gtk-style apt-rdepends webmin imwheel gtk2-engines-pixbuf gtk2-engines-oxygen file-roller bum acetoneiso virtualbox virtualbox-ose-qt virtualbox-dkms qt4-qmake
#Programmazione
apt-get install filezilla lokalize kompare scite universalindentgui monkeystudio qtcreator php5 php5-gd apache2 mysql-server phpmyadmin kate arduino eric4 node-less
#Tools
apt-get install gprename yakuake preload wine gksu unrar partitionmanager ruby gdb kmenuedit subversion git mercurial openjdk-7-jre
#Font
apt-get install ttf-mscorefonts-installer ttf-droid ttf-dejavu ttf-freefont ttf-bitstream-vera ttf-freefont ttf-linux-libertine ttf-inconsolata googlefontdirectory-tools
#Giochi
apt-get install assaultcube
apt-get clean

modprobe vboxdrv
modprobe vboxnetflt
a2enmod rewrite

while true; do
    read -n 1 -p "Vuoi proseguire?" sn
    case $sn in
        [Ss]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Si o no.";;
    esac
done

echo "
installo BeShadowed"
wget -O beshadowed.txz http://kde-apps.org/CONTENT/content-files/121607-beshadowed-kwin-fx-0.8a.txz
tar Jxvf ./beshadowed.txz
cd ./beshadowed-kwin-fx && ./configure
cd build; make && make install
cd /home/$UTENTE/Desktop
rm ./beshadowed.txz
rm -r ./beshadowed-kwin-fx

echo "
installo BeClock"
wget -O beclock.txz http://kde-look.org/CONTENT/content-files/117542-beclock-kwin-fx-17a.txz
tar -xJf beclock.txz
cd beclock-kwin-fx
./configure
cd build; make && make install
cd /home/$UTENTE/Desktop
rm ./beclock.txz
rm -r ./beclock-kwin-fx

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
wget http://download.opensuse.org/repositories/home:/pinters/Debian_6.0/amd64/netspeed-plasma_0.2-1_amd64.deb
dpkg -i ./netspeed-plasma_0.2-1_amd64.deb
rm ./netspeed-plasma_0.2-1_amd64.deb

wget -O playctrl.plasmoid http://kde-apps.org/CONTENT/content-files/144437-playctrl.plasmoid
plasmapkg -i ./playctrl.plasmoid
rm ./playctrl.plasmoid

wget -O appmenu.plasmoid http://kde-apps.org/CONTENT/content-files/146098-plasma-applet-appmenu-qml-0.7.2.plasmoid
plasmapkg -i ./appmenu.plasmoid
rm ./appmenu.plasmoid

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

wget http://kde-apps.org/CONTENT/content-files/141946-MediaInfoKDE.desktop
mv ./141946-MediaInfoKDE.desktop /usr/share/kde4/services/ServiceMenus/MediaInfoKDE.desktop

wget http://download.tuxfamily.org/ramielinux/aMuleKollection/amuleKollection-0.4.tar.gz
tar zxvf ./amuleKollection-0.4.tar.gz
cd ./amuleKollection-0.4 && ./install.sh
cd /home/$UTENTE/Desktop
rm ./amuleKollection-0.4.tar.gz
rm -r ./amuleKollection-0.4

wget http://dl.dropbox.com/u/23646728/BlaQuave.tar.gz
tar zxvf ./BlaQuave.tar.gz
mv ./BlaQuave /usr/share/icons/BlaQuave
rm ./BlaQuave.tar.gz

wget -O robots.xml http://kde-files.org/CONTENT/content-files/124969-robots.xml
mv ./robots.xml /usr/share/apps/katepart/syntax/

mkdir ./audiothumbs
cd ./audiothumbs
wget -O AudioThumbs-0.2.tar.gz http://kde-apps.org/CONTENT/content-files/145088-AudioThumbs-0.2.tar.gz
tar zxvf ./AudioThumbs-0.2.tar.gz
mkdir ./build
cd ./build
cmake -DCMAKE_INSTALL_PREFIX=`kde4-config --prefix` ..
make
make install
rm ./AudioThumbs-0.2.tar.gz
rm -r ./audiothumbs
cd /home/$UTENTE/Desktop

wget -O ofwvlc.tar.gz http://kde-apps.org/CONTENT/content-files/146621-ofwvlc-0.3.tar.gz
tar zxvf ./ofwvlc.tar.gz
cd ./ofwvlc; cp vlc.desktop /usr/share/kde4/services/ServiceMenus/
cd it; cp ofwvlc /usr/sbin
chmod +x /usr/sbin/ofwvlc /usr/share/kde4/services/ServiceMenus/vlc.desktop
cd /home/$UTENTE/Desktop
rm ./ofwvlc.tar.gz
rm -r ./ofwvlc

wget -O kate-folder-service-menu.tar.gz http://kate-folder-service-menu.googlecode.com/files/kate-folder-service-menu0.2.tar.gz
tar zxvf ./kate-folder-service-menu.tar.gz
cd ./kate-folder-service-menu
./install
cd /home/$UTENTE/Desktop
rm ./kate-folder-service-menu.tar.gz
rm -r ./kate-folder-service-menu

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

wget -O filezilla-theme.tar.gz http://kde-look.org/CONTENT/content-files/141546-filezilla-oxygen-theme.tar.gz
tar zxvf ./filezilla-theme.tar.gz
mv ./oxygen /usr/share/filezilla/resources/oxygen
rm ./filezilla-theme.tar.gz

wget http://dl.dropbox.com/u/17620616/linki/Oxywine_3.1.msstyles
mkdir /home/$UTENTE/.wine/drive_c/windows/Resources
mkdir /home/$UTENTE/.wine/drive_c/windows/Resources/Themes
mkdir /home/$UTENTE/.wine/drive_c/windows/Resources/Themes/Oxywine_3.1
chmod -R 777 /home/$UTENTE/.wine/drive_c/windows/Resources
mv ./Oxywine_3.1.msstyles /home/$UTENTE/.wine/drive_c/windows/Resources/Themes/Oxywine_3.1

wget -O gimp-refresh.zip http://kde-look.org/CONTENT/content-files/141457-GIMP-Refresh%200.1.zip
unzip ./gimp-refresh.zip
mv ./GIMP-Refresh /usr/share/gimp/2.0/theme/GIMP-Refresh
rm -r ./GIMP-Refresh
rm ./gimp-refresh.zip

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
wget http://webupd8.googlecode.com/files/install-google-fonts
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
cd /home/$UTENTE/Desktop

echo "
installo Grub2 KCM"
wget http://ppa.launchpad.net/eu-andreduartesp/ppa/ubuntu/pool/main/k/kcmgrub2/kde-config-grub_1.1-ubuntu2_amd64.deb
dpkg -i ./kde-config-grub_1.1-ubuntu2_amd64.deb
rm ./kde-config-grub_1.1-ubuntu2_amd64.deb

echo "
installo GTK Config KCM"
wget http://chakra-project.org/sources/gtk-integration/chakra-gtk-config-1.7.tar.gz
tar zxvf ./chakra-gtk-config-1.7.tar.gz
cd ./chakra-gtk-config-1.77
mkdir build && cd build
cmake ..
make && make install
cd /home/$UTENTE/Desktop
rm ./chakra-gtk-config-1.7.tar.gz
rm -r ./chakra-gtk-config-1.7

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
wget -O svgcleaner.tar.gz https://github.com/RazrFalcon/SVGCleaner/tarball/master
tar zxvf ./svgcleaner.tar.gz
cd ./RazrFalcon-SVGCleaner-91a759a
qmake
make && make install
cd /home/$UTENTE/Desktop
rm ./svgcleaner.tar.gz
rm -r ./RazrFalcon-SVGCleaner-5069fce

echo "
installo Krep"
wget http://www.staerk.de/files/krep.tar.gz
tar zxvf ./krep.tar.gz
cd krep
cmake . && make && make install
cd /home/$UTENTE/Desktop
rm ./krep.tar.gz
rm -r ./krep

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
wget http://sourceforge.net/projects/converseen/files/Converseen/Converseen%200.4/0.4.9/converseen-0.4.9.tar.bz2/download
tar jxvf ./converseen-0.4.9.tar.bz2
cd ./converseen-0.4.9
qmake && make && make install
cd /home/$UTENTE/Desktop
rm ./converseen-0.4.9.tar.bz2
rm -r ./converseen-0.4.9

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
wget http://ignum.dl.sourceforge.net/project/gmic/gmic_gimp_linux64.zip
unzip ./gmic_gimp_linux64.zip
mv ./gmic_gimp /usr/lib/gimp/2.0/plug-ins/
rm ./gmic_gimp_linux64.zip
rm ./README

echo "
installo la cagata di Skype"
wget -O skype-install.deb http://www.skype.com/go/getskype-linux-deb-64
dpkg -i ./skype-install.deb
rm ./skype-install.deb

echo "
Installiamo Orta come tema per GTK"
wget http://www.deviantart.com/download/184118297/orta_by_skiesofazel-d31mal5.zip
unzip ./orta_by_skiesofazel-d31mal5.zip
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
cd build && make && make install
cd /home/$UTENTE/Desktop

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
wget http://www.brother.com/pub/bsc/linux/dlf/mfc620cnlpr-1.0.2-1.i386.deb
wget http://www.brother.com/pub/bsc/linux/dlf/cupswrapperMFC620CN-1.0.2-3.i386.deb
dpkg -i --force-architecture ./mfc620cnlpr-1.0.2-1.i386.deb
dpkg -i --force-architecture ./cupswrapperMFC620CN-1.0.2-3.i386.deb
#file fixato per i margini
wget http://dl.dropbox.com/u/21763079/MFC620CN.ppd
mv ./MFC620CN.ppd /etc/cups/ppd/MFC620CN.ppd
rm ./mfc620cnlpr-1.0.2-1.i386.deb
rm ./cupswrapperMFC620CN-1.0.2-3.i386.deb

echo "Download HotKeys"
wget -O preset.hotkeys http://kde-look.org/CONTENT/content-files/148793-preset.khotkeys

su $UTENTE -c "kcmshell4 khotkeys"

echo "
Avvio Bum"
bum

echo "
Configura Bespin"

su $UTENTE -c "bespin config"

echo "
Carico la configurazione di Samba"
wget http://dl.dropbox.com/u/21763079/smb.conf
mv ./smb.conf /etc/samba/smb.conf

echo "
Carico la configurazione di Konversation"
su $UTENTE -c "konversation"
wget http://dl.dropbox.com/u/21763079/konversationrc
mv ./konversationrc /home/mte90/.kde/share/config/konversationrc

echo "
Carico la configurazione di Kate"
su $UTENTE -c "kate"
wget http://dl.dropbox.com/u/21763079/katerc
mv ./katerc /home/mte90/.kde/share/config/katerc

echo "
Carico la configurazione di Choqok"
su $UTENTE -c "kate"
wget http://dl.dropbox.com/u/21763079/choqokrc
mv ./choqokrc /home/mte90/.kde/share/config/choqokrc

echo "
Imposto Yakuake all'avvio"
wget http://dl.dropbox.com/u/21763079/Yakuake.desktop
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
//webl library
user_pref("webgl.osmesalib", "/usr/lib/x86_64-linux-gnu/libOSMesa.so.6");
//homepage
user_pref("browser.startup.homepage", "http://www.mte90.net");
user_pref("network.dns.disableIPv6", false);
user_pref("http.proxy.pipelining", true);
user_pref("network.http.pipelining", true);
user_pref("network.http.pipelining.maxrequests", 8);
user_pref("content.switch.threshold", 250000);
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
cp /home/mte90/.kde/share/config/kdeglobals /home/mte90/.kde/share/config/_kdeglobals
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
wget http://ignum.dl.sourceforge.net/project/gmic/gmic_gimp_linux64.zip
unzip ./gmic_gimp_linux64.zip
mv ./gmic_gimp /usr/lib/gimp/2.0/plug-ins/
rm ./gmic_gimp_linux64.zip
rm ./README
'
> /home/$UTENTE/gmic.sh

chmod +x /home/$UTENTE/gmic.sh