# config.nu
#
# Installed by:
# version = "0.109.1"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# Nushell sets "sensible defaults" for most configuration settings, 
# so your `config.nu` only needs to override these defaults if desired.
#
# You can open this file in your default editor using:
#     config nu
#
# You can also pretty-print and page through the documentation for configuration
# options using:
#     config nu --doc | nu-highlight | less -R

$env.config.buffer_editor = "nvim"

$env.config = {
    edit_mode: "vi"
}

# alias ls = eza -

# 替代传统 ll，带标题、图标和 Git 状态
alias ll = eza -l --icons --header --git

# 替代传统 la，显示隐藏文件
alias la = eza -la --icons --header --git

# 查看三层深度的项目树
alias lt = eza --tree --level 3 --icons

# 仅显示目录并按时间排序
alias lsd = eza -D --sort=modified

alias z = zoxide

# ${UserConfigDir}/nushell/config.nu
source $"($nu.cache-dir)/carapace.nu"


# yazi
def --env y [...args] {
	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
	yazi ...$args --cwd-file $tmp
	let cwd = (open $tmp)
	if $cwd != "" and $cwd != $env.PWD {
		cd $cwd
	}
	rm -fp $tmp
}

let fish_completer = {|spans|
    fish --command $"complete '--do-complete=($spans | str replace --all "'" "\\'" | str join ' ')'"
    | from tsv --flexible --noheaders --no-infer
    | rename value description
    | update value {|row|
      let value = $row.value
      let need_quote = ['\' ',' '[' ']' '(' ')' ' ' '\t' "'" '"' "`"] | any {$in in $value}
      if ($need_quote and ($value | path exists)) {
        let expanded_path = if ($value starts-with ~) {$value | path expand --no-symlink} else {$value}
        $'"($expanded_path | str replace --all "\"" "\\\"")"'
      } else {$value}
    }
}

# 此补全器默认使用 carapace
let external_completer = {|spans|
    let expanded_alias = scope aliases
    | where name == $spans.0
    | get -o 0.expansion

    let spans = if $expanded_alias != null {
        $spans
        | skip 1
        | prepend ($expanded_alias | split row ' ' | take 1)
    } else {
        $spans
    }

    match $spans.0 {
        # carapace 补全对于 nu 不正确
        nu => $fish_completer
        # fish 以更好的方式补全提交和分支名称
        git => $fish_completer
        # carapace 没有 asdf 的补全
        asdf => $fish_completer
        _ => $carapace_completer
    } | do $in $spans
}

$env.config = {
    # ...
    completions: {
        external: {
            enable: true
            completer: $external_completer
        }
    }
    # ...
}

source ~/.zoxide.nu
