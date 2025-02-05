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
	autovirtualenv = "MichaelAquilina/zsh-autoswitch-virtualenv",
	syntaxcheck = "zsh-users/zsh-syntax-highlighting",
	autosuggestions = "zsh-users/zsh-autosuggestions",
	fzf_tab = "Aloxaf/fzf-tab",
}

print(colores.azul .. "DownPlugins.lua" .. colores.reset)

for plugin, url in pairs(DicionariPlugin) do
	print(colores.verde .. "[+]" .. "Installing " .. plugin .. colores.reset)
	local dirOutPlugins = string.format("~/.zshp/%s", plugin)
	local cmd = string.format("git clone https//:github.com/%s %s", url, dirOutPlugins)
	ic(cmd)
	if not debug then
		os.execute(cmd)
	end
end
