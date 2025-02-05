local DicionariPlugin = {
	autovirtualenv = "MichaelAquilina/zsh-autoswitch-virtualenv",
	syntaxcheck = "zsh-users/zsh-syntax-highlighting",
	autosuggestions = "zsh-users/zsh-autosuggestions",
	fzf_tab = "Aloxaf/fzf-tab",
}

for plugin, url in pairs(DicionariPlugin) do
	print("Installing " .. plugin)
	local dirOutPlugins = string.format("~/.zshp/%s", plugin)
	local cmd = string.format("echo 'git clone %s %s'", url, dirOutPlugins)
	os.execute(cmd)
end
