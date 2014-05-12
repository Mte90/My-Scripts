#!/bin/bash

echo "Preparatore per Aptosid 1.7 by Mte90 - www.mte90.net"

UTENTE="mte90"
cd /home/$UTENTE/Desktop

echo "Aggiunta Repo"
echo "
deb http://mozilla.debian.net/ experimental iceweasel-aurora
deb http://download.webmin.com/download/repository/ sarge contrib
deb http://debian.fastweb.it/debian/ experimental main contrib non-free
deb http://download.opensuse.org/repositories/isv:ownCloud:devel/Debian_7.0/ /
deb http://mirror.cc.columbia.edu/debian/ squeeze main
" >> /etc/apt/sources.list

mkdir install_
cd ./install_

wget http://www.webmin.com/jcameron-key.asc
apt-key add jcameron-key.asc
wget http://download.opensuse.org/repositories/isv:ownCloud:devel/Debian_7.0/Release.key
apt-key add ./Release.key

echo "Fix & tips"

sed -i -e 's/#GRUB_TERMINAL/GRUB_TERMINAL/g' /etc/default/grub
echo 'CONCURRENCY=makefile' >> /etc/default/rcS

#fix per avvio gui da root in console
echo "
export XAUTHORITY=/home/$UTENTE/.Xauthority
export \$(dbus-launch)

alias ls='ls --color=auto'
alias update='apt update'
alias upgrade='apt upgrade'
alias aptforce='apt -o Dpkg::Options::="--force-overwrite" install'
alias search='apt-cache search'
alias policy='apt-cache policy'
alias deb64='dpkg --force-architecture -i'
alias apts='(kate /etc/apt/sources.list &)'
alias casa='cd /home/$UTENTE/Desktop'
alias www='cd /var/www'
alias ex='unp'
function exr() { unp \$1 ; rm \$1;}

echo -e '\e[1;31m';
echo \"  ______  _____   _____  _______\";
echo \" |_____/ |     | |     |    |\";
echo \" |    \_ |_____| |_____|    |\";
echo -e '\e[m';
" >> /root/.bashrc

echo "
alias casa='cd /home/$UTENTE/Desktop'
alias www='cd /var/www'
alias ex='unp'
alias yt2mp3='youtube-dl -l --extract-audio --audio-format=mp3 -w -c'
" >> /home/$UTENTE/.bashrc

echo "Caricamento Alias"
. /root/.bashrc

dpkg-reconfigure locales

