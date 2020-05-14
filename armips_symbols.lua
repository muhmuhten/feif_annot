#!/usr/bin/env lua

local function slurpfile (path)
	local fh = assert(io.open(path))
	local data = fh:read "*a"
	fh:close()
	return data
end
local addrs = slurpfile(arg[1])
local names = slurpfile(arg[2])

local words = {}
for j=3,#arg do
	for word in slurpfile(arg[j]):gmatch "_SYM_.([%w_]+)" do
		words[word] = "_SYM_."..word
	end
end

for aof=1,#addrs-8,8 do
	local tof, nof = string.unpack("I4I4", addrs, aof)
	local label = string.unpack("z", names, nof+1)
	local idents = {label:gsub("%W", "_"), label:gsub("[(<].*", ""):gsub("%W", "_")}
	for j=1,#idents do
		local try = idents[j]
		if words[try] then
			print(".definelabel", string.format("%s,0x%x", words[try],tof))
			words[try] = nil
		end
	end
end

for x, y in pairs(words) do
	print(".error", string.format("%q", "no symbol found for "..x))
end
