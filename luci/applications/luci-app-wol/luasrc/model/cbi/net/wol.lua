--[[
LuCI - Lua Configuration Interface

Copyright (C) 2006-2019 OpenWrt.org
This is free software, licensed under the GNU General Public License v2.
See /LICENSE for more information.
]]--


local sys = require "luci.sys"
local ipc = require "luci.ip"

local http = require "luci.http"
local util = require "luci.util"
local nxfs = require "nixio.fs"


local m, s, o

m = SimpleForm("wol", translate("Wake on LAN"))
m.description = translate("Wake on LAN is a mechanism to remotely boot computers in the local network.")

m.submit = translate("Wake up host")
m.reset  = false


local bin_ewk = "/usr/bin/etherwake"
local bin_wol = "/usr/bin/wol"

local has_ewk = nxfs.access(bin_ewk)
local has_wol = nxfs.access(bin_wol)


s = m:section(SimpleSection)
s.template = "wol/routes"


s = m:section(SimpleSection)

if has_ewk and has_wol then
	bin = s:option(ListValue, "binary", translate("WoL program"),
		translate("Sometimes only one of the two tools works. If one fails, try the other one"))

	bin:value(bin_ewk, "Etherwake")
	bin:value(bin_wol, "WoL")
end

if has_ewk then
	iface = s:option(ListValue, "iface", translate("Network interface to use"), translate("Specifies the interface the WoL packet is sent on"))

	if has_wol then
		iface:depends("binary", bin_ewk)
	end

	iface.default = "br-lan"
	iface:value("", translate("Broadcast on all interfaces"))
	for _, e in ipairs(sys.net.devices()) do
		if e ~= "lo" then iface:value(e) end
	end
end



--
--
--
host = s:option(Value, "mac", translate("Host to wake up"), translate("Choose the host to wake up or enter a custom MAC address to use"))
sys.net.mac_hints(function (mac, name)
	host:value(mac, "%s (%s)" %{ mac, name })
end)

if has_ewk then
	broadcast = s:option(Flag, "broadcast", translate("Send to broadcast address"))
	if has_wol then
		broadcast:depends("binary", bin_ewk)
	end
end


function host.write(self, s, val)
	local host = http.formvalue("cbid.wol.1.mac")
	local mac = ipc.checkmac(host)
	if mac then
		local cmd
		local util = http.formvalue("cbid.wol.1.binary") or (
			has_ewk and bin_ewk or bin_wol
		)

		if util == bin_ewk then
			local iface = http.formvalue("cbid.wol.1.iface")
			local broadcast = http.formvalue("cbid.wol.1.broadcast")
			cmd = "%s -D%s %s%q" %{ util,
				(iface ~= "" and " -i %q" % iface or ""),
				(broadcast == "1" and "-b " or ""), host
			}
		else
			cmd = "%s -v %q" %{ util, host }
		end

		local msg = "<p><strong>%s</strong><br /><br /><code>%s<br /><br />" %{
			translate("Starting WoL utility:"),
			string.sub(cmd, string.len(cmd) - string.find(string.reverse(cmd), "/") + 2)
		}

		local p = io.popen(cmd .. " 2>&1")
		if p then
			while true do
				local l = p:read("*l")
				if l then
					if #l > 100 then l = l:sub(1, 100) .. "..." end
					msg = msg .. l .. "<br />"
				else
					break
				end
			end
			p:close()
		end

		msg = msg .. "</code></p>"
		m.message = msg
	end
end


---
return m

