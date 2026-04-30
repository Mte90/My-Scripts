#!/usr/bin/env bash
# Written in [Amber](https://amber-lang.com/)
# version: 0.6.0-alpha
[ "$EUID" -ne 0 ] && { { command -v sudo >/dev/null 2>&1 && __sudo=sudo; } || { command -v doas >/dev/null 2>&1 && __sudo=doas; }; }
if [ -n "$ZSH_VERSION" ]; then
    EXEC_SHELL="zsh"
    IFS='.' read -A EXEC_SHELL_VERSION <<< "$ZSH_VERSION"
elif [ -n "$KSH_VERSION" ]; then
    EXEC_SHELL="ksh"
    __exec_shell_version="${.sh.version##*/}"
    IFS='.' read -a EXEC_SHELL_VERSION <<< "${__exec_shell_version%% *}"
else
    EXEC_SHELL="bash"
    EXEC_SHELL_VERSION=("${BASH_VERSINFO[0]}" "${BASH_VERSINFO[1]}" "${BASH_VERSINFO[2]}")
fi
# text_contains(source: Text, search: Text)
text_contains__16_v0() {
    local source_44="${1}"
    local search_45="${2}"
    [[ "${source_44}" == *"${search_45}"* ]]
    __status=$?
    ret_text_contains16_v0="$(( __status == 0 ))"
    return 0
}

# dir_exists(path: Text)
dir_exists__38_v0() {
    local path_47="${1}"
    [ -d "${path_47}" ]
    __status=$?
    ret_dir_exists38_v0="$(( __status == 0 ))"
    return 0
}

# file_exists(path: Text)
file_exists__39_v0() {
    local path_31="${1}"
    [ -f "${path_31}" ]
    __status=$?
    ret_file_exists39_v0="$(( __status == 0 ))"
    return 0
}

# symlink_create(origin: Text, destination: Text)
symlink_create__43_v0() {
    local origin_50="${1}"
    local destination_51="${2}"
    file_exists__39_v0 "${origin_50}"
    local ret_file_exists39_v0__71_8="${ret_file_exists39_v0}"
    if [ "${ret_file_exists39_v0__71_8}" != 0 ]; then
        ln -fs "${origin_50}" "${destination_51}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_symlink_create43_v0=''
            return "${__status}"
        fi
        ret_symlink_create43_v0=''
        return 0
    fi
    echo "The file ${origin_50} doesn't exist"'!'""
    ret_symlink_create43_v0=''
    return 1
}

# file_chmod(path: Text, mode: Text)
file_chmod__47_v0() {
    local path_29="${1}"
    local mode_30="${2}"
    file_exists__39_v0 "${path_29}"
    local ret_file_exists39_v0__153_8="${ret_file_exists39_v0}"
    if [ "${ret_file_exists39_v0__153_8}" != 0 ]; then
        chmod "${mode_30}" "${path_29}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_file_chmod47_v0=''
            return "${__status}"
        fi
        ret_file_chmod47_v0=''
        return 0
    fi
    echo "The file ${path_29} doesn't exist"'!'""
    ret_file_chmod47_v0=''
    return 1
}

# is_command(command: Text)
is_command__125_v0() {
    local command_24="${1}"
    [ -x "$(command -v "${command_24}")" ]
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_is_command125_v0=0
        return 0
    fi
    ret_is_command125_v0=1
    return 0
}

# is_root()
is_root__130_v0() {
    local command_0
    command_0="$(id -u)"
    __status=$?
    if [ "$([ "_${command_0}" != "_0" ]; echo $?)" != 0 ]; then
        ret_is_root130_v0=1
        return 0
    fi
    ret_is_root130_v0=0
    return 0
}

# file_download(url: Text, path: Text)
file_download__237_v0() {
    local url_22="${1}"
    local path_23="${2}"
    is_command__125_v0 "curl"
    local ret_is_command125_v0__15_9="${ret_is_command125_v0}"
    is_command__125_v0 "wget"
    local ret_is_command125_v0__18_9="${ret_is_command125_v0}"
    is_command__125_v0 "aria2c"
    local ret_is_command125_v0__21_9="${ret_is_command125_v0}"
    if [ "${ret_is_command125_v0__15_9}" != 0 ]; then
        curl -L -o "${path_23}" "${url_22}">/dev/null 2>&1
        __status=$?
    elif [ "${ret_is_command125_v0__18_9}" != 0 ]; then
        wget "${url_22}" -P "${path_23}">/dev/null 2>&1
        __status=$?
    elif [ "${ret_is_command125_v0__21_9}" != 0 ]; then
        aria2c "${url_22}" -d "${path_23}">/dev/null 2>&1
        __status=$?
    else
        ret_file_download237_v0=''
        return 1
    fi
}

is_root__130_v0 
ret_is_root130_v0__6_8="${ret_is_root130_v0}"
if [ "$(( ! ret_is_root130_v0__6_8 ))" != 0 ]; then
    echo "This script requires root permissions"'!'""
    exit 1
fi
# get_download_path(repo: Text, position: Int)
get_download_path__242_v0() {
    local repo_5="${1}"
    local position_6="${2}"
    local command_1
    command_1="$(curl -sL "https://api.github.com/repos/${repo_5}/releases" | jq -r ".[0].assets.[${position_6}].browser_download_url")"
    __status=$?
    ret_get_download_path242_v0="${command_1}"
    return 0
}

