--[[
LuCI - Lua Configuration Interface

Copyright (C) 2006-2019 OpenWrt.org
This is free software, licensed under the GNU General Public License v2.
See /LICENSE for more information.
]]--

module("luci.controller.nas.cloudreve", package.seeall)

local nxfs = require "nixio.fs"
local util = require "luci.util"
local snail = require "luci.snail"


local PKG_NAME = "cloudreve"
local PKG_DESC = "Cloudreve"
local PKG_MENU = "net"

function index()
	local PKG_NAME, PKG_DESC, PKG_MENU = "cloudreve", "Cloudreve", "nas"
	if not require "luci.version".snail then return end
	if not nixio.fs.access("/etc/config/%s" % PKG_NAME) then
		return
	end

	entry({"admin", PKG_MENU, PKG_NAME},
		firstchild(), _( PKG_DESC )).dependent = true

	entry({"admin", PKG_MENU, PKG_NAME, "general"},
		cbi("%s/%s" % { PKG_MENU, PKG_NAME }), _("General Settings"), 1).leaf = true

	entry({"admin", PKG_MENU, PKG_NAME, "log"},
		template("logview/%s" % PKG_NAME), _("View Logs"), 9)

	entry({"admin", PKG_MENU, PKG_NAME, "log", "data"},
		call("act_log_data")).leaf = true

	entry({"admin", PKG_MENU, PKG_NAME, "log", "clear"},
		call("act_log_clear")).leaf = true

	entry({"admin", PKG_MENU, PKG_NAME, "info"}, call("act_info")).leaf = true
	entry({"admin", PKG_MENU, PKG_NAME, "status"}, call("act_status")).leaf = true
end


--
-- 获取服务状态
--
function act_status()
	local status = {}
	status.running = snail.is_running(PKG_NAME);
	status.pidofs = snail.pidofs(PKG_NAME);
	snail.http_write_json(status)
end


--
-- 获取版本信息
--
function act_info()
	local info = {}
	local ipkg = require "luci.model.ipkg"
	for k, v in pairs({"luci-app-%s" % PKG_NAME, PKG_NAME}) do
		info[v] = ipkg.info(v)[v]
	end
	snail.http_write_json(info)
end


--
-- 获取日志数据
--
function act_log_data()
	local data = { }
	data.client = ""
	data.syslog = ""

	for file in nxfs.glob("/var/log/%s.log" % PKG_NAME) do
		-- local client_log = ("[%s]:\n" % file) .. util.trim(util.exec("tail -n 32 %s 2>/dev/null | sed 'x;1!H;$!d;x'" % file))
		local client_log = ("[%s]:\n" % file) .. util.trim(util.exec("tail -n 32 %s 2>/dev/null" % file))
		data.client = ("%s%s\n\n") % {data.client, client_log}
	end

	-- data.client = util.exec("logread -e '%s\\[[0-9]\\+\\]' | tail -n 32" % PKG_NAME)
	data.syslog = util.exec("logread -e '%s\\[[a-z]\\+\\.d\\]' | tail -n 32" % PKG_NAME)
	snail.http_write_json(data)
end


--
-- 清理日志数据
--
function act_log_clear(type)
	if type and type ~= "" then
		for file in nxfs.glob("/var/log/%s.log" % PKG_NAME) do
			if nxfs.access(file) then
				nxfs.writefile(file, "")
			end
		end
	end
	snail.http_write_json({ code = 0, type = type })
end


