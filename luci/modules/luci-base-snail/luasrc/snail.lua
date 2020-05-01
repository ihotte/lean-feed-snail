-- Copyright 2008 Steven Barth <steven@midlink.org>
-- Licensed to the public under the Apache License 2.0.

local io = require "io"
local math = require "math"
local table = require "table"
local debug = require "debug"
local string = require "string"
local coroutine = require "coroutine"

local sys = require "luci.sys"
local nxfs = require "nixio.fs"
local util = require "luci.util"
local http = require "luci.http"
local webadmin = require "luci.tools.webadmin"
local version = require "luci.version"

local _ubus = require "ubus"
local _ubus_connection = nil

local getmetatable, setmetatable = getmetatable, setmetatable
local rawget, rawset, unpack, select = rawget, rawset, unpack, select
local tonumber, tostring, type, assert, error = tonumber, tostring, type, assert, error
local ipairs, pairs, next, loadstring = ipairs, pairs, next, loadstring
local require, pcall, xpcall = require, pcall, xpcall
local collectgarbage, get_memory_limit = collectgarbage, get_memory_limit

module "luci.snail"


version.snail = true

byte_format = webadmin.byte_format
date_format = webadmin.date_format


function safe_trim(str)
	local str = util.trim(str or "")
	return str:gsub("\r\n", "\n") .. "\n\n"
end

-- also register functions above in the central string class for convenience
string.safe_trim   = safe_trim


--
-- pidofs
--
function pidofs(name)
	return util.trim(sys.exec("pidof %s" % name)) or ""
end


--
-- is running
--
function is_running(name)
	return sys.call("pidof %s >/dev/null" % name) == 0
end


--
-- http write json
--
function http_write_json(content)
	http.prepare_content("application/json")
	http.write_json(content or { code = 1 })
end


--
-- Execute given commandline and gather stdout.
-- @param command	String containing command to execute
-- @return			success, error code, output.
--
function execute(command)
	local fd = io.popen(command .. ' 2>&1; echo "@$?"')
	local output = fd:read("*a")
	local begin, finish, code = output:find("@(%d+)\n$")
	output, code = output:sub(1, begin - 1), tonumber(code or 255)
	return code == 0 and true or false, code, output
end


--
-- iface_get_network
--
function iface_get_network(iface)
	local filename = "/tmp/.iface_network." .. iface
	if nxfs.access(filename) then
		return nxfs.readfile(filename)
	end
	local interface = webadmin.iface_get_network(iface) or ""
	nxfs.writefile(filename, interface)
end



--
-- [[ info ]]
--
info = {}
function info.coremark()
	local data = sys.exec("cat /etc/coremark.log 2>/dev/null")
	data = #data > 3 and ("(CoreMark: %s Scores)" % data) or ""
	return data
end
function info.memcached()
	return sys.exec("sed -e '/^Cached: /!d; s#Cached: *##; s# kB##g' /proc/meminfo")
end



--
-- [[ Net ]]
--
net = {}


--
-- Returns the current arp-table entries as two-dimensional table.
-- @return	Table of table containing the current arp entries.
--			The following fields are defined for arp entry objects:
--			{ "IP address", "HW address", "HW type", "Flags", "Mask", "Device" }
function net.arptable(callback)
	local arp, e, r, v
	if nxfs.access("/proc/net/arp") then
		for e in io.lines("/proc/net/arp") do
			local r = { }, v
			for v in e:gmatch("%S+") do
				r[#r+1] = v
			end

			if r[1] ~= "IP" then
				local x = {
					["IP address"] = r[1],
					["HW type"]    = r[2],
					["Flags"]      = r[3],
					["HW address"] = r[4],
					["Mask"]       = r[5],
					["Device"]     = r[6]
				}

				if callback then
					callback(x)
				else
					arp = arp or { }
					arp[#arp+1] = x
				end
			end
		end
	end
	return arp
end


--
-- Get SOC temp
--
function get_soc_temp()
	local fnames = {
		"/sys/class/hwmon/hwmon0/temp1_input",
		"/sys/class/thermal/thermal_zone0/temp",
		"/sys/devices/virtual/thermal/thermal_zone0/temp",
		"/sys/devices/platform/scpi/scpi:sensors/hwmon/hwmon0/temp1_input",
	}

	local temp = sys.exec("sensors -A 2>/dev/null | sed 's/^Core /Core/g' | awk -F' ' '{print $2}' | sed '/^$/d' | sort | uniq | grep '°C' | sed -n '1p;$p' | uniq")
	if temp and #temp > 3 then return temp end

	for k, v in ipairs(fnames) do
		if v and nxfs.access(v) then
			local temp = nxfs.readfile(v)
			temp = string.sub(temp, 0, -4)
			temp = "+%0.1f°C" % (temp / 10)
			return temp
		end
	end
	return "? °C"
end


--
-- Get CPU freq
--
function get_cpu_freq()
	local freq, maxmhz
	local fnames = {
		"/sys/devices/system/cpu/cpufreq/policy0/cpuinfo_cur_freq",
	}

	for k, v in ipairs(fnames) do
		if v and nxfs.access(v) then
			freq = nxfs.readfile(v)
			break
		end
	end

	if not freq or #freq < 2 then
		maxmhz = sys.exec("lscpu --extended=MAXMHZ 2>/dev/null| sed -n '2p'| cut -c1-4")
	end

	return "%s Mhz" % (freq and (freq / 1000) or maxmhz or "-")
end


--
-- Get CPU Usage
--
function get_cpu_usage()
	local usage = sys.exec("expr 100 - $(/bin/busybox top -n 1 | grep 'CPU:' | awk -F '%' '{print$4}' | awk -F ' ' '{print$2}')") or "6"
	return usage .. "%"
end


--
-- Get User Info
--
function get_user_info()
	local info = sys.exec("cat /proc/net/arp | grep 'br-lan' | grep '0x2' | wc -l") or "?"
	return info
end


