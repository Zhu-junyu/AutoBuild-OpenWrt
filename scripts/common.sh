#!/bin/bash

# 移除重复package
find . -iname "*advanced*" | xargs rm -rf
find . -iname "*aliyundrive*" | xargs rm -rf
find . -iname "*amlogic*" | xargs rm -rf
find . -iname "*autotimeset*" | xargs rm -rf
find . -iname "*ddnsto*" | xargs rm -rf
find . -iname "*dnsproxy*" | xargs rm -rf
find . -iname "*dockerman*" | xargs rm -rf
find . -iname "*eqos*" | xargs rm -rf
find . -iname "*minidlna*" | xargs rm -rf
find . -iname "*music*" | xargs rm -rf
find . -iname "*netdata*" | xargs rm -rf
find . -iname "*onliner*" | xargs rm -rf
find . -iname "*openclash*" | xargs rm -rf
find . -iname "*pushbot*" | xargs rm -rf
find . -iname "*serverchan*" | xargs rm -rf
find . -iname "*speedtest*" | xargs rm -rf
find . -iname "*turboacc*" | xargs rm -rf
find . -iname "*verysync*" | xargs rm -rf
find . -iname "*wrtbwmon*" | xargs rm -rf

# 添加package
git clone https://github.com/kenzok8/openwrt-packages package/kenzok-package
git clone https://github.com/kenzok8/small-package package/small-package
cp -rf package/kenzok-package/* package && rm -rf package/kenzok-package
cp -rf package/small-package/* package && rm -rf package/small-package
svn co https://github.com/coolsnowwolf/luci/trunk/applications/luci-app-minidlna package/luci-app-minidlna
svn co https://github.com/coolsnowwolf/packages/trunk/multimedia/minidlna package/minidlna
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-turboacc package/luci-app-turboacc
svn co https://github.com/kiddin9/openwrt-packages/trunk/netdata package/netdata

# 移除无用package
find . -iname "*adguardhome*" | xargs rm -rf
find . -iname "*bypass*" | xargs rm -rf
find . -iname "*passwall*" | xargs rm -rf
find . -iname "*shadowsocks*" | xargs rm -rf
find . -iname "*ssr*" | xargs rm -rf
find . -iname "*trojan*" | xargs rm -rf
find . -iname "*v2ray*" | xargs rm -rf
find . -iname "*vssr*" | xargs rm -rf
find . -iname "*wizard*" | xargs rm -rf
find . -iname "*xray*" | xargs rm -rf

# Themes
find . -iname "*argon*" | xargs rm -rf
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
git clone https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config

# 修改默认shell为zsh
# sed -i 's/\/bin\/ash/\/usr\/bin\/zsh/g' package/base-files/files/etc/passwd

# samba登录root
sed -i 's/invalid users = root/#&/g' feeds/packages/net/samba4/files/smb.conf.template

# ttyd自动登录
sed -i "s?/bin/login?/usr/libexec/login.sh?g" feeds/packages/utils/ttyd/files/ttyd.config

# amlogic
sed -i "s|https.*/OpenWrt|https://github.com/v8040/AutoBuild-OpenWrt|g" package/luci-app-amlogic/root/etc/config/amlogic
sed -i "s|opt/kernel|https://github.com/ophub/kernel/tree/main/pub/stable|g" package/luci-app-amlogic/root/etc/config/amlogic
sed -i "s|ARMv8|ARMv8_N1|g" package/luci-app-amlogic/root/etc/config/amlogic

# unblockneteasemusic
NAME=$"package/luci-app-unblockneteasemusic/root/usr/share/unblockneteasemusic" && mkdir -p $NAME/core
curl 'https://api.github.com/repos/UnblockNeteaseMusic/server/commits?sha=enhanced&path=precompiled' -o commits.json
echo "$(grep sha commits.json | sed -n "1,1p" | cut -c 13-52)">"$NAME/core_local_ver"
curl -L https://github.com/UnblockNeteaseMusic/server/raw/enhanced/precompiled/app.js -o $NAME/core/app.js
curl -L https://github.com/UnblockNeteaseMusic/server/raw/enhanced/precompiled/bridge.js -o $NAME/core/bridge.js
curl -L https://github.com/UnblockNeteaseMusic/server/raw/enhanced/ca.crt -o $NAME/core/ca.crt
curl -L https://github.com/UnblockNeteaseMusic/server/raw/enhanced/server.crt -o $NAME/core/server.crt
curl -L https://github.com/UnblockNeteaseMusic/server/raw/enhanced/server.key -o $NAME/core/server.key

# 科学上网openclash
# 编译 po2lmo (如果有po2lmo可跳过)
# pushd package/luci-app-openclash/tools/po2lmo
# make && sudo make install
# popd

