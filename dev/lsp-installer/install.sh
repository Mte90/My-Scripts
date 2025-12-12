#!/usr/bin/env bash
# Written in [Amber](https://amber-lang.com/)
# version: nightly-4-g38fe480
# We cannot import `bash_version` from `env.ab` because it imports `text.ab` making a circular dependency.
# This is a workaround to avoid that issue and the import system should be improved in the future.
text_contains__17_v0() {
    local source_16="${1}"
    local search_17="${2}"
    [[ "${source_16}" == *"${search_17}"* ]]
    __status=$?
    ret_text_contains17_v0="$(( __status == 0 ))"
    return 0
}

dir_exists__36_v0() {
    local path_18="${1}"
    [ -d "${path_18}" ]
    __status=$?
    ret_dir_exists36_v0="$(( __status == 0 ))"
    return 0
}

file_exists__37_v0() {
    local path_12="${1}"
    [ -f "${path_12}" ]
    __status=$?
    ret_file_exists37_v0="$(( __status == 0 ))"
    return 0
}

symlink_create__41_v0() {
    local origin_19="${1}"
    local destination_20="${2}"
    file_exists__37_v0 "${origin_19}"
    local ret_file_exists37_v0__71_8="${ret_file_exists37_v0}"
    if [ "${ret_file_exists37_v0__71_8}" != 0 ]; then
        ln -s "${origin_19}" "${destination_20}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_symlink_create41_v0=''
            return "${__status}"
        fi
        ret_symlink_create41_v0=''
        return 0
    fi
    echo "The file ${origin_19} doesn't exist"'!'""
    ret_symlink_create41_v0=''
    return 1
}

file_chmod__45_v0() {
    local path_10="${1}"
    local mode_11="${2}"
    file_exists__37_v0 "${path_10}"
    local ret_file_exists37_v0__153_8="${ret_file_exists37_v0}"
    if [ "${ret_file_exists37_v0__153_8}" != 0 ]; then
        chmod "${mode_11}" "${path_10}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_file_chmod45_v0=''
            return "${__status}"
        fi
        ret_file_chmod45_v0=''
        return 0
    fi
    echo "The file ${path_10} doesn't exist"'!'""
    ret_file_chmod45_v0=''
    return 1
}

is_command__103_v0() {
    local command_9="${1}"
    [ -x "$(command -v "${command_9}")" ]
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_is_command103_v0=0
        return 0
    fi
    ret_is_command103_v0=1
    return 0
}

is_root__108_v0() {
    local command_0
    command_0="$(id -u)"
    __status=$?
    if [ "$([ "_${command_0}" != "_0" ]; echo $?)" != 0 ]; then
        ret_is_root108_v0=1
        return 0
    fi
    ret_is_root108_v0=0
    return 0
}

file_download__146_v0() {
    local url_7="${1}"
    local path_8="${2}"
    is_command__103_v0 "curl"
    local ret_is_command103_v0__14_9="${ret_is_command103_v0}"
    is_command__103_v0 "wget"
    local ret_is_command103_v0__17_9="${ret_is_command103_v0}"
    is_command__103_v0 "aria2c"
    local ret_is_command103_v0__20_9="${ret_is_command103_v0}"
    if [ "${ret_is_command103_v0__14_9}" != 0 ]; then
        curl -L -o "${path_8}" "${url_7}" >/dev/null 2>&1
        __status=$?
    elif [ "${ret_is_command103_v0__17_9}" != 0 ]; then
        wget "${url_7}" -P "${path_8}" >/dev/null 2>&1
        __status=$?
    elif [ "${ret_is_command103_v0__20_9}" != 0 ]; then
        aria2c "${url_7}" -d "${path_8}" >/dev/null 2>&1
        __status=$?
    else
        ret_file_download146_v0=''
        return 1
    fi
}

is_root__108_v0 
ret_is_root108_v0__6_8="${ret_is_root108_v0}"
if [ "$(( ! ret_is_root108_v0__6_8 ))" != 0 ]; then
    echo "This script requires root permissions"'!'""
    exit 1
fi
get_download_path__150_v0() {
    local repo_3="${1}"
    local position_4="${2}"
    local command_1
    command_1="$(curl -sL "https://api.github.com/repos/${repo_3}/releases" | jq -r ".[0].assets.[${position_4}].browser_download_url")"
    __status=$?
    ret_get_download_path150_v0="${command_1}"
    return 0
}

move_to_bin__151_v0() {
    local download_url_5="${1}"
    local binary_6="${2}"
    file_download__146_v0 "${download_url_5}" "${binary_6}">/dev/null 2>&1
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_move_to_bin151_v0=''
        return "${__status}"
    fi
    if [ '' != 0 ]; then
        mv "${binary_6}" "/usr/local/bin"
        __status=$?
        if [ "${__status}" != 0 ]; then
            echo "Move ${binary_6} to /usr/local/bin failed"'!'""
            exit 1
        fi
        file_chmod__45_v0 "/usr/local/bin/${binary_6}" "+x"
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_move_to_bin151_v0=''
            return "${__status}"
        fi
    else
        echo "Download for ${binary_6} at ${download_url_5} failed"
        exit 1
    fi
}

