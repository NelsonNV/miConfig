#!/usr/bin/env lua

local ic = require("icecream")

local debug = false

for _, v in pairs(arg) do
	if v == "--debug" then
		debug = true
	end
end

local colores = {
	rojo = "\27[31m",
	verde = "\27[32m",
	azul = "\27[34m",
	naranja = "\27[33m",
	gris = "\27[37m",
	reset = "\27[0m",
}

local DicionariPlugin = {
	autovirtualenv = {
		url = "MichaelAquilina/zsh-autoswitch-virtualenv",
		executer = "zsh-autoswitch-virtualenv.plugins.zsh",
	},
	syntaxcheck = {
		url = "zsh-users/zsh-syntax-highlighting",
		executer = "zsh-syntax-highlighting.zsh",
	},
	autosuggestions = {
		url = "zsh-users/zsh-autosuggestions",
		executer = "zsh-autosuggestions.zsh",
	},
	fzf_tab = {
		url = "Aloxaf/fzf-tab",
		executer = "fzf-tab.plugin.zsh",
	},
}

print(colores.azul .. "DownPlugins.lua" .. colores.reset)

for plugin, item in pairs(DicionariPlugin) do
	local url = item.url
	ic(plugin)
	ic(url)
	print(colores.verde .. "[+]" .. "Installing " .. plugin .. colores.reset)
	local dirOutPlugins = string.format("~/.zshp/%s", plugin)
	local cmd = string.format("git clone https//:github.com/%s %s", url, dirOutPlugins)
	ic(cmd)
	if not debug then
		os.execute(cmd)
	end
end

-- agregando al zsh source plugins

print(colores.azul .. "[+]" .. "Adding to zsh" .. colores.reset)
local zshpath = "~/.zshrc"

for plugin, item in pairs(DicionariPlugin) do
	local dirOutPlugins = string.format("~/.zshp/%s/%s", plugin, item.executer)
	local cmd = string.format("echo 'source %s' >> %s", dirOutPlugins, zshpath)
	ic(cmd)
	if not debug then
		os.execute(cmd)
	end
end