# 修改makefile
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/include\ \.\.\/\.\.\/luci\.mk/include \$(TOPDIR)\/feeds\/luci\/luci\.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/include\ \.\.\/\.\.\/lang\/golang\/golang\-package\.mk/include \$(TOPDIR)\/feeds\/packages\/lang\/golang\/golang\-package\.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=\@GHREPO/PKG_SOURCE_URL:=https:\/\/github\.com/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=\@GHCODELOAD/PKG_SOURCE_URL:=https:\/\/codeload\.github\.com/g' {}

# 调整菜单
sed -i 's/network/control/g' feeds/luci/applications/luci-app-sqm/luasrc/controller/*.lua
sed -i 's/network/control/g' package/luci-app-eqos/luasrc/controller/*.lua
sed -i 's/services/nas/g' package/luci-app-aliyundrive-fuse/luasrc/controller/*.lua
sed -i 's/services/nas/g' package/luci-app-aliyundrive-fuse/luasrc/model/cbi/aliyundrive-fuse/*.lua
sed -i 's/services/nas/g' package/luci-app-aliyundrive-fuse/luasrc/view/aliyundrive-fuse/*.htm
sed -i 's/services/nas/g' package/luci-app-minidlna/luasrc/controller/*.lua
sed -i 's/services/nas/g' package/luci-app-minidlna/luasrc/view/*.htm
sed -i 's/services/vpn/g' package/luci-app-openclash/luasrc/*.lua
sed -i 's/services/vpn/g' package/luci-app-openclash/luasrc/controller/*.lua
sed -i 's/services/vpn/g' package/luci-app-openclash/luasrc/model/cbi/openclash/*.lua
sed -i 's/services/vpn/g' package/luci-app-openclash/luasrc/view/openclash/*.htm

# 修改插件名字
sed -i 's/"Argon 主题设置"/"主题设置"/g' `grep "Argon 主题设置" -rl ./`
sed -i 's/"Aria2 配置"/"Aria2下载"/g' `grep "Aria2 配置" -rl ./`
sed -i 's/"ChinaDNS-NG"/"ChinaDNS"/g' `grep "ChinaDNS-NG" -rl ./`
sed -i 's/"DDNSTO 远程控制"/"DDNSTO"/g' `grep "DDNSTO 远程控制" -rl ./`
sed -i 's/"KMS 服务器"/"KMS激活"/g' `grep "KMS 服务器" -rl ./`
sed -i 's/"NFS 管理"/"NFS管理"/g' `grep "NFS 管理" -rl ./`
sed -i 's/"Rclone"/"网盘挂载"/g' `grep "Rclone" -rl ./`
sed -i 's/"SQM QoS"/"流量控制"/g' `grep "SQM QoS" -rl ./`
sed -i 's/"SoftEther VPN 服务器"/"SoftEther"/g' `grep "SoftEther VPN 服务器" -rl ./`
sed -i 's/"TTYD 终端"/"网页终端"/g' `grep "TTYD 终端" -rl ./`
sed -i 's/"Turbo ACC 网络加速"/"网络加速"/g' `grep "Turbo ACC 网络加速" -rl ./`
sed -i 's/"UPnP"/"UPnP服务"/g' `grep "UPnP" -rl ./`
sed -i 's/"USB 打印服务器"/"USB打印"/g' `grep "USB 打印服务器" -rl ./`
sed -i 's/"Web 管理"/"Web"/g' `grep "Web 管理" -rl ./`
sed -i 's/"WireGuard 状态"/"WiGd状态"/g' `grep "WireGuard 状态" -rl ./`
sed -i 's/"iKoolProxy 滤广告"/"广告过滤"/g' `grep "iKoolProxy 滤广告" -rl ./`
sed -i 's/"miniDLNA"/"DLNA服务"/g' `grep "miniDLNA" -rl ./`
sed -i 's/"上网时间控制"/"上网控制"/g' `grep "上网时间控制" -rl ./`
sed -i 's/"动态 DNS"/"动态DNS"/g' `grep "动态 DNS" -rl ./`
sed -i 's/"带宽监控"/"监控"/g' `grep "带宽监控" -rl ./`
sed -i 's/"挂载 SMB 网络共享"/"挂载共享"/g' `grep "挂载 SMB 网络共享" -rl ./`
sed -i 's/"易有云文件管理器"/"易有云"/g' `grep "易有云文件管理器" -rl ./`
sed -i 's/"网络存储"/"存储"/g' `grep "网络存储" -rl ./`
sed -i 's/"解除网易云音乐播放限制"/"音乐解锁"/g' `grep "解除网易云音乐播放限制" -rl ./`
sed -i 's/"阿里云盘 FUSE"/"阿里云盘"/g' `grep "阿里云盘 FUSE" -rl ./`