echo "Aggiornamento ed installazione programmi"
apt-get update
apt-get remove kde-l10n-de kaffeine install-usb-gui gparted bluez bluez-pcmcia-support
dpkg --add-architecture i386
apt-get -y install kde-l10n-it pkg-mozilla-archive-keyring
apt-get upgrade
#Librerie KDE
apt-get -y install kdelibs5-dev kde-workspace-dev python-kde4 python-qt4 libqt4-core libqt4-gui python3-pyqt4 appmenu-qt kdepim-groupware kdepim-kresources kdepim-wizards
apt-get -y install libattica0.4 libattica-dev libcups2-dev libqjson0 libqjson-dev libqtwebkit-dev libgpgme11-dev qt4-qmake xsltproc samba
apt-get -y install plasma-scriptengine-python plasma-scriptengine-javascript plasma-widgets-workspace plasma-widgets-addons  kdegraphics-strigi-plugins
apt-get -y install python-mlt4 libmlt++4 libmlt5 libktpcommoninternalsprivate-dev virtuoso-minimal strigi-client kio-ftps kde-thumbnailer-deb kdelibs5-plugins
apt-get -y install svgpart software-properties-kde konq-plugins ksaneplugin kdesrc-build kde-sc-dev-latest kde-notification-colibri
#Librerie
apt-get -y install cmake cmake-curses-gui libtool libtag-extras-dev libflac++-dev libtag1-dev libavutil51 libflac++-dev libxml-twig-perl libtag1-dev csh
apt-get -y install libx11-dev libxfixes-dev libxrender-dev mesa-common-dev libsdl1.2-dev libpcap0.8-dev libgraphicsmagick++3 libhighgui2.3 libraw1394-11 libdc1394-22
apt-get -y install intltool libwnck-dev libnoise-dev libgsl0-dev libfftw3-dev libgif-dev libmagick++-dev libgl1-mesa-dev gettext libosmesa6 extra-xdg-menus
#Multimedia
apt-get -y install vlc audacity soundkonverter kdenlive kid3 openshot transmageddon mediainfo lame libid3-tools melt transcode phonon-backend-vlc mplayerthumbs eyed3 blender
apt-get -y install vokoscreen ugvcview q4vl2 youtube-dl
apt-get -y install gstreamer0.10-alsa gstreamer0.10-ffmpeg gstreamer0.10-fluendo-mp3 gstreamer0.10-plugins-base libgstreamer-plugins-base0.10-0 libgstreamer0.10-0 libgstreamer0.10-dev gstreamer0.10-plugins-good gstreamer0.10-plugins-ugly gstreamer0.10-plugins-bad gstreamer0.10-tools
#Grafica
apt-get -y install gimp gimp-data-extras gimp-plugin-registry trimage kcolorchooser kruler inkscape kipi-plugins imagemagick create-resources python-uniconvertor
#Internet
apt-get -y install amule amule-daemon amule-utils plasma-widget-amule qtransimssion icedove icedove-l10n-it akregator kget kde-telepathy
#Ufficio
apt-get -y install libreoffice-writer libreoffice-l10n-it libreoffice-kde libreoffice-impress libreoffice-calc libreoffice-draw tellico okular-extra-backends retext
#Mozilla/Chromium :-(
apt-get -y install -t experimental iceweasel iceweasel-l10n-it
apt-get -y install myspell-it mozilla-libreoffice mozplugger chromium mozilla-plugin-vlc
#Sistema
apt-get -y install update-notifier-kde kde-config-gtk-style apt-rdepends webmin imwheel gtk3-engines-oxygen gtk2-engines-pixbuf gtk2-engines-oxygen bum acetoneiso
#Programmazione
apt-get -y install lokalize kompare php5-cli qtcreator php5 php5-gd apache2 mysql-server phpmyadmin kate node-less ohcount spyder poedit
#KDE Tools
apt-get -y install kdenetwork kde-config-cron kfilereplace kdeutils kscreensaver kdepim-runtime kuser ksystemlog virtualbox virtualbox-ose-qt virtualbox-dkms yakuake kmenuedit
#Tools
apt-get -y install gprename preload gksu partitionmanager ruby rubygems gdb subversion git mercurial openjdk-7-jre localepurge kdesudo owncloud-client exfat-fuse exfat-utils
#Font
apt-get -y install ttf-mscorefonts-installer ttf-droid ttf-dejavu ttf-freefont ttf-bitstream-vera ttf-freefont ttf-linux-libertine ttf-inconsolata
#Non-Free
apt-get -y install firmware-linux-nonfree unrar flashplugin-nonfree
#Pacchetti i386
apt-get install libpulse0:i386 libqtwebkit4:i386 libqtgui4:i386 libqtcore4:i386 libqt4-xml:i386 libqt4-dbus:i386 libqt4-network:i386
apt-get clean

echo "Fix"
modprobe vboxdrv
modprobe vboxnetflt
a2enmod rewrite
localepurge
git config --global core.editor "vim"

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
wget -O Actos_SoundMenu.plasmoid https://github.com/ghinda/actos-soundmenu/archive/master.zip
plasmapkg -i ./Actos_SoundMenu.plasmoid

wget -O plasma-simpleMonitor.plasmoid http://kde-apps.org/CONTENT/content-files/162541-plasma-simpleMonitor-0.4.plasmoid
plasmapkg -i ./plasma-simpleMonitor.plasmoid

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
exr ./amuleKollection-0.4.tar.gz
cd ./amuleKollection-0.4 && ./install.sh
cd ../

wget -O robots.xml http://kde-files.org/CONTENT/content-files/124969-robots.xml
mkdir /usr/share/apps/katepart
mkdir /usr/share/apps/katepart/syntax
mv ./robots.xml /usr/share/apps/katepart/syntax/
wget http://dl.dropbox.com/u/21763079/zen.js
mkdir /usr/share/apps/katepart/script
mv ./zen.js /usr/share/apps/katepart/script

mkdir ./audiothumbs && cd ./audiothumbs
wget -O AudioThumbs-0.2.tar.gz http://kde-apps.org/CONTENT/content-files/145088-AudioThumbs-0.2.tar.gz
exr ./AudioThumbs-0.2.tar.gz
mkdir ./build && cd ./build
cmake -DCMAKE_INSTALL_PREFIX=`kde4-config --prefix` ..
make && make install
cd ../../

