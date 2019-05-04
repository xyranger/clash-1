--
local NXFS = require "nixio.fs"
local SYS  = require "luci.sys"
local HTTP = require "luci.http"
local DISP = require "luci.dispatcher"
local UTIL = require "luci.util"
local fs = require "nixio.fs"

m = Map("clash", translate("DNS Acceleration & Forwarder"))
s = m:section(TypedSection, "clash")
s.anonymous = true

bbr = s:option(Flag, "bbr", translate("Enable BBR"))
bbr.default = 1
bbr.rmempty = false
bbr.description = translate("Bottleneck Bandwidth and Round-trip propagation time (BBR)")


dns = s:option(Flag, "dns", translate("Enable DNS"))
dns.default = 1
dns.rmempty = false
dns.description = translate("Enable DNS Cache Acceleration and anti ISP DNS pollution")

o = s:option(ListValue, "dnsmodel", translate("Choose DNS Resolve Model"))
o.description = translate("Choose DNS Resolve With White$Black List Model")
o:value("white", translate("绕过中国大陆IP"))
o:value("black", translate("GFW列表模式"))
o:depends("dns", 1)

o = s:option(ListValue, "dnsserver", translate("Domestic DNS Server"))
o.description = translate("DNS Servers located in China")
o:value("114.114.114.114,114.114.115.115", translate("南京信风网络GreatbitDNS (114.114.114.114,114.114.115.115)"))
o:value("223.5.5.5,223.6.6.6", translate("阿里云AliDNS (223.5.5.5,223.6.6.6)"))
o:value("1.2.4.8", translate("中国互联网络SecureDNS (1.2.4.8)"))
o:value("119.29.29.29", translate("烟台帝思普网络BPG DNS (119.29.29.29)"))
o:depends("dns", 1)

o = s:option(ListValue, "dnsserver_d", translate("Global DNS Server"))
o.description = translate("DNS Servers located Overseas")
o:value("208.67.222.222,208.67.220.220:5353", translate("OpenDNS (208.67.222.222,208.67.220.220)"))
o:value("8.8.4.4,8.8.8.8:53", translate("Google Public DNS (8.8.4.4,8.8.8.8)"))
o:value("209.244.0.3,209.244.0.4:53", translate("Level 3 Public DNS (209.244.0.3209.244.0.4)"))
o:value("4.2.2.1,4.2.2.2,4.2.2.3,4.2.2.4:53", translate("Level 3 Public DNS (4.2.2.1,4.2.2.2,4.2.2.3,4.2.2.4)"))
o:value("1.1.1.1:53", translate("Cloudflare DNS (1.1.1.1)"))
o:depends("dns", 1)


o = s:option(Value, "dns_server_d")
o.title = translate("* Domestic DNS Fowarder")
o.default = "127.0.0.1#5333"
o.description = translate("Domestic DNS Server Fowarder")
o:depends("dns", 1)

o = s:option(Value, "dns_server")
o.title = translate("* Global DNS Fowarder")
o.default = "127.0.0.1#5353"
o.description = translate("Global DNS Server Fowarder")
o:depends("dns", 1)


gfw_list = s:option(Value, "gfw_list", translate("self_difined gfw_list"), translate("Please modify the file here."))
gfw_list.template = "cbi/tvalue"
gfw_list.rows = 13
gfw_list.wrap = "off"
gfw_list:depends("dns", 1)

function gfw_list.cfgvalue(self, section)
	return fs.readfile("/etc/config/gfw.list") or ""
end
function gfw_list.write(self, section, value)
	if value then
		value = value:gsub("\r\n", "\n")
		fs.writefile("/etc/config/gfw.list", value)
	end
end

o = s:option(Button,"update")
o.title = translate("Apply Modify List")
o.inputtitle = translate("Apply Modify List")
o.inputstyle = "reload"
o:depends("dns", 1)
o.write = function()
  SYS.call("bash /usr/share/clash/gfw2ipset.sh && /etc/init.d/dnsmasq restart 2>&1")
end

o = s:option(Button,"update_gfw")
o.title = translate("Update GFW List")
o.inputtitle = translate("Update GFW List")
o.inputstyle = "reload"
o:depends("dns", 1)
o.write = function()
  SYS.call("bash /usr/share/clash/update.sh && /etc/init.d/dnsmasq restart 2>&1")
end



local apply = luci.http.formvalue("cbi.apply")
if apply then
	os.execute("/etc/init.d/clash restart >/dev/null 2>&1 &")
end



return m
