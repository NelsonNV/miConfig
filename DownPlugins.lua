#!/usr/bin/env lua

local ic = require("icecream")

local debug = false

for _, v in pairs(arg) do
	if v == "--debug" then
		debug = true
	end
end

local DicionariPlugin = {
	autovirtualenv = "MichaelAquilina/zsh-autoswitch-virtualenv",
	syntaxcheck = "zsh-users/zsh-syntax-highlighting",
	autosuggestions = "zsh-users/zsh-autosuggestions",
	fzf_tab = "Aloxaf/fzf-tab",
}

for plugin, url in pairs(DicionariPlugin) do
	print("Installing " .. plugin)
	local dirOutPlugins = string.format("~/.zshp/%s", plugin)
	local cmd = string.format("git clone https//:github.com/%s %s", url, dirOutPlugins)
	ic(cmd)
	if not debug then
		os.execute(cmd)
	end
end
