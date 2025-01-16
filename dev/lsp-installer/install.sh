#!/usr/bin/env bash
# Written in [Amber](https://amber-lang.com/)
# version: 0.4.0-alpha
# date: 2025-01-16 17:19:04
text_contains__14_v0() {
    local text=$1
    local phrase=$2
    __AMBER_VAL_0=$(if [[ "${text}" == *"${phrase}"* ]]; then
        echo 1
    fi)
    __AS=$?
    local result="${__AMBER_VAL_0}"
    __AF_text_contains14_v0=$(
        [ "_${result}" != "_1" ]
        echo $?
    )
    return 0
}
dir_exists__32_v0() {
    local path=$1
    [ -d "${path}" ]
    __AS=$?
    if [ $__AS != 0 ]; then
        __AF_dir_exists32_v0=0
        return 0
    fi
    __AF_dir_exists32_v0=1
    return 0
}
file_exists__33_v0() {
    local path=$1
    [ -f "${path}" ]
    __AS=$?
    if [ $__AS != 0 ]; then
        __AF_file_exists33_v0=0
        return 0
    fi
    __AF_file_exists33_v0=1
    return 0
}
symlink_create__37_v0() {
    local origin=$1
    local destination=$2
    file_exists__33_v0 "${origin}"
    __AF_file_exists33_v0__41_8="$__AF_file_exists33_v0"
    if [ "$__AF_file_exists33_v0__41_8" != 0 ]; then
        ln -s "${origin}" "${destination}"
        __AS=$?
        __AF_symlink_create37_v0=1
        return 0
    fi
    echo "The file ${origin} doesn't exist"'!'""
    __AF_symlink_create37_v0=0
    return 0
}
file_chmod__39_v0() {
    local path=$1
    local mode=$2
    file_exists__33_v0 "${path}"
    __AF_file_exists33_v0__61_8="$__AF_file_exists33_v0"
    if [ "$__AF_file_exists33_v0__61_8" != 0 ]; then
        chmod "${mode}" "${path}"
        __AS=$?
        __AF_file_chmod39_v0=1
        return 0
    fi
    echo "The file ${path} doesn't exist"'!'""
    __AF_file_chmod39_v0=0
    return 0
}
is_command__96_v0() {
    local command=$1
    [ -x "$(command -v ${command})" ]
    __AS=$?
    if [ $__AS != 0 ]; then
        __AF_is_command96_v0=0
        return 0
    fi
    __AF_is_command96_v0=1
    return 0
}
is_root__101_v0() {
    __AMBER_VAL_1=$(id -u)
    __AS=$?
    if [ $(
        [ "_${__AMBER_VAL_1}" != "_0" ]
        echo $?
    ) != 0 ]; then
        __AF_is_root101_v0=1
        return 0
    fi
    __AF_is_root101_v0=0
    return 0
}
file_download__138_v0() {
    local url=$1
    local path=$2
    is_command__96_v0 "curl"
    __AF_is_command96_v0__9_9="$__AF_is_command96_v0"
    is_command__96_v0 "wget"
    __AF_is_command96_v0__12_9="$__AF_is_command96_v0"
    is_command__96_v0 "aria2c"
    __AF_is_command96_v0__15_9="$__AF_is_command96_v0"
    if [ "$__AF_is_command96_v0__9_9" != 0 ]; then
        curl -L -o "${path}" "${url}"
        __AS=$?
    elif [ "$__AF_is_command96_v0__12_9" != 0 ]; then
        wget "${url}" -P "${path}"
        __AS=$?
    elif [ "$__AF_is_command96_v0__15_9" != 0 ]; then
        aria2c "${url}" -d "${path}"
        __AS=$?
    else
        __AF_file_download138_v0=0
        return 0
    fi
    __AF_file_download138_v0=1
    return 0
}
is_root__101_v0
__AF_is_root101_v0__6_8="$__AF_is_root101_v0"
if [ $(echo '!' "$__AF_is_root101_v0__6_8" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
    echo "This script requires root permissions"'!'""
    exit 1
fi
get_download_path__142_v0() {
    local repo=$1
    local position=$2
    __AMBER_VAL_2=$(curl -sL "https://api.github.com/repos/${repo}/releases" | jq -r ".[0].assets.[${position}].browser_download_url")
    __AS=$?
    __AF_get_download_path142_v0="${__AMBER_VAL_2}"
    return 0
}
move_to_bin__143_v0() {
    local download_url=$1
    local binary=$2
    file_download__138_v0 "${download_url}" "${binary}" >/dev/null 2>&1
    __AF_file_download138_v0__16_15="$__AF_file_download138_v0"
    if [ "$__AF_file_download138_v0__16_15" != 0 ]; then
        mv "${binary}" "/usr/local/bin"
        __AS=$?
        if [ $__AS != 0 ]; then
            echo "Move ${binary} to /usr/local/bin failed"'!'""
            exit 1
        fi
        file_chmod__39_v0 "/usr/local/bin/${binary}" "+x"
        __AF_file_chmod39_v0__21_9="$__AF_file_chmod39_v0"
        echo "$__AF_file_chmod39_v0__21_9" >/dev/null 2>&1
    else
        echo "Download for ${binary} at ${download_url} failed"
        exit 1
    fi
}
download_to_bin__144_v0() {
    local download_url=$1
    local binary=$2
    local packed_file=$3
    file_download__138_v0 "${download_url}" "${packed_file}" >/dev/null 2>&1
    __AF_file_download138_v0__29_15="$__AF_file_download138_v0"
    if [ "$__AF_file_download138_v0__29_15" != 0 ]; then
        text_contains__14_v0 "${packed_file}" "tar.gz"
        __AF_text_contains14_v0__31_16="$__AF_text_contains14_v0"
        if [ "$__AF_text_contains14_v0__31_16" != 0 ]; then
            tar -zxvf "./${packed_file}" -C ./ >/dev/null 2>&1
            __AS=$?
            mv "./${binary}" "/usr/local/bin"
            __AS=$?
        else
            gunzip -c ${packed_file} >"/usr/local/bin/${binary}"
            __AS=$?
        fi
        rm "./${packed_file}"
        __AS=$?
        file_chmod__39_v0 "/usr/local/bin/${binary}" "+x"
        __AF_file_chmod39_v0__39_9="$__AF_file_chmod39_v0"
        echo "$__AF_file_chmod39_v0__39_9" >/dev/null 2>&1
    else
        echo "Download for ${binary} at ${download_url} failed"
        exit 1
    fi
}
cd "/tmp" || exit
echo "Install PHPactor LSP"
get_download_path__142_v0 "phpactor/phpactor" 0
__AF_get_download_path142_v0__49_13="${__AF_get_download_path142_v0}"
move_to_bin__143_v0 "${__AF_get_download_path142_v0__49_13}" "phpactor"
__AF_move_to_bin143_v0__49_1="$__AF_move_to_bin143_v0"
echo "$__AF_move_to_bin143_v0__49_1" >/dev/null 2>&1
echo "Install Typos LSP"
get_download_path__142_v0 "tekumara/typos-lsp" 7
__AF_get_download_path142_v0__52_17="${__AF_get_download_path142_v0}"
download_to_bin__144_v0 "${__AF_get_download_path142_v0__52_17}" "typos-lsp" "typos.tar.gz"
__AF_download_to_bin144_v0__52_1="$__AF_download_to_bin144_v0"
echo "$__AF_download_to_bin144_v0__52_1" >/dev/null 2>&1
echo "Install Rust LSP"
download_to_bin__144_v0 "https://github.com/rust-lang/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-unknown-linux-gnu.gz" "rust-analyzer" "rust-analyzer-x86_64-unknown-linux-gnu.gz"
__AF_download_to_bin144_v0__55_1="$__AF_download_to_bin144_v0"
echo "$__AF_download_to_bin144_v0__55_1" >/dev/null 2>&1
echo "Install GitLab CI LSP"
get_download_path__142_v0 "alesbrelih/gitlab-ci-ls" 1
__AF_get_download_path142_v0__58_13="${__AF_get_download_path142_v0}"
move_to_bin__143_v0 "${__AF_get_download_path142_v0__58_13}" "x86_64-unknown-linux-gnu"
__AF_move_to_bin143_v0__58_1="$__AF_move_to_bin143_v0"
echo "$__AF_move_to_bin143_v0__58_1" >/dev/null 2>&1
echo "Install HTMX LSP"
get_download_path__142_v0 "ThePrimeagen/htmx-lsp" 2
__AF_get_download_path142_v0__61_13="${__AF_get_download_path142_v0}"
move_to_bin__143_v0 "${__AF_get_download_path142_v0__61_13}" "htmx-lsp"
__AF_move_to_bin143_v0__61_1="$__AF_move_to_bin143_v0"
echo "$__AF_move_to_bin143_v0__61_1" >/dev/null 2>&1
echo "Install Marksman LSP"
get_download_path__142_v0 "artempyanykh/marksman" 1
__AF_get_download_path142_v0__64_13="${__AF_get_download_path142_v0}"
move_to_bin__143_v0 "${__AF_get_download_path142_v0__64_13}" "marksman"
__AF_move_to_bin143_v0__64_1="$__AF_move_to_bin143_v0"
echo "$__AF_move_to_bin143_v0__64_1" >/dev/null 2>&1
echo "Install Lua LSP"
dir_exists__32_v0 "/opt/lua-language-server"
__AF_dir_exists32_v0__67_8="$__AF_dir_exists32_v0"
if [ $(echo '!' "$__AF_dir_exists32_v0__67_8" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
    cd "/opt/" || exit
    git clone https://github.com/LuaLS/lua-language-server
    __AS=$?
    cd "lua-language-server" || exit
else
    cd "/opt/lua-language-server" || exit
fi
git pull >/dev/null 2>&1
__AS=$?
./make.sh >/dev/null 2>&1
__AS=$?
symlink_create__37_v0 "/opt/lua-language-server/bin/lua-language-server" "/usr/local/bin/lua-language-server"
__AF_symlink_create37_v0__78_1="$__AF_symlink_create37_v0"
echo "$__AF_symlink_create37_v0__78_1" >/dev/null 2>&1
cd "/tmp" || exit
__AMBER_ARRAY_3=("vscode-langservers-extracted" "@tailwindcss/language-server" "@olrtg/emmet-language-server" "intelephense" "bash-language-server")
__0_npm_lsp=("${__AMBER_ARRAY_3[@]}")
__AMBER_ARRAY_4=("CSS, HTML, JSON LSP" "Tailwind LSP" "Emmet LSP" "Intelephense LSP" "Bash LSP")
__1_npm_lsp_name=("${__AMBER_ARRAY_4[@]}")
index=0
for lsp in "${__0_npm_lsp[@]}"; do
    echo "Install ${__1_npm_lsp_name[${index}]}"
    npm i -g "${lsp}"
    __AS=$?
    if [ $__AS != 0 ]; then
        echo "Error"'!'" Exit code: $__AS"
    fi
    ((index++)) || true
done
__AMBER_ARRAY_5=("pip install python-lsp-server" "gem install ruby-lsp")
__2_command_lsp=("${__AMBER_ARRAY_5[@]}")
__AMBER_ARRAY_6=("Python LSP" "Ruby LSP")
__3_command_lsp_name=("${__AMBER_ARRAY_6[@]}")
index=0
for lsp in "${__2_command_lsp[@]}"; do
    echo "Install ${__3_command_lsp_name[${index}]}"
    ${lsp}
    __AS=$?
    if [ $__AS != 0 ]; then
        echo "Error"'!'" Exit code: $__AS"
    fi
    ((index++)) || true
done
