#!/bin/bash
sudo apt-get install ffmpeg
sudo add-apt-repository ppa:obsproject/obs-studio
sudo apt update
sudo apt-get update && sudo apt-get install obs-studio
sudo apt-get install -y wget tar
mkdir -p tmp && cd tmp
wget https://github.com/DistroAV/DistroAV/releases/download/6.0.0/distroav-6.0.0-x86_64-linux-gnu.deb
sudo dpkg -i distroav-6.0.0-x86_64-linux-gnu.deb
rm -rf distroav-6.0.0-x86_64-linux-gnu.deb
wget https://downloads.ndi.tv/SDK/NDI_SDK_Linux/Install_NDI_SDK_v6_Linux.tar.gz
tar xvf Install_NDI_SDK_v6_Linux.tar.gz 
rm -rf Install_NDI_SDK_v6_Linux.tar.gz 
echo "y" | PAGER="cat" bash Install_NDI_SDK_v6_Linux.sh
rm -rf Install_NDI_SDK_v6_Linux.sh 
sudo cp NDI\ SDK\ for\ Linux/lib/x86_64-linux-gnu/* /usr/local/lib/
sudo ln -s /usr/local/lib/libndi.so.6 /usr/local/lib/libndi.so.5
ls -la /usr/local/lib/libndi*
mkdir -p ~/.ndi
cat <<EOF > ~/.ndi/ndi-config.v1.json
{
  "ndi" : {
    "rudp" : {
      "recv" : {
        "enable" : true
      }
    },
    "tcp" : {
      "recv" : {
        "enable" : false
      }
    },
    "networks" : {
      "ips" : "",
      "discovery" : ""
    },
    "groups" : {
      "recv" : "public",
      "send" : "public"
    },
    "multicast" : {
      "send" : {
        "enable" : false,
        "netprefix" : "239.255.0.0",
        "netmask" : "255.255.0.0"
      }
    },
    "unicast" : {
      "recv" : {
        "enable" : true
      }
    }
  }
}
EOF
sudo apt install avahi-daemon
sudo systemctl enable avahi-daemon
sudo systemctl start avahi-daemon
wget https://github.com/WarmUpTill/SceneSwitcher/releases/download/1.27.2/advanced-scene-switcher-1.27.2-x86_64-linux-gnu.tar.xz
tar Jxvf advanced-scene-switcher-1.27.2-x86_64-linux-gnu.tar.xz
sudo cp -r lib/x86_64-linux-gnu/obs-plugins/* /lib/x86_64-linux-gnu/obs-plugins/
sudo cp -r share/obs/obs-plugins/advanced-scene-switcher /usr/share/obs/obs-plugins/
sudo rm /lib/x86_64-linux-gnu/obs-plugins/advanced-scene-switcher-plugins/advanced-scene-switcher-opencv.so
sudo rm /lib/x86_64-linux-gnu/obs-plugins/advanced-scene-switcher-plugins/advanced-scene-switcher-twitch.so
sudo apt-get update && sudo apt-get install libxss-dev libxtst-dev
cd .. && rm -rf tmp