#!/usr/bin/env bash
# Written in [Amber](https://amber-lang.com/)
# version: 0.4.0-alpha-43-g45cd2fa
# date: 2025-08-04 11:23:35
# We cannot import `bash_version` from `env.ab` because it imports `text.ab` making a circular dependency.
# This is a workaround to avoid that issue and the import system should be improved in the future.
text_contains__16_v0() {
    local source=$1
    local search=$2
    __3_result="$(if [[ "${source}" == *"${search}"* ]]; then
    echo 1
  fi)"
    __ret_text_contains16_v0="$([ "_${__3_result}" != "_1" ]; echo $?)"
    return 0
}

dir_exists__35_v0() {
    local path=$1
    [ -d "${path}" ]
    __status=$?
    if [ "${__status}" != 0 ]; then
        __ret_dir_exists35_v0=0
        return 0
    fi
    __ret_dir_exists35_v0=1
    return 0
}

file_exists__36_v0() {
    local path=$1
    [ -f "${path}" ]
    __status=$?
    if [ "${__status}" != 0 ]; then
        __ret_file_exists36_v0=0
        return 0
    fi
    __ret_file_exists36_v0=1
    return 0
}

symlink_create__40_v0() {
    local origin=$1
    local destination=$2
    file_exists__36_v0 "${origin}"
    __ret_file_exists36_v0__41_8="${__ret_file_exists36_v0}"
    if [ "${__ret_file_exists36_v0__41_8}" != 0 ]; then
        ln -s "${origin}" "${destination}"
        __ret_symlink_create40_v0=1
        return 0
    fi
    echo "The file ${origin} doesn't exist"'!'""
    __ret_symlink_create40_v0=0
    return 0
}

file_chmod__44_v0() {
    local path=$1
    local mode=$2
    file_exists__36_v0 "${path}"
    __ret_file_exists36_v0__108_8="${__ret_file_exists36_v0}"
    if [ "${__ret_file_exists36_v0__108_8}" != 0 ]; then
        chmod "${mode}" "${path}"
        __ret_file_chmod44_v0=1
        return 0
    fi
    echo "The file ${path} doesn't exist"'!'""
    __ret_file_chmod44_v0=0
    return 0
}

is_command__102_v0() {
    local command=$1
    [ -x "$(command -v "${command}")" ]
    __status=$?
    if [ "${__status}" != 0 ]; then
        __ret_is_command102_v0=0
        return 0
    fi
    __ret_is_command102_v0=1
    return 0
}

is_root__107_v0() {
    __1_command="$(id -u)"
    if [ "$([ "_${__1_command}" != "_0" ]; echo $?)" != 0 ]; then
        __ret_is_root107_v0=1
        return 0
    fi
    __ret_is_root107_v0=0
    return 0
}

file_download__146_v0() {
    local url=$1
    local path=$2
    is_command__102_v0 "curl"
    __ret_is_command102_v0__9_9="${__ret_is_command102_v0}"
    is_command__102_v0 "wget"
    __ret_is_command102_v0__12_9="${__ret_is_command102_v0}"
    is_command__102_v0 "aria2c"
    __ret_is_command102_v0__15_9="${__ret_is_command102_v0}"
    if [ "${__ret_is_command102_v0__9_9}" != 0 ]; then
        curl -L -o "${path}" "${url}" >/dev/null 2>&1
    elif [ "${__ret_is_command102_v0__12_9}" != 0 ]; then
        wget "${url}" -P "${path}" >/dev/null 2>&1
    elif [ "${__ret_is_command102_v0__15_9}" != 0 ]; then
        aria2c "${url}" -d "${path}" >/dev/null 2>&1
    else
        __ret_file_download146_v0=0
        return 0
    fi
    __ret_file_download146_v0=1
    return 0
}

is_root__107_v0 
__ret_is_root107_v0__6_8="${__ret_is_root107_v0}"
if [ "$(( ! ${__ret_is_root107_v0__6_8} ))" != 0 ]; then
    echo "This script requires root permissions"'!'""
    exit 1
fi
get_download_path__150_v0() {
    local repo=$1
    local position=$2
    __2_command="$(curl -sL "https://api.github.com/repos/${repo}/releases" | jq -r ".[0].assets.[${position}].browser_download_url")"
    __status=$?
    __ret_get_download_path150_v0="${__2_command}"
    return 0
}

move_to_bin__151_v0() {
    local download_url=$1
    local binary=$2
    file_download__146_v0 "${download_url}" "${binary}" >/dev/null 2>&1
    __ret_file_download146_v0__16_15="${__ret_file_download146_v0}"
    if [ "${__ret_file_download146_v0__16_15}" != 0 ]; then
        mv "${binary}" "/usr/local/bin"
        __status=$?
        if [ "${__status}" != 0 ]; then
            echo "Move ${binary} to /usr/local/bin failed"'!'""
            exit 1
        fi
        file_chmod__44_v0 "/usr/local/bin/${binary}" "+x"
    else
        echo "Download for ${binary} at ${download_url} failed"
        exit 1
    fi
}

