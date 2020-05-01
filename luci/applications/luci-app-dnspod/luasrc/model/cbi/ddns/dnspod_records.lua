--[[
LuCI - Lua Configuration Interface

Copyright (C) 2006-2019 OpenWrt.org
This is free software, licensed under the GNU General Public License v2.
See /LICENSE for more information.
]]--

local PKG_NAME = "dnspod"
local PKG_DESC = "DNSPod"
local PKG_MENU = "services"


require "nixio.fs"
require "luci.sys"

local util = require "luci.util"
local http = require "luci.http"
local disp = require "luci.dispatcher"


local m, s, o
local sid = arg[1]

m = Map(PKG_NAME, "%s - %s - [%s]" % { PKG_DESC, translate("Edit Records"), sid })
m.description =  translate("DNSPod 致力于为各类网站提供高质量的电信、网通、教育网双线或者三线智能 DNS 免费解析。")
m.redirect = disp.build_url("admin/services/%s/records" % { PKG_NAME })
if m.uci:get(PKG_NAME, sid) ~= "records" then
	luci.http.redirect(m.redirect)
	return
end


--
-- [[ 基本参数 ]]
--
s = m:section(NamedSection, sid, "records", translate("Basic parameters"))
s.addremove = false
s.anonymous = true


o = s:option(Flag, "enabled", translate("Enabled"))
	o.default = o.disabled


o = s:option(Flag, "record_clean", translate("Clean Before Update"))
	o.rmempty = false


o = s:option(Value, "app_key", translate("Access Key ID"))
o = s:option(Value, "app_secret", translate("Access Key Secret"))
	o.password = true


iface = s:option(ListValue, "interface", translate("WAN-IP Source"),
	translate("Select the WAN-IP Source, like wan/internet"))
	iface:value("", translate("Select WAN-IP Source"))
	iface:value("internet", translate("Internet external IP"))
	iface:value("wan", translate("Router WAN IP"))
	iface.rmempty = false


o = s:option(Value, "domain",translate("Main Domain"),
	translate("For example: test.github.com -> github.com"))
	o.rmempty = false


o = s:option(Value, "domain_sub",translate("Sub Domain"),
	translate("For example: test.github.com -> test"))
	o.rmempty = false


--
-- [[ 更新记录 ]]
--
s = m:section(TypedSection, PKG_NAME, translate("Update Log"))
s.anonymous = true


local log_file = "/var/log/%s.log" % { PKG_NAME }
o = s:option(TextValue, "sylogtext")
o.readonly = "readonly"
o.wrap = "off"
o.rows = 10

o.write = function (self, section, value) end
function o.cfgvalue(self, section)
	local sylogtext = ""
	if log_file and nixio.fs.access(log_file) then
		sylogtext = luci.sys.exec("tail -n 32 %s" % { log_file })
	end
	return sylogtext
end


---
return m