# move_to_bin(download_url: Text, binary: Text)
move_to_bin__243_v0() {
    local download_url_20="${1}"
    local binary_21="${2}"
    file_download__237_v0 "${download_url_20}" "${binary_21}">/dev/null 2>&1
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_move_to_bin243_v0=''
        return "${__status}"
    fi
    if [ '' != 0 ]; then
        mv "${binary_21}" "/usr/local/bin"
        __status=$?
        if [ "${__status}" != 0 ]; then
            echo "Move ${binary_21} to /usr/local/bin failed"'!'""
            exit 1
        fi
        file_chmod__47_v0 "/usr/local/bin/${binary_21}" "+x"
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_move_to_bin243_v0=''
            return "${__status}"
        fi
    else
        echo "Download for ${binary_21} at ${download_url_20} failed"
        exit 1
    fi
}

# download_to_bin(download_url: Text, binary: Text, packed_file: Text)
download_to_bin__244_v0() {
    local download_url_41="${1}"
    local binary_42="${2}"
    local packed_file_43="${3}"
    file_download__237_v0 "${download_url_41}" "${packed_file_43}">/dev/null 2>&1
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_download_to_bin244_v0=''
        return "${__status}"
    fi
    if [ '' != 0 ]; then
        text_contains__16_v0 "${packed_file_43}" "tar.gz"
        local ret_text_contains16_v0__31_16="${ret_text_contains16_v0}"
        if [ "${ret_text_contains16_v0__31_16}" != 0 ]; then
            tar -zxvf "./${packed_file_43}" -C ./ > /dev/null 2>&1
            __status=$?
            mv "./${binary_42}" "/usr/local/bin"
            __status=$?
        else
            gunzip -c "${packed_file_43}" > "/usr/local/bin/${binary_42}"
            __status=$?
        fi
        rm "./${packed_file_43}"
        __status=$?
        file_chmod__47_v0 "/usr/local/bin/${binary_42}" "+x"
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_download_to_bin244_v0=''
            return "${__status}"
        fi
    else
        echo "Download for ${binary_42} at ${download_url_41} failed"
        exit 1
    fi
}

cd "/tmp"
__status=$?
if [ "${__status}" != 0 ]; then
    echo "Could not change directory"
fi
echo "Install PHPactor LSP"
get_download_path__242_v0 "phpactor/phpactor" 0
ret_get_download_path242_v0__52_17="${ret_get_download_path242_v0}"
move_to_bin__243_v0 "${ret_get_download_path242_v0__52_17}" "phpactor"
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
echo "Install Typos LSP"
get_download_path__242_v0 "tekumara/typos-lsp" 7
ret_get_download_path242_v0__55_21="${ret_get_download_path242_v0}"
download_to_bin__244_v0 "${ret_get_download_path242_v0__55_21}" "typos-lsp" "typos.tar.gz"
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
echo "Install Rust LSP"
download_to_bin__244_v0 "https://github.com/rust-lang/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-unknown-linux-gnu.gz" "rust-analyzer" "rust-analyzer-x86_64-unknown-linux-gnu.gz"
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
echo "Install GitLab CI LSP"
get_download_path__242_v0 "alesbrelih/gitlab-ci-ls" 1
ret_get_download_path242_v0__61_17="${ret_get_download_path242_v0}"
move_to_bin__243_v0 "${ret_get_download_path242_v0__61_17}" "x86_64-unknown-linux-gnu"
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
echo "Install HTMX LSP"
get_download_path__242_v0 "ThePrimeagen/htmx-lsp" 2
ret_get_download_path242_v0__64_17="${ret_get_download_path242_v0}"
move_to_bin__243_v0 "${ret_get_download_path242_v0__64_17}" "htmx-lsp"
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
echo "Install Marksman LSP"
get_download_path__242_v0 "artempyanykh/marksman" 1
ret_get_download_path242_v0__67_17="${ret_get_download_path242_v0}"
move_to_bin__243_v0 "${ret_get_download_path242_v0__67_17}" "marksman"
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
echo "Install Lua LSP"
dir_exists__38_v0 "/opt/lua-language-server"
ret_dir_exists38_v0__70_12="${ret_dir_exists38_v0}"
if [ "$(( ! ret_dir_exists38_v0__70_12 ))" != 0 ]; then
    cd "/opt/"
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo "Could not change directory"
    fi
    git clone https://github.com/LuaLS/lua-language-server
    __status=$?
    cd "lua-language-server"
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo "Could not change directory"
    fi
else
    cd "/opt/lua-language-server"
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo "Could not change directory"
    fi
fi
git pull>/dev/null 2>&1
__status=$?
./make.sh>/dev/null 2>&1
__status=$?
symlink_create__43_v0 "/opt/lua-language-server/lua-language-server" "/usr/local/bin/lua-language-server"
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
cd "/tmp"
__status=$?
if [ "${__status}" != 0 ]; then
    echo "Could not change directory"
fi
npm_lsp_52=("vscode-langservers-extracted" "@tailwindcss/language-server" "@olrtg/emmet-language-server" "intelephense" "bash-language-server")
npm_lsp_name_53=("CSS, HTML, JSON LSP" "Tailwind LSP" "Emmet LSP" "Intelephense LSP" "Bash LSP")
index_55=0;
for lsp_54 in "${npm_lsp_52[@]}"; do
    echo "Install ${npm_lsp_name_53[${index_55}]?"Index out of bounds (at ./install.ab:96:37)"}"
    npm i -g "${lsp_54}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo "Error"'!'" Exit code: ${__status}"
    fi
    (( index_55++ )) || true
done
command_lsp_56=("pip install python-lsp-server" "gem install ruby-lsp")
command_lsp_name_57=("Python LSP" "Ruby LSP")
index_59=0;
for lsp_58 in "${command_lsp_56[@]}"; do
    echo "Install ${command_lsp_name_57[${index_59}]?"Index out of bounds (at ./install.ab:106:41)"}"
    ${lsp_58}
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo "Error"'!'" Exit code: ${__status}"
    fi
    (( index_59++ )) || true
done