wget -O ofwvlc.tar.gz http://kde-apps.org/CONTENT/content-files/146621-ofwvlc-0.3.tar.gz
exr ./ofwvlc.tar.gz
cd ./ofwvlc; cp vlc.desktop /usr/share/kde4/services/ServiceMenus/
cd it; cp ofwvlc /usr/sbin
chmod +x /usr/sbin/ofwvlc /usr/share/kde4/services/ServiceMenus/vlc.desktop
vim /usr/share/kde4/services/ServiceMenus/vlc.desktop
cd ../../

wget -O kate-folder-service-menu.tar.gz http://kate-folder-service-menu.googlecode.com/files/kate-folder-service-menu0.2.tar.gz
exr ./kate-folder-service-menu.tar.gz
cd ./kate-folder-service-menu
./install
cd ../

echo "
Avvio Gimp per inizializzarlo!"

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
Kdeizziamo  Gimp"

wget -O gimp.tar.gz http://downloads.sourceforge.net/project/chakra/Tools/Gimp-Oxygen/Gimp-Oxygen-0.1.tar.gz
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
wget http://webupd8.googlecode.com/files/install-google-fonts
chmod +x install-google-fonts
echo "Intanto devi settare Gimp e Wine per usare i temi scaricati."

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
wget http://anongit.kde.org/kcmgrub2/kcmgrub2-latest.tar.gz
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
wget -O svgcleaner.tar.gz https://github.com/RazrFalcon/SVGCleaner/tarball/master
exr ./svgcleaner.tar.gz
cd ./`tar tzf svgcleaner.tar.gz | head -1`
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
wget "http://sourceforge.net/projects/converseen/files/Converseen/Converseen%200.7/converseen-0.7.tar.bz2/download" -O converseen.tar.bz2
exr ./converseen.tar.bz2
cd ./converseen
mkdir build && cd build
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
Installo Wp-Cli"
curl https://raw.github.com/wp-cli/wp-cli.github.com/master/installer.sh | bash
source $HOME/.wp-cli/vendor/wp-cli/wp-cli/utils/wp-completion.bash

echo "
Installo Wordmove"
gem install wordmove

echo "
Installo GruntJS"
npm install -g grunt-cli

echo "
installo la cagata di Skype"
wget -O skype-install.deb http://www.skype.com/go/getskype-linux-deb
dpkg -i ./skype-install.deb

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

echo "Download HotKeys"
wget -O preset.hotkeys http://kde-look.org/CONTENT/content-files/148793-preset.khotkeys

su $UTENTE -c "dbus-launch kcmshell4 khotkeys"

echo "
Avvio Bum"
bum

echo "
Carico la configurazione di Samba"
wget http://dl.dropbox.com/u/21763079/smb.conf
mv ./smb.conf /etc/samba/smb.conf

echo "
Carico la configurazione di Konversation"
su $UTENTE -c "dbus-launch konversation"
wget http://dl.dropbox.com/u/21763079/konversationrc
mv ./konversationrc /home/$UTENTE/.kde/share/config/konversationrc
chmod -R 777 /home/$UTENTE/.kde/share/config/konversationrc

echo "
Carico la configurazione di Kate"
su $UTENTE -c "dbus-launch kate"
wget http://dl.dropbox.com/u/21763079/katerc
mv ./katerc /home/$UTENTE/.kde/share/config/katerc
chmod -R 777 /home/$UTENTE/.kde/share/config/katerc

echo "
Imposto Yakuake all'avvio"
wget http://dl.dropbox.com/u/21763079/Yakuake.desktop
cp ./Yakuake.desktop /home/$UTENTE/.config/autostart/Yakuake.desktop

echo "
Configuro Firefox"
ff_path=`grep Path /home/$UTENTE/firefox/profiles.ini | sed "s/Path=//g"`
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
user_pref("spellchecker.dictionary", "it_IT");
' > ./user.js
chmod -R 777 ./user.js

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

echo "Trash.sh - Svuota il cestino, utile quando ci sono file con permessi sbagliati"
echo '
#!/bin/bash
rm -rfvI ~/.local/share/Trash/files/
rm -rfvI ~/.local/share/Trash/info/
'> /home/$UTENTE/trash.sh

chmod +x /home/$UTENTE/trash.sh

