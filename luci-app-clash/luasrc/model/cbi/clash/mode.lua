--

local NXFS = require "nixio.fs"

local SYS  = require "luci.sys"

local HTTP = require "luci.http"

local DISP = require "luci.dispatcher"

local UTIL = require "luci.util"

local fs = require "nixio.fs"





k = Map("clash", translate("Mode"))

r = k:section(TypedSection, "clash")

r.anonymous = true

r.addremove=false



md = r:option(Flag, "mode", translate("Mode Selection"))

md.default = 1

md.rmempty = false

md.description = translate("Do not enable if you do not know how to use it")



o = r:option(ListValue, "en_mode", translate("Select Mode"))

o.description = translate("mode selection")

o:value("redns", translate("redir-host"))

o:value("fakeip", translate("fake-ip"))

o:value("nofall", translate("redir-host(no-fallback)"))

o:value("fknofall", translate("fake-ip(no-fallback)"))

o:depends("mode", 1)



local conff = "/usr/share/clash/ipdns.yml"

o = r:option(TextValue, "conff")

o.readonly=true

o.rows = 18

o.wrap = "off"

o.cfgvalue = function(self, section)

	return NXFS.readfile(conff) or ""

end

o.write = function(self, section, value)

end

o:depends("en_mode", "fakeip")



local confx = "/usr/share/clash/redns.yml"

o = r:option(TextValue, "confx")

o.readonly=true

o.rows = 18

o.wrap = "off"

o.cfgvalue = function(self, section)

	return NXFS.readfile(confx) or ""

end

o.write = function(self, section, value)

end

o:depends("en_mode", "redns")



local confn = "/usr/share/clash/nofall.yml"

o = r:option(TextValue, "confn")

o.readonly=true

o.rows = 18

o.wrap = "off"

o.cfgvalue = function(self, section)

	return NXFS.readfile(confn) or ""

end

o.write = function(self, section, value)

end

o:depends("en_mode", "nofall")





local confk = "/usr/share/clash/fknofall.yml"

o = r:option(TextValue, "confk")

o.readonly=true

o.rows = 18

o.wrap = "off"

o.cfgvalue = function(self, section)

	return NXFS.readfile(confk) or ""

end

o.write = function(self, section, value)

end

o:depends("en_mode", "fknofall")





return k