download_to_bin__152_v0() {
    local download_url_13="${1}"
    local binary_14="${2}"
    local packed_file_15="${3}"
    file_download__146_v0 "${download_url_13}" "${packed_file_15}">/dev/null 2>&1
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_download_to_bin152_v0=''
        return "${__status}"
    fi
    if [ '' != 0 ]; then
        text_contains__17_v0 "${packed_file_15}" "tar.gz"
        local ret_text_contains17_v0__31_16="${ret_text_contains17_v0}"
        if [ "${ret_text_contains17_v0__31_16}" != 0 ]; then
            tar -zxvf "./${packed_file_15}" -C ./ > /dev/null 2>&1
            __status=$?
            mv "./${binary_14}" "/usr/local/bin"
            __status=$?
        else
            gunzip -c "${packed_file_15}" > "/usr/local/bin/${binary_14}"
            __status=$?
        fi
        rm "./${packed_file_15}"
        __status=$?
        file_chmod__45_v0 "/usr/local/bin/${binary_14}" "+x"
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_download_to_bin152_v0=''
            return "${__status}"
        fi
    else
        echo "Download for ${binary_14} at ${download_url_13} failed"
        exit 1
    fi
}

cd "/tmp" || exit
echo "Install PHPactor LSP"
get_download_path__150_v0 "phpactor/phpactor" 0
ret_get_download_path150_v0__50_17="${ret_get_download_path150_v0}"
move_to_bin__151_v0 "${ret_get_download_path150_v0__50_17}" "phpactor"
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
echo "Install Typos LSP"
get_download_path__150_v0 "tekumara/typos-lsp" 7
ret_get_download_path150_v0__53_21="${ret_get_download_path150_v0}"
download_to_bin__152_v0 "${ret_get_download_path150_v0__53_21}" "typos-lsp" "typos.tar.gz"
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
echo "Install Rust LSP"
download_to_bin__152_v0 "https://github.com/rust-lang/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-unknown-linux-gnu.gz" "rust-analyzer" "rust-analyzer-x86_64-unknown-linux-gnu.gz"
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
echo "Install GitLab CI LSP"
get_download_path__150_v0 "alesbrelih/gitlab-ci-ls" 1
ret_get_download_path150_v0__59_17="${ret_get_download_path150_v0}"
move_to_bin__151_v0 "${ret_get_download_path150_v0__59_17}" "x86_64-unknown-linux-gnu"
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
echo "Install HTMX LSP"
get_download_path__150_v0 "ThePrimeagen/htmx-lsp" 2
ret_get_download_path150_v0__62_17="${ret_get_download_path150_v0}"
move_to_bin__151_v0 "${ret_get_download_path150_v0__62_17}" "htmx-lsp"
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
echo "Install Marksman LSP"
get_download_path__150_v0 "artempyanykh/marksman" 1
ret_get_download_path150_v0__65_17="${ret_get_download_path150_v0}"
move_to_bin__151_v0 "${ret_get_download_path150_v0__65_17}" "marksman"
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
echo "Install Lua LSP"
dir_exists__36_v0 "/opt/lua-language-server"
ret_dir_exists36_v0__68_12="${ret_dir_exists36_v0}"
if [ "$(( ! ret_dir_exists36_v0__68_12 ))" != 0 ]; then
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
symlink_create__41_v0 "/opt/lua-language-server/lua-language-server" "/usr/local/bin/lua-language-server"
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
cd "/tmp" || exit
npm_lsp_21=("vscode-langservers-extracted" "@tailwindcss/language-server" "@olrtg/emmet-language-server" "intelephense" "bash-language-server")
npm_lsp_name_22=("CSS, HTML, JSON LSP" "Tailwind LSP" "Emmet LSP" "Intelephense LSP" "Bash LSP")
index_24=0;
for lsp_23 in "${npm_lsp_21[@]}"; do
    echo "Install ${npm_lsp_name_22[${index_24}]}"
    npm i -g "${lsp_23}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo "Error"'!'" Exit code: ${__status}"
    fi
    (( index_24++ )) || true
done
command_lsp_25=("pip install python-lsp-server" "gem install ruby-lsp")
command_lsp_name_26=("Python LSP" "Ruby LSP")
index_28=0;
for lsp_27 in "${command_lsp_25[@]}"; do
    echo "Install ${command_lsp_name_26[${index_28}]}"
    ${lsp_27}
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo "Error"'!'" Exit code: ${__status}"
    fi
    (( index_28++ )) || true
done
