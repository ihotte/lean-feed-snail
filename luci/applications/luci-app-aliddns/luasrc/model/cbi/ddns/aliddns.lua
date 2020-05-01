--[[
LuCI - Lua Configuration Interface

Copyright (C) 2006-2019 OpenWrt.org
This is free software, licensed under the GNU General Public License v2.
See /LICENSE for more information.
]]--

local PKG_NAME = "aliddns"
local PKG_DESC = "AliDDNS"
local PKG_MENU = "services"


require "nixio.fs"
require "luci.sys"

local util = require "luci.util"
local http = require "luci.http"
local disp = require "luci.dispatcher"


local m, s, o

m = Map(PKG_NAME, PKG_DESC)
m.description = translate("Alibaba Cloud DNS is an authoritative high availability and secure domain name resolution and management service.") ..
[[ <script type="text/javascript">$(function () { $('.cbi-input-textarea').scrollTop(999); });</script> ]]


--
-- [[ 基本设置 ]]
--
s = m:section(NamedSection, "main", PKG_NAME, translate("Basic settings"))

o = s:option(Flag, "enabled", translate("Enable"))
	o.default = o.enabled
	o.rmempty = false

o = s:option(Value, "interval", translate("Inspection Time"),
	translate("Unit: Minute, Range: 1-60"))
	o.datatype = "range(1,60)"
	o.placeholder = "10"



--
-- [[ 域名列表 ]]
--
s = m:section(TypedSection, "records", translate("Records list"))
s.sectionhead = translate("Configuration")
s.template = "cbi/tblsection"
s.addremove = true
s.sortable = true
s.extedit = disp.build_url("admin", "services", PKG_NAME, "records", "%s")
-- function s.create(self, name)
	-- AbstractSection.create(self, name)
	-- luci.http.redirect( self.extedit:format(name) )
-- end


o = s:option(Flag, "enabled", translate("Enabled"))
	o.default = o.disabled

o = s:option(DummyValue, "interface", translate("Interface"))
	function o.cfgvalue(self, section)
		return Value.cfgvalue(self, section) or translate("*")
	end

o = s:option(DummyValue, "domain", translate("Main Domain"))
	function o.cfgvalue(self, section)
		return Value.cfgvalue(self, section) or translate("*")
	end

o = s:option(DummyValue, "domain_sub", translate("Sub Domain"))
	function o.cfgvalue(self, section)
		return Value.cfgvalue(self, section) or "*"
	end

o = s:option(DummyValue, "record_id", translate("Record id"))
	function o.cfgvalue(self, section)
		return Value.cfgvalue(self, section) or "?"
	end



--
-- [[ 更新记录 ]]
--
s = m:section(TypedSection, PKG_NAME, translate("Update Log"))
s.anonymous = true


local log_file = "/var/log/%s.log" % { PKG_NAME }
o = s:option(TextValue, "sylogtext")
o.readonly = "readonly"
o.wrap = "off"
o.rows = 20

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

