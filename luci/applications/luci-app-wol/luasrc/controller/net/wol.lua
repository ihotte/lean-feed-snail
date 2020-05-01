--[[
LuCI - Lua Configuration Interface

Copyright (C) 2006-2019 OpenWrt.org
This is free software, licensed under the GNU General Public License v2.
See /LICENSE for more information.
]]--

module("luci.controller.net.wol", package.seeall)

function index()
	-- if not require "luci.version".snail then return end

	entry({"admin", "network", "wol"}, form("net/wol"), _("Wake on LAN"), 90)
	entry({"mini",  "network", "wol"}, form("net/wol"), _("Wake on LAN"), 90)
end

