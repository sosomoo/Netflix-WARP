#!/usr/bin/env bash
screen -S aw -X quit
screen -dmS aw
screen -x -S aw -p 0 -X stuff "/bin/bash /root/check.sh"
screen -x -S aw -p 0 -X stuff $'\n'
green(){ echo -e "\033[32m\033[01m$1\033[0m";}
yellow(){ echo -e "\033[33m\033[01m$1\033[0m";}
wgcfv4=$(curl -s4m6 https://www.cloudflare.com/cdn-cgi/trace -k | grep warp | cut -d= -f2) 
wgcfv6=$(curl -s6m6 https://www.cloudflare.com/cdn-cgi/trace -k | grep warp | cut -d= -f2)
UA_Browser="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.87 Safari/537.36"
result4=$(curl -4 --user-agent "${UA_Browser}" -fsL --write-out %{http_code} --output /dev/null --max-time 10 "https://www.netflix.com/title/81215567" 2>&1)
result6=$(curl -6 --user-agent "${UA_Browser}" -fsL --write-out %{http_code} --output /dev/null --max-time 10 "https://www.netflix.com/title/81215567" 2>&1)
mport=`warp-cli --accept-tos settings 2>/dev/null | grep 'Proxy listening on' | awk -F "127.0.0.1:" '{print $2}'`
result=$(curl -sx socks5h://localhost:$mport -fsL --write-out %{http_code} --output /dev/null --max-time 10 "https://www.netflix.com/title/81215567" 2>&1) 
s5c(){
warp-cli --accept-tos register >/dev/null 2>&1 && sleep 2
[[ -e /etc/wireguard/ID ]] && warp-cli --accept-tos set-license $(cat /etc/wireguard/ID) >/dev/null 2>&1
}
WGCFV4(){
while true; do
[[ "$result4" == "200" ]] && green "目前wgcf-ipv4的IP支持奈飞，停止刷新" && sleep 45 || (systemctl restart wg-quick@wgcf && yellow "目前wgcf-ipv4的IP不支持奈飞，刷新wgcf-ipv4的IP中……" && sleep 30)
done
}
WGCFV6(){
while true; do
[[ "$result6" == "200" ]] && green "目前wgcf-ipv6的IP支持奈飞，停止刷新" && sleep 45 || (systemctl restart wg-quick@wgcf && yellow "目前wgcf-ipv6的IP不支持奈飞，刷新wgcf-ipv6的IP中……" && sleep 30)
done
}
SOCKS5warp(){
while true; do
[[ "$result" == "200" ]] && green "目前socks5的IP支持奈飞，停止刷新" && sleep 45 || (s5c && yellow "目前socks5的IP不支持奈飞，刷新socks5的IP中……" && sleep 30)
done
}
SOCKS5wgcf4(){
while true; do
[[ "$result" == "200" ]] && green "目前socks5的IP支持奈飞，停止刷新" && sleep 45 || (s5c && yellow "目前socks5的IP不支持奈飞，刷新socks5的IP中……" && sleep 30)
[[ "$result4" == "200" ]] && green "目前wgcf-ipv4的IP支持奈飞，停止刷新" && sleep 45 || (systemctl restart wg-quick@wgcf && yellow "目前wgcf-ipv4的IP不支持奈飞，刷新wgcf-ipv4的IP中……" && sleep 30)
done
}
SOCKS5wgcf6(){
while true; do
[[ "$result" == "200" ]] && green "目前socks5的IP支持奈飞，停止刷新" && sleep 45 || (s5c && yellow "目前socks5的IP不支持奈飞，刷新socks5的IP中……" && sleep 30)
[[ "$result6" == "200" ]] && green "目前wgcf-ipv6的IP支持奈飞，停止刷新" && sleep 45 || (systemctl restart wg-quick@wgcf && yellow "目前wgcf-ipv6的IP不支持奈飞，刷新wgcf-ipv6的IP中……" && sleep 30)
done
}
WGCFV4V6(){
while true; do
[[ "$result4" == "200" ]] && green "目前wgcf-ipv4的IP支持奈飞，停止刷新" && sleep 45 || (systemctl restart wg-quick@wgcf && yellow "目前wgcf-ipv4的IP不支持奈飞，刷新wgcf-ipv4的IP中……" && sleep 30)
[[ "$result6" == "200" ]] && green "目前wgcf-ipv6的IP支持奈飞，停止刷新" && sleep 45 || (systemctl restart wg-quick@wgcf && yellow "目前wgcf-ipv6的IP不支持奈飞，刷新wgcf-ipv6的IP中……" && sleep 30)
done
}
[[ $(systemctl is-active warp-svc) = active && $wgcfv6 =~ on|plus ]] && green "双栈WARP循环执行：刷socks5与wgcf-ipv6的IP" && SOCKS5wgcf6
[[ $(systemctl is-active warp-svc) = active && $wgcfv4 =~ on|plus ]] && green "双栈WARP循环执行：刷socks5与wgcf-ipv4的IP" && SOCKS5wgcf4
[[ $(systemctl is-active warp-svc) = active && ! $(type -P wg-quick) ]] && green "单栈WARP循环执行：刷socks5的IP" && SOCKS5warp
[[ $wgcfv6 =~ on|plus && $wgcfv4 = off ]] && green "单栈WARP循环执行：刷wgcf-ipv6的IP" && WGCFV6
[[ $wgcfv6 =~ on|plus && $wgcfv4 =~ on|plus ]] && green "双栈WARP单v4循环执行：仅刷wgcf-ipv4的IP" && WGCFV4
[[ $wgcfv6 = off && $wgcfv4 =~ on|plus ]] && green "单栈WARP循环执行：刷wgcf-ipv4的IP" && WGCFV4