download_to_bin__152_v0() {
    local download_url=$1
    local binary=$2
    local packed_file=$3
    file_download__146_v0 "${download_url}" "${packed_file}" >/dev/null 2>&1
    __ret_file_download146_v0__29_15="${__ret_file_download146_v0}"
    if [ "${__ret_file_download146_v0__29_15}" != 0 ]; then
        text_contains__16_v0 "${packed_file}" "tar.gz"
        __ret_text_contains16_v0__31_16="${__ret_text_contains16_v0}"
        if [ "${__ret_text_contains16_v0__31_16}" != 0 ]; then
            tar -zxvf "./${packed_file}" -C ./ > /dev/null 2>&1
            mv "./${binary}" "/usr/local/bin"
        else
            gunzip -c "${packed_file}" > "/usr/local/bin/${binary}"
        fi
        rm "./${packed_file}"
        file_chmod__44_v0 "/usr/local/bin/${binary}" "+x"
    else
        echo "Download for ${binary} at ${download_url} failed"
        exit 1
    fi
}

cd "/tmp" || exit
echo "Install PHPactor LSP"
get_download_path__150_v0 "phpactor/phpactor" 0
__ret_get_download_path150_v0__49_13="${__ret_get_download_path150_v0}"
move_to_bin__151_v0 "${__ret_get_download_path150_v0__49_13}" "phpactor"
echo "Install Typos LSP"
get_download_path__150_v0 "tekumara/typos-lsp" 7
__ret_get_download_path150_v0__52_17="${__ret_get_download_path150_v0}"
download_to_bin__152_v0 "${__ret_get_download_path150_v0__52_17}" "typos-lsp" "typos.tar.gz"
echo "Install Rust LSP"
download_to_bin__152_v0 "https://github.com/rust-lang/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-unknown-linux-gnu.gz" "rust-analyzer" "rust-analyzer-x86_64-unknown-linux-gnu.gz"
echo "Install GitLab CI LSP"
get_download_path__150_v0 "alesbrelih/gitlab-ci-ls" 1
__ret_get_download_path150_v0__58_13="${__ret_get_download_path150_v0}"
move_to_bin__151_v0 "${__ret_get_download_path150_v0__58_13}" "x86_64-unknown-linux-gnu"
echo "Install HTMX LSP"
get_download_path__150_v0 "ThePrimeagen/htmx-lsp" 2
__ret_get_download_path150_v0__61_13="${__ret_get_download_path150_v0}"
move_to_bin__151_v0 "${__ret_get_download_path150_v0__61_13}" "htmx-lsp"
echo "Install Marksman LSP"
get_download_path__150_v0 "artempyanykh/marksman" 1
__ret_get_download_path150_v0__64_13="${__ret_get_download_path150_v0}"
move_to_bin__151_v0 "${__ret_get_download_path150_v0__64_13}" "marksman"
echo "Install Lua LSP"
dir_exists__35_v0 "/opt/lua-language-server"
__ret_dir_exists35_v0__67_8="${__ret_dir_exists35_v0}"
if [ "$(( ! ${__ret_dir_exists35_v0__67_8} ))" != 0 ]; then
    cd "/opt/" || exit
    git clone https://github.com/LuaLS/lua-language-server
    cd "lua-language-server" || exit
else
    cd "/opt/lua-language-server" || exit
fi
git pull >/dev/null 2>&1
./make.sh >/dev/null 2>&1
__status=$?
symlink_create__40_v0 "/opt/lua-language-server/bin/lua-language-server" "/usr/local/bin/lua-language-server"
cd "/tmp" || exit
__4_npm_lsp=("vscode-langservers-extracted" "@tailwindcss/language-server" "@olrtg/emmet-language-server" "intelephense" "bash-language-server")
__5_npm_lsp_name=("CSS, HTML, JSON LSP" "Tailwind LSP" "Emmet LSP" "Intelephense LSP" "Bash LSP")
__7_index=0;
for __6_lsp in "${__4_npm_lsp[@]}"; do
    echo "Install ${__5_npm_lsp_name[${__7_index}]}"
    npm i -g "${__6_lsp}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo "Error"'!'" Exit code: ${__status}"
    fi
    (( __7_index++ )) || true
done
__8_command_lsp=("pip install python-lsp-server" "gem install ruby-lsp")
__9_command_lsp_name=("Python LSP" "Ruby LSP")
__11_index=0;
for __10_lsp in "${__8_command_lsp[@]}"; do
    echo "Install ${__9_command_lsp_name[${__11_index}]}"
    ${__10_lsp}
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo "Error"'!'" Exit code: ${__status}"
    fi
    (( __11_index++ )) || true
done