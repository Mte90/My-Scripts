#!/usr/bin/env bash
# Written in [Amber](https://amber-lang.com/)
# version: 0.4.0-alpha
# date: 2025-03-04 11:10:10
text_contains__14_v0() {
    local text=$1
    local phrase=$2
    __0_command=$(if [[ "${text}" == *"${phrase}"* ]]; then
        echo 1
    fi)
    __status=$?
    result="${__0_command}"
    __ret_text_contains14_v0=$(
        [ "_${result}" != "_"1"" ]
        echo $?
    )
    return 0
}

dir_exists__32_v0() {
    local path=$1
    [ -d "${path}" ]
    __status=$?
    if [ $__status != 0 ]; then
        __ret_dir_exists32_v0=0
        return 0
    fi
    __ret_dir_exists32_v0=1
    return 0
}
file_exists__33_v0() {
    local path=$1
    [ -f "${path}" ]
    __status=$?
    if [ $__status != 0 ]; then
        __ret_file_exists33_v0=0
        return 0
    fi
    __ret_file_exists33_v0=1
    return 0
}

symlink_create__37_v0() {
    local origin=$1
    local destination=$2
    file_exists__33_v0 "${origin}"
    __ret_file_exists33_v0__41_8="$__ret_file_exists33_v0"
    if [ ${__ret_file_exists33_v0__41_8} != 0 ]; then
        ln -s "${origin}" "${destination}"
        __status=$?
        __ret_symlink_create37_v0=1
        return 0
    fi
    echo "The file ${origin} doesn't exist"'!'""
    __ret_symlink_create37_v0=0
    return 0
}

file_chmod__39_v0() {
    local path=$1
    local mode=$2
    file_exists__33_v0 "${path}"
    __ret_file_exists33_v0__61_8="$__ret_file_exists33_v0"
    if [ ${__ret_file_exists33_v0__61_8} != 0 ]; then
        chmod "${mode}" "${path}"
        __status=$?
        __ret_file_chmod39_v0=1
        return 0
    fi
    echo "The file ${path} doesn't exist"'!'""
    __ret_file_chmod39_v0=0
    return 0
}

is_command__96_v0() {
    local command=$1
    [ -x "$(command -v ${command})" ]
    __status=$?
    if [ $__status != 0 ]; then
        __ret_is_command96_v0=0
        return 0
    fi
    __ret_is_command96_v0=1
    return 0
}

is_root__101_v0() {
    __1_command=$(id -u)
    __status=$?
    if [ $(
        [ "_${__1_command}" != "_"0"" ]
        echo $?
    ) != 0 ]; then
        __ret_is_root101_v0=1
        return 0
    fi
    __ret_is_root101_v0=0
    return 0
}

