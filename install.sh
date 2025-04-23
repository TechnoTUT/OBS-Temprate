#!/bin/bash
DISTROAV_VERSION=6.0.0
SCENE_SWITCHER_VERSION=1.29.3

sudo add-apt-repository ppa:ubuntuhandbook1/ffmpeg7
sudo apt-get update -y
sudo apt-get install -y ffmpeg
sudo add-apt-repository ppa:obsproject/obs-studio
sudo apt-get update -y && sudo apt-get install -y obs-studio
sudo apt-get install -y wget tar
mkdir -p tmp && cd tmp
wget https://github.com/DistroAV/DistroAV/releases/download/${DISTROAV_VERSION}/distroav-${DISTROAV_VERSION}-x86_64-linux-gnu.deb
sudo dpkg -i distroav-${DISTROAV_VERSION}-x86_64-linux-gnu.deb
rm -rf distroav-${DISTROAV_VERSION}-x86_64-linux-gnu.deb
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
sudo systemctl enable --now avahi-daemon
wget https://github.com/WarmUpTill/SceneSwitcher/releases/download/${SCENE_SWITCHER_VERSION}/advanced-scene-switcher-${SCENE_SWITCHER_VERSION}-x86_64-linux-gnu.tar.xz
tar Jxvf advanced-scene-switcher-${SCENE_SWITCHER_VERSION}-x86_64-linux-gnu.tar.xz
sudo cp -r lib/x86_64-linux-gnu/obs-plugins/* /lib/x86_64-linux-gnu/obs-plugins/
sudo cp -r share/obs/obs-plugins/advanced-scene-switcher /usr/share/obs/obs-plugins/
sudo rm /lib/x86_64-linux-gnu/obs-plugins/advanced-scene-switcher-plugins/advanced-scene-switcher-opencv.so
sudo rm /lib/x86_64-linux-gnu/obs-plugins/advanced-scene-switcher-plugins/advanced-scene-switcher-twitch.so
sudo apt-get update -y && sudo apt-get install -y libxss-dev libxtst-dev
cd .. && rm -rf tmp