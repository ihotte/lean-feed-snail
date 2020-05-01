#!/usr/bin/lua

-- luac -s -o wireless.lua wireless.src.lua

-- rmmod brcmfmac; rmmod brcmutil; rmmod pwm-meson;
-- rm /etc/config/wireless; dmesg -c;


if 0 ~= os.execute('cat /etc/openwrt_release | grep -q "By Snail"') then
	os.exit(1)
end


local wcf = '/etc/config/wireless'


function file_exists(path)
	local file = io.open(path, "rb")
	if file then file:close() end
	return file ~= nil
end

function readfile(path)
	local fp = io.popen(path, "r")
	if not fp then return nil end
	local out = fp:read("*a")
	fp:close()
	return out
end



-- 加载内核模块
local kos = {
	'pwm-meson', 'meson-rng', 'spi-meson-spifc',
	'pppoe', 'pppox', 'brcmutil', 'brcmfmac'
}
for i, v in ipairs(kos) do
	os.execute('lsmod | grep -q "^' .. v:gsub('-', '_') .. ' " || modprobe ' .. v)
end


-- 等待设备就绪
for i=1,5,1 do
	local code = os.execute('dmesg | grep -q "BCM4345\\|brcmfmac"')
	if code == 0 then break else os.execute('sleep 1') end
end


-- 初始化配置文件，优化配置参数
if not file_exists(wcf) then
	os.execute('/sbin/wifi config')

	for i=1,5,1 do
		os.execute('sleep 1')
		local device = readfile('uci -q get wireless.@wifi-device[0].path')
		if device ~= nil and #device > 32 then
			break
		end
	end

	if file_exists(wcf) then
		local proto = readfile('uci -q get network.lan.proto')
		if proto == "static\n" then
			os.execute('uci set network.lan.type="bridge"; uci commit network')
		end

		os.execute("uci set wireless.@wifi-device[0].channel='161'")
		os.execute("uci set wireless.@wifi-device[0].country='US'")
		os.execute("uci set wireless.@wifi-device[0].htmode='VHT80'")
		os.execute("uci set wireless.@wifi-device[0].hwmode='11a'")
		os.execute("uci set wireless.@wifi-device[0].legacy_rates='0'")
		os.execute("uci set wireless.@wifi-device[0].noscan='1'")

		os.execute("uci set wireless.@wifi-iface[0].ssid='OpenWrtN1'")
		os.execute("uci set wireless.@wifi-iface[0].encryption='psk2'")
		os.execute("uci set wireless.@wifi-iface[0].key='123456789'")
		os.execute("uci set wireless.@wifi-iface[0].short_preamble='0'")
		os.execute("uci set wireless.@wifi-iface[0].wmm='0'")

		os.execute("uci set wireless.@wifi-device[0].disabled='0'")
		os.execute("uci set wireless.@wifi-iface[0].disabled='0'")
		os.execute("uci commit wireless")
	end
end


-- 启动 WiFi
if file_exists(wcf) then
	local disabled = readfile('uci -q get wireless.@wifi-device[0].disabled')
	if disabled ~= "1\n" then
		os.execute('/sbin/wifi config')
		os.execute('/sbin/wifi')
		os.execute('sleep 2')
		if 0 ~= os.execute('ifconfig |grep -q wlan') then
			os.execute('/etc/init.d/network restart >/dev/null 2>&1 &')
		end
	end
end


-- 正常退出
os.exit(0)


