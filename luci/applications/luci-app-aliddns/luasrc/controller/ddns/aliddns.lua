--[[
LuCI - Lua Configuration Interface

Copyright (C) 2006-2019 OpenWrt.org
This is free software, licensed under the GNU General Public License v2.
See /LICENSE for more information.
]]--

module("luci.controller.ddns.aliddns", package.seeall)


function index()
	local PKG_NAME, PKG_DESC, PKG_MENU = "aliddns" , "AliDDNS", "services"
	-- if not require "luci.version".snail then return end
	if not nixio.fs.access("/etc/config/%s" % PKG_NAME) then
		return
	end

	entry({"admin", PKG_MENU, PKG_NAME }, firstchild(), PKG_DESC).dependent = true
	entry({"admin", PKG_MENU, PKG_NAME, "records"},
		arcombine(
			cbi("ddns/%s" % { PKG_NAME }),
			cbi("ddns/%s_records" % { PKG_NAME })
		)).leaf = true
end