echo "Gmic.sh - Aggiornare Gmic"
echo '
#!/bin/bash
wget http://downloads.sourceforge.net/gmic/gmic_gimp_linux64.zip
unzip ./gmic_gimp_linux64.zip
mv ./gmic_gimp /usr/lib/gimp/2.0/plug-ins/
rm ./gmic_gimp_linux64.zip
rm ./README
'> /home/$UTENTE/gmic.sh

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
wget http://gimp-tutorials.net/files/130-UltimateWeb2-0-Gradients-for-Gimp.zip
exr ./130-UltimateWeb2-0-Gradients-for-Gimp.zip
wget http://www.deviantart.com/download/244975649/30_gimp_gradients_by_frostbo-d41uof5.zip
exr ./30_gimp_gradients_by_frostbo-d41uof5.zip
mv './Gimp Gradient pack 30 by frost/*' /usr/share/gimp/2.0/gradients/
wget http://gps-gimp-paint-studio.googlecode.com/files/GPS%201_5_final%20release.zip
exr './GPS 1_5_final release.zip'
cd ./brushes
wget http://www.deviantart.com/download/124578466/3D_Gimp_Brush_set_by_DimondDoves.zip
exr 3D_Gimp_Brush_set_by_DimondDoves.zip
cd ../
mv gradients/* /usr/share/gimp/2.0/gradients/
mv brushes/* /usr/share/gimp/2.0/brushes/
mv patterns/* /usr/share/gimp/2.0/patterns/
mv palettes/* /usr/share/gimp/2.0/palettes/
mv tool-options/* /home/$UTENTE/.gimp-2.8/tool-options/

echo "Gimp - Scripts"
mkdir ./scripts
cd ./scripts
wget http://www.deviantart.com/download/30316704/GLASS_SCRIPT_FU_runs_on_2_4_by_kward1979uk.scm
wget http://shallowsky.com/software/pandora/pandora-combine-0.9.3.scm
wget http://registry.gimp.org/files/layers-slices_1.scm
wget http://www.deviantart.com/download/74282791/Retro_Background_Script_by_fence_post.scm
wget http://www.deviantart.com/download/77556760/GIMP_2_6_and_2_4_Satin_Script_by_fence_post.zip
wget http://www.deviantart.com/download/123319582/Electronic_GIMP_Script_by_mikethedj4.scm
wget http://www.deviantart.com/download/71646868/Add_Border_Script_by_Insanity_Prevails.scm
wget http://www.deviantart.com/download/273071819/gimp_script___fit_all_layers_to_image_size_by_elheartista-d4ikvkb.zip
exr ./GIMP_2_6_and_2_4_Satin_Script_by_fence_post.zip
exr ./gimp_script___fit_all_layers_to_image_size_by_elheartista-d4ikvkb.zip
rm ./GIMP_2_6_and_2_4_Satin_Script_by_fence_post.zip
rm ./gimp_script___fit_all_layers_to_image_size_by_elheartista-d4ikvkb.zip
cd ../
mv scripts/* /usr/share/gimp/2.0/scripts

echo "Gimp - Plugin"
wget http://files.myopera.com/area42/files/cssdev.py
chmod +x ./cssdev.py
mv ./cssdev.py /usr/lib/gimp/2.0/plug-ins/
wget http://registry.gimp.org/files/gimp-plugin-toy-1.0.4.tar.gz
exr ./gimp-plugin-toy-1.0.4.tar.gz
cd ./gimp-plugin-toy-1.0.4
./configure
make && make install
cd ../
wget -O resynth.tar.gz https://github.com/bootchk/resynthesizer/tarball/master
exr ./resynth.tar.gz
cd `tar tzf resynth.tar.gz | head -1`
./autogen.sh
make -j16 && make install

echo "Rimozione file scaricati"
cd /home/$UTENTE/Desktop/
rm -r ./install_

kdesudo $UTENTE -c "kdebugdialog"

echo "Permessi in scrittura per var/www"
chmod -R 777 /var/www

echo "Scaricamento wallpaper"
#sfondi
cd ../Documents
curl --header 'Host: it.owncube.com' --header 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:20.0) Gecko/20130118 Firefox/20.0 Iceweasel/20.0a2' --header 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' --header 'Accept-Language: it,en-us;q=0.7,en;q=0.3' --header 'Accept-Encoding: gzip, deflate' --header 'DNT: 1' --header 'Content-Type: application/x-www-form-urlencoded' --header 'Cookie: 507d17dbcc303=9aq9e6clng66d6tuu5ine3l3m4' 'https://it.owncube.com/public.php?service=files&t=b7ac59dcfc568ea09a0297b1e02c918b&download' -O -J -L
unzip ./sfondi.zip ./



echo "Installazione finita"