file_download__138_v0() {
    local url=$1
    local path=$2
    is_command__96_v0 "curl"
    __ret_is_command96_v0__9_9="$__ret_is_command96_v0"
    is_command__96_v0 "wget"
    __ret_is_command96_v0__12_9="$__ret_is_command96_v0"
    is_command__96_v0 "aria2c"
    __ret_is_command96_v0__15_9="$__ret_is_command96_v0"
    if [ ${__ret_is_command96_v0__9_9} != 0 ]; then
        curl -L -o "${path}" "${url}"
        __status=$?
    elif [ ${__ret_is_command96_v0__12_9} != 0 ]; then
        wget "${url}" -P "${path}"
        __status=$?
    elif [ ${__ret_is_command96_v0__15_9} != 0 ]; then
        aria2c "${url}" -d "${path}"
        __status=$?
    else
        __ret_file_download138_v0=0
        return 0
    fi
    __ret_file_download138_v0=1
    return 0
}
is_root__101_v0
__ret_is_root101_v0__6_8="$__ret_is_root101_v0"
if [ $(echo '!' ${__ret_is_root101_v0__6_8} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
    echo "This script requires root permissions"'!'""
    exit 1
fi
get_download_path__142_v0() {
    local repo=$1
    local position=$2
    __2_command=$(curl -sL "https://api.github.com/repos/${repo}/releases" | jq -r ".[0].assets.[${position}].browser_download_url")
    __status=$?
    __ret_get_download_path142_v0="${__2_command}"
    return 0
}
move_to_bin__143_v0() {
    local download_url=$1
    local binary=$2
    file_download__138_v0 "${download_url}" "${binary}" >/dev/null 2>&1
    __ret_file_download138_v0__16_15="$__ret_file_download138_v0"
    if [ ${__ret_file_download138_v0__16_15} != 0 ]; then
        mv "${binary}" "/usr/local/bin"
        __status=$?
        if [ $__status != 0 ]; then
            echo "Move ${binary} to /usr/local/bin failed"'!'""
            exit 1
        fi
        file_chmod__39_v0 "/usr/local/bin/${binary}" "+x"
        __ret_file_chmod39_v0__21_9="$__ret_file_chmod39_v0"
        echo ${__ret_file_chmod39_v0__21_9} >/dev/null 2>&1
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
    __ret_file_download138_v0__29_15="$__ret_file_download138_v0"
    if [ ${__ret_file_download138_v0__29_15} != 0 ]; then
        text_contains__14_v0 "${packed_file}" "tar.gz"
        __ret_text_contains14_v0__31_16="$__ret_text_contains14_v0"
        if [ ${__ret_text_contains14_v0__31_16} != 0 ]; then
            tar -zxvf "./${packed_file}" -C ./ >/dev/null 2>&1
            __status=$?
            mv "./${binary}" "/usr/local/bin"
            __status=$?
        else
            gunzip -c ${packed_file} >"/usr/local/bin/${binary}"
            __status=$?
        fi
        rm "./${packed_file}"
        __status=$?
        file_chmod__39_v0 "/usr/local/bin/${binary}" "+x"
        __ret_file_chmod39_v0__39_9="$__ret_file_chmod39_v0"
        echo ${__ret_file_chmod39_v0__39_9} >/dev/null 2>&1
    else
        echo "Download for ${binary} at ${download_url} failed"
        exit 1
    fi
}
cd "/tmp" || exit
echo "Install PHPactor LSP"
get_download_path__142_v0 "phpactor/phpactor" 0
__ret_get_download_path142_v0__49_13="${__ret_get_download_path142_v0}"
move_to_bin__143_v0 "${__ret_get_download_path142_v0__49_13}" "phpactor"
__ret_move_to_bin143_v0__49_1="$__ret_move_to_bin143_v0"
echo ${__ret_move_to_bin143_v0__49_1} >/dev/null 2>&1
echo "Install Typos LSP"
get_download_path__142_v0 "tekumara/typos-lsp" 7
__ret_get_download_path142_v0__52_17="${__ret_get_download_path142_v0}"
download_to_bin__144_v0 "${__ret_get_download_path142_v0__52_17}" "typos-lsp" "typos.tar.gz"
__ret_download_to_bin144_v0__52_1="$__ret_download_to_bin144_v0"
echo ${__ret_download_to_bin144_v0__52_1} >/dev/null 2>&1
echo "Install Rust LSP"
download_to_bin__144_v0 "https://github.com/rust-lang/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-unknown-linux-gnu.gz" "rust-analyzer" "rust-analyzer-x86_64-unknown-linux-gnu.gz"
__ret_download_to_bin144_v0__55_1="$__ret_download_to_bin144_v0"
echo ${__ret_download_to_bin144_v0__55_1} >/dev/null 2>&1
echo "Install GitLab CI LSP"
get_download_path__142_v0 "alesbrelih/gitlab-ci-ls" 1
__ret_get_download_path142_v0__58_13="${__ret_get_download_path142_v0}"
move_to_bin__143_v0 "${__ret_get_download_path142_v0__58_13}" "x86_64-unknown-linux-gnu"
__ret_move_to_bin143_v0__58_1="$__ret_move_to_bin143_v0"
echo ${__ret_move_to_bin143_v0__58_1} >/dev/null 2>&1
echo "Install HTMX LSP"
get_download_path__142_v0 "ThePrimeagen/htmx-lsp" 2
__ret_get_download_path142_v0__61_13="${__ret_get_download_path142_v0}"
move_to_bin__143_v0 "${__ret_get_download_path142_v0__61_13}" "htmx-lsp"
__ret_move_to_bin143_v0__61_1="$__ret_move_to_bin143_v0"
echo ${__ret_move_to_bin143_v0__61_1} >/dev/null 2>&1
echo "Install Marksman LSP"
get_download_path__142_v0 "artempyanykh/marksman" 1
__ret_get_download_path142_v0__64_13="${__ret_get_download_path142_v0}"
move_to_bin__143_v0 "${__ret_get_download_path142_v0__64_13}" "marksman"
__ret_move_to_bin143_v0__64_1="$__ret_move_to_bin143_v0"
echo ${__ret_move_to_bin143_v0__64_1} >/dev/null 2>&1
echo "Install Lua LSP"
dir_exists__32_v0 "/opt/lua-language-server"
__ret_dir_exists32_v0__67_8="$__ret_dir_exists32_v0"
if [ $(echo '!' ${__ret_dir_exists32_v0__67_8} | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
    cd "/opt/" || exit
    git clone https://github.com/LuaLS/lua-language-server
    __status=$?
    cd "lua-language-server" || exit
else
    cd "/opt/lua-language-server" || exit
fi
git pull >/dev/null 2>&1
__status=$?
./make.sh >/dev/null 2>&1
__status=$?
symlink_create__37_v0 "/opt/lua-language-server/bin/lua-language-server" "/usr/local/bin/lua-language-server"
__ret_symlink_create37_v0__78_1="$__ret_symlink_create37_v0"
echo ${__ret_symlink_create37_v0__78_1} >/dev/null 2>&1
cd "/tmp" || exit
__3_array=("vscode-langservers-extracted" "@tailwindcss/language-server" "@olrtg/emmet-language-server" "intelephense" "bash-language-server")
__0_npm_lsp=("${__3_array[@]}")
__4_array=("CSS, HTML, JSON LSP" "Tailwind LSP" "Emmet LSP" "Intelephense LSP" "Bash LSP")
__1_npm_lsp_name=("${__4_array[@]}")
index=0
for lsp in "${__0_npm_lsp[@]}"; do
    echo "Install ${__1_npm_lsp_name[${index}]}"
    npm i -g "${lsp}"
    __status=$?
    if [ $__status != 0 ]; then
        echo "Error"'!'" Exit code: $__status"
    fi
    ((index++)) || true
done
__5_array=("pip install python-lsp-server" "gem install ruby-lsp")
__2_command_lsp=("${__5_array[@]}")
__6_array=("Python LSP" "Ruby LSP")
__3_command_lsp_name=("${__6_array[@]}")
index=0
for lsp in "${__2_command_lsp[@]}"; do
    echo "Install ${__3_command_lsp_name[${index}]}"
    ${lsp}
    __status=$?
    if [ $__status != 0 ]; then
        echo "Error"'!'" Exit code: $__status"
    fi
    ((index++)) || true
done
