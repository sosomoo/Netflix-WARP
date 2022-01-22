#!/usr/bin/env bash
sleep 5
green(){ echo -e "\033[32m\033[01m$1\033[0m";}
yellow(){ echo -e "\033[33m\033[01m$1\033[0m";}
info(){
v6=$(curl -s6m6 https://ip.gs -k)
v4=$(curl -s4m6 https://ip.gs -k)
wgcfv4=$(curl -s4m6 https://www.cloudflare.com/cdn-cgi/trace -k | grep warp | cut -d= -f2) 
wgcfv6=$(curl -s6m6 https://www.cloudflare.com/cdn-cgi/trace -k | grep warp | cut -d= -f2)
UA_Browser="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.87 Safari/537.36"
result4=$(curl -4 --user-agent "${UA_Browser}" -fsL --write-out %{http_code} --output /dev/null --max-time 10 "https://www.netflix.com/title/81215567" 2>&1)
result6=$(curl -6 --user-agent "${UA_Browser}" -fsL --write-out %{http_code} --output /dev/null --max-time 10 "https://www.netflix.com/title/81215567" 2>&1)
[[ "$result6" == "404" ]] && NF="遗憾哦，当前IP仅解锁奈飞Netflix自制剧..."
[[ "$result6" == "403" ]] && NF="死心了，当前IP不支持解锁奈飞Netflix....."
[[ "$result6" == "000" ]] && NF="检测到网络有问题，再次进入脚本可能就好了.."
[[ "$result6" == "200" ]] && NF="恭喜呀，当前IP可解锁奈飞Netflix流媒体..."
[[ "$result4" == "404" ]] && NF="遗憾哦，当前IP仅解锁奈飞Netflix自制剧..."
[[ "$result4" == "403" ]] && NF="死心了，当前IP不支持解锁奈飞Netflix....."
[[ "$result4" == "000" ]] && NF="检测到网络有问题，再次进入脚本可能就好了.."
[[ "$result4" == "200" ]] && NF="恭喜呀，当前IP可解锁奈飞Netflix流媒体..."
mport=`warp-cli --accept-tos settings 2>/dev/null | grep 'Proxy listening on' | awk -F "127.0.0.1:" '{print $2}'`
result=$(curl -sx socks5h://localhost:$mport -fsL --write-out %{http_code} --output /dev/null --max-time 10 "https://www.netflix.com/title/81215567" 2>&1) 
AE="阿联酋（United Arab Emirates）";AU="澳大利亚（Australia）";BG="保加利亚（Bulgaria）";BR="巴西（Brazil）";CA="加拿大（Canada）";CH="瑞士（Switzerland）";CL="智利（Chile)";CN="中国（China）";CO="哥伦比亚（Colombia）";DE="德国（Germany)";ES="西班牙（Spain)";FI="芬兰（Finland）";FR="法国（France）";GB="英国（United Kingdom）";HK="香港（Hong Kong）";ID="印度尼西亚（Indonesia）";IE="爱尔兰（Ireland）";IL="以色列（Israel）";IN="印度（India）";IT="意大利（Italy）";JP="日本（Japan）";KR="韩国（South Korea）";LU="卢森堡（Luxembourg）";MX="墨西哥（Mexico）";MY="马来西亚（Malaysia）";NL="荷兰（Netherlands）";NZ="新西兰（New Zealand）";PH="菲律宾（Philippines）";RO="罗马尼亚（Romania）";RU="俄罗斯（Russian）";SA="沙特（Saudi Arabia）";SE="瑞典（Sweden）";SG="新加坡（Singapore）";TW="台湾（Taiwan）";US="美国（United States）";VN="越南（Vietnam）";ZA="南非（South Africa）"
region=`tr [:lower:] [:upper:] <<< $(curl --user-agent "${UA_Browser}" -fs --max-time 10 --write-out %{redirect_url} --output /dev/null "https://www.netflix.com/title/80018499" | cut -d '/' -f4 | cut -d '-' -f1)`
[[ ! "$region" ]] && region="US"
}
s5c(){
warp-cli --accept-tos register >/dev/null 2>&1 && sleep 2
[[ -e /etc/wireguard/ID ]] && warp-cli --accept-tos set-license $(cat /etc/wireguard/ID) >/dev/null 2>&1
}
info
WGCFV4(){
while true; do
info
[[ "$result4" == "200" && "$region" = "dd" ]] && green "目前wgcf-ipv4的IP($v4)支持奈飞，WARP默认地区为$(eval echo \$$region) ，设置的地区为$(eval echo \$dd) ，停止刷新" && sleep 45s || (systemctl restart wg-quick@wgcf && yellow "目前wgcf-ipv4的IP($v4) $NF，WARP默认地区为$(eval echo \$$region) ，设置的地区为$(eval echo \$dd) ，刷新wgcf-ipv4的IP中……" && sleep 30s)
done
}
WGCFV6(){
while true; do
info
[[ "$result6" == "200" && "$region" = "dd" ]] && green "目前wgcf-ipv6的IP($v6)支持奈飞，WARP默认地区为$(eval echo \$$region) ，设置的地区为$(eval echo \$dd) ，停止刷新" && sleep 45s || (systemctl restart wg-quick@wgcf && yellow "目前wgcf-ipv6的IP($v6) $NF，WARP默认地区为$(eval echo \$$region) ，设置的地区为$(eval echo \$dd) ，刷新wgcf-ipv6的IP中……" && sleep 30s)
done
}
SOCKS5warp(){
while true; do
info
[[ "$result" == "200" && "$region" = "dd" ]] && green "目前socks5的IP($v4)支持奈飞，WARP默认地区为$(eval echo \$$region) ，设置的地区为$(eval echo \$dd) ，停止刷新" && sleep 45s || (s5c && yellow "目前socks5的IP($v4) $NF，WARP默认地区为$(eval echo \$$region) ，设置的地区为$(eval echo \$dd) ，刷新socks5的IP中……" && sleep 30s)
done
}
SOCKS5wgcf4(){
while true; do
info
[[ "$result" == "200" && "$region" = "dd" ]] && green "目前socks5的IP($v4)支持奈飞，地区为$(eval echo \$$region) ，设置的地区为$(eval echo \$dd) ，停止刷新" && sleep 45s || (s5c && yellow "目前socks5的IP($v4) $NF，WARP默认地区为$(eval echo \$$region) ，设置的地区为$(eval echo \$dd) ，刷新socks5的IP中……" && sleep 30s)
[[ "$result4" == "200" && "$region" = "dd" ]] && green "目前wgcf-ipv4的IP($v4)支持奈飞，地区为$(eval echo \$$region) ，设置的地区为$(eval echo \$dd) ，停止刷新" && sleep 45s || (systemctl restart wg-quick@wgcf && yellow "目前wgcf-ipv4的IP($v4) $NF，WARP默认地区为$(eval echo \$$region) ，设置的地区为$(eval echo \$dd) ，刷新wgcf-ipv4的IP中……" && sleep 30s)
done
}
SOCKS5wgcf6(){
while true; do
info
[[ "$result" == "200" && "$region" = "dd" ]] && green "目前socks5的IP($v4)支持奈飞，WARP默认地区为$(eval echo \$$region) ，设置的地区为$(eval echo \$dd) ，停止刷新" && sleep 45s || (s5c && yellow "目前socks5的IP($v4) $NF，WARP默认地区为$(eval echo \$$region) ，设置的地区为$(eval echo \$dd) ，刷新socks5的IP中……" && sleep 30s)
[[ "$result6" == "200" && "$region" = "dd" ]] && green "目前wgcf-ipv6的IP($v6)支持奈飞，WARP默认地区为$(eval echo \$$region) ，设置的地区为$(eval echo \$dd) ，停止刷新" && sleep 45s || (systemctl restart wg-quick@wgcf && yellow "目前wgcf-ipv6的IP($v6) $NF，WARP默认地区为$(eval echo \$$region) ，设置的地区为$(eval echo \$dd) ，刷新wgcf-ipv6的IP中……" && sleep 30s)
done
}
WGCFV4V6(){
while true; do
info
[[ "$result4" == "200" && "$region" = "dd" ]] && green "目前wgcf-ipv4的IP($v4)支持奈飞，WARP默认地区为$(eval echo \$$region) ，设置的地区为$(eval echo \$dd) ，停止刷新" && sleep 45s || (systemctl restart wg-quick@wgcf && yellow "目前wgcf-ipv4的IP($v4) $NF，WARP默认地区为$(eval echo \$$region) ，设置的地区为$(eval echo \$dd) ，刷新wgcf-ipv4的IP中……" && sleep 30s)
[[ "$result6" == "200" && "$region" = "dd" ]] && green "目前wgcf-ipv6的IP($v6)支持奈飞，WARP默认地区为$(eval echo \$$region) ，设置的地区为$(eval echo \$dd) ，停止刷新" && sleep 45s || (systemctl restart wg-quick@wgcf && yellow "目前wgcf-ipv6的IP($v6) $NF，WARP默认地区为$(eval echo \$$region) ，设置的地区为$(eval echo \$dd) ，刷新wgcf-ipv6的IP中……" && sleep 30s)
done
}
[[ $(systemctl is-active warp-svc) = active && $wgcfv6 =~ on|plus ]] && green "双栈WARP循环执行：刷socks5与wgcf-ipv6的IP" && SOCKS5wgcf6
[[ $(systemctl is-active warp-svc) = active && $wgcfv4 =~ on|plus ]] && green "双栈WARP循环执行：刷socks5与wgcf-ipv4的IP" && SOCKS5wgcf4
[[ $(systemctl is-active warp-svc) = active && ! $(type -P wg-quick) ]] && green "单栈WARP循环执行：刷socks5的IP" && SOCKS5warp
[[ $wgcfv6 =~ on|plus && $wgcfv4 =~ on|plus ]] && green "双栈WARP单v4循环执行：仅刷wgcf-ipv4的IP" && WGCFV4
[[ $wgcfv6 = off && $wgcfv4 =~ on|plus ]] && green "单栈WARP循环执行：刷wgcf-ipv4的IP" && WGCFV4
[[ $wgcfv6 =~ on|plus && $wgcfv4 = off ]] && green "单栈WARP循环执行：刷wgcf-ipv6的IP" && WGCFV6
[[ -z $wgcfv6 && $wgcfv4 =~ on|plus ]] && green "单栈WARP循环执行：刷wgcf-ipv4的IP" && WGCFV4
[[ $wgcfv6 =~ on|plus && -z $wgcfv4 ]] && green "单栈WARP循环执行：刷wgcf-ipv6的IP" && WGCFV6
