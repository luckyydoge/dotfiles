# env.nu
#
# Installed by:
# version = "0.109.1"
#
# Previously, environment variables were typically configured in `env.nu`.
# In general, most configuration can and should be performed in `config.nu`
# or one of the autoload directories.
#
# This file is generated for backwards compatibility for now.
# It is loaded before config.nu and login.nu
#
# See https://www.nushell.sh/book/configuration.html
#
# Also see `help config env` for more options.
#
# You can remove these comments if you want or leave
# them for future reference.

# # carapace
# $env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
# mkdir $"($nu.cache-dir)"
# carapace _carapace nushell | save --force $"($nu.cache-dir)/carapace.nu"

# # zoxide
# zoxide init nushell | save -f ~/.zoxide.nu

# # atuin
# mkdir ~/.local/share/atuin/
# atuin init nu | save -f ~/.local/share/atuin/init.nu

# --- Carapace 优化 ---
let carapace_cache = ($nu.cache-dir | path join "carapace.nu")
if not ($carapace_cache | path exists) {
    mkdir ($nu.cache-dir)
    carapace _carapace nushell | save --force $carapace_cache
}
# 注意：在 config.nu 中 source 这个文件，或者在这里直接 source
# source $carapace_cache 

# --- Zoxide 优化 ---
let zoxide_cache = ($nu.home-path | path join ".zoxide.nu")
if not ($zoxide_cache | path exists) {
    zoxide init nushell | save -f $zoxide_cache
}
# source $zoxide_cache