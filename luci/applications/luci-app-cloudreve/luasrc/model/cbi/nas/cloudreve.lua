--[[
LuCI - Lua Configuration Interface

Copyright (C) 2006-2019 OpenWrt.org
This is free software, licensed under the GNU General Public License v2.
See /LICENSE for more information.
]]--

local PKG_NAME = "cloudreve"
local PKG_DESC = "Cloudreve"
local PKG_MENU = "net"


local nxfs = require "nixio.fs"
local util = require "luci.util"


local m, s, o

m = Map(PKG_NAME, PKG_DESC)
m.description = translate("A project helps you build your own cloud in minutes.")

m:section(SimpleSection).template = "status/%s" % PKG_NAME


--
-- [[ 服务配置 ]]
--
s = m:section(TypedSection, PKG_NAME, translate("Service Settings"))
s.addremove = false
s.anonymous = true


o = s:option(Flag, "enabled", translate("Enable"))
	o.rmempty = false
	o.default = o.disabled

o = s:option(Value, "bind", translate("Listen Address"))
	o.placeholder = "0.0.0.0"
	o.datatype = "ip4addr"

o = s:option(Value, "port", translate("Listen Port"))
	o.placeholder = "8052"
	o.datatype = "port"

o = s:option(ListValue, "user", translate("Run daemon as user"))
	o.rmempty = false
	o.default = "nobody"
	for _, _user in util.vspairs(util.split(luci.sys.exec("cat /etc/passwd | cut -f 1 -d :"))) do
		o:value(_user)
	end



--
-- [[ 高级设置 ]]
--
s = m:section(TypedSection, PKG_NAME, translate("Advanced Settings"))
s.addremove = false
s.anonymous = true


o = s:option(Flag, "internet", translate("Remote Access"), translate("Allow remote computers to access this service over the Internet"))
	o.rmempty = false
	o.default = o.disabled


--
-- [[ Map ]]
--
return m

