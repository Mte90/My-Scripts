#!/usr/bin/env bash
# Written in [Amber](https://amber-lang.com/)
# version: 0.4.0-alpha-74-g5c640c1
# We cannot import `bash_version` from `env.ab` because it imports `text.ab` making a circular dependency.
# This is a workaround to avoid that issue and the import system should be improved in the future.
text_contains__17_v0() {
    local source=$1
    local search=$2
    result_3="$(if [[ "${source}" == *"${search}"* ]]; then
    echo 1
  fi)"
    ret_text_contains17_v0="$([ "_${result_3}" != "_1" ]; echo $?)"
    return 0
}

dir_exists__36_v0() {
    local path=$1
    [ -d "${path}" ]
    __status=$?
    ret_dir_exists36_v0="$(( ${__status} == 0 ))"
    return 0
}

file_exists__37_v0() {
    local path=$1
    [ -f "${path}" ]
    __status=$?
    ret_file_exists37_v0="$(( ${__status} == 0 ))"
    return 0
}

symlink_create__41_v0() {
    local origin=$1
    local destination=$2
    file_exists__37_v0 "${origin}"
    ret_file_exists37_v0__37_8="${ret_file_exists37_v0}"
    if [ "${ret_file_exists37_v0__37_8}" != 0 ]; then
        ln -s "${origin}" "${destination}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_symlink_create41_v0=''
            return "${__status}"
        fi
        ret_symlink_create41_v0=''
        return 0
    fi
    echo "The file ${origin} doesn't exist"'!'""
    ret_symlink_create41_v0=''
    return 1
}

file_chmod__45_v0() {
    local path=$1
    local mode=$2
    file_exists__37_v0 "${path}"
    ret_file_exists37_v0__104_8="${ret_file_exists37_v0}"
    if [ "${ret_file_exists37_v0__104_8}" != 0 ]; then
        chmod "${mode}" "${path}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_file_chmod45_v0=''
            return "${__status}"
        fi
        ret_file_chmod45_v0=''
        return 0
    fi
    echo "The file ${path} doesn't exist"'!'""
    ret_file_chmod45_v0=''
    return 1
}

is_command__104_v0() {
    local command=$1
    [ -x "$(command -v "${command}")" ]
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_is_command104_v0=0
        return 0
    fi
    ret_is_command104_v0=1
    return 0
}

is_root__109_v0() {
    command_1="$(id -u)"
    __status=$?
    if [ "$([ "_${command_1}" != "_0" ]; echo $?)" != 0 ]; then
        ret_is_root109_v0=1
        return 0
    fi
    ret_is_root109_v0=0
    return 0
}

file_download__148_v0() {
    local url=$1
    local path=$2
    is_command__104_v0 "curl"
    ret_is_command104_v0__9_9="${ret_is_command104_v0}"
    is_command__104_v0 "wget"
    ret_is_command104_v0__12_9="${ret_is_command104_v0}"
    is_command__104_v0 "aria2c"
    ret_is_command104_v0__15_9="${ret_is_command104_v0}"
    if [ "${ret_is_command104_v0__9_9}" != 0 ]; then
        curl -L -o "${path}" "${url}" >/dev/null 2>&1
        __status=$?
    elif [ "${ret_is_command104_v0__12_9}" != 0 ]; then
        wget "${url}" -P "${path}" >/dev/null 2>&1
        __status=$?
    elif [ "${ret_is_command104_v0__15_9}" != 0 ]; then
        aria2c "${url}" -d "${path}" >/dev/null 2>&1
        __status=$?
    else
        ret_file_download148_v0=''
        return 1
    fi
}

is_root__109_v0 
ret_is_root109_v0__6_8="${ret_is_root109_v0}"
if [ "$(( ! ${ret_is_root109_v0__6_8} ))" != 0 ]; then
    echo "This script requires root permissions"'!'""
    exit 1
fi
get_download_path__152_v0() {
    local repo=$1
    local position=$2
    command_2="$(curl -sL "https://api.github.com/repos/${repo}/releases" | jq -r ".[0].assets.[${position}].browser_download_url")"
    __status=$?
    ret_get_download_path152_v0="${command_2}"
    return 0
}

move_to_bin__153_v0() {
    local download_url=$1
    local binary=$2
    file_download__148_v0 "${download_url}" "${binary}">/dev/null 2>&1
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_move_to_bin153_v0=''
        return "${__status}"
    fi
    if [ '' != 0 ]; then
        mv "${binary}" "/usr/local/bin"
        __status=$?
        if [ "${__status}" != 0 ]; then
            echo "Move ${binary} to /usr/local/bin failed"'!'""
            exit 1
        fi
        file_chmod__45_v0 "/usr/local/bin/${binary}" "+x"
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_move_to_bin153_v0=''
            return "${__status}"
        fi
    else
        echo "Download for ${binary} at ${download_url} failed"
        exit 1
    fi
}

download_to_bin__154_v0() {
    local download_url=$1
    local binary=$2
    local packed_file=$3
    file_download__148_v0 "${download_url}" "${packed_file}">/dev/null 2>&1
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_download_to_bin154_v0=''
        return "${__status}"
    fi
    if [ '' != 0 ]; then
        text_contains__17_v0 "${packed_file}" "tar.gz"
        ret_text_contains17_v0__31_16="${ret_text_contains17_v0}"
        if [ "${ret_text_contains17_v0__31_16}" != 0 ]; then
            tar -zxvf "./${packed_file}" -C ./ > /dev/null 2>&1
            __status=$?
            mv "./${binary}" "/usr/local/bin"
            __status=$?
        else
            gunzip -c "${packed_file}" > "/usr/local/bin/${binary}"
            __status=$?
        fi
        rm "./${packed_file}"
        __status=$?
        file_chmod__45_v0 "/usr/local/bin/${binary}" "+x"
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_download_to_bin154_v0=''
            return "${__status}"
        fi
    else
        echo "Download for ${binary} at ${download_url} failed"
        exit 1
    fi
}

cd "/tmp" || exit
echo "Install PHPactor LSP"
get_download_path__152_v0 "phpactor/phpactor" 0
ret_get_download_path152_v0__50_17="${ret_get_download_path152_v0}"
move_to_bin__153_v0 "${ret_get_download_path152_v0__50_17}" "phpactor"
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
echo "Install Typos LSP"
get_download_path__152_v0 "tekumara/typos-lsp" 7
ret_get_download_path152_v0__53_21="${ret_get_download_path152_v0}"
download_to_bin__154_v0 "${ret_get_download_path152_v0__53_21}" "typos-lsp" "typos.tar.gz"
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
echo "Install Rust LSP"
download_to_bin__154_v0 "https://github.com/rust-lang/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-unknown-linux-gnu.gz" "rust-analyzer" "rust-analyzer-x86_64-unknown-linux-gnu.gz"
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
echo "Install GitLab CI LSP"
get_download_path__152_v0 "alesbrelih/gitlab-ci-ls" 1
ret_get_download_path152_v0__59_17="${ret_get_download_path152_v0}"
move_to_bin__153_v0 "${ret_get_download_path152_v0__59_17}" "x86_64-unknown-linux-gnu"
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
echo "Install HTMX LSP"
get_download_path__152_v0 "ThePrimeagen/htmx-lsp" 2
ret_get_download_path152_v0__62_17="${ret_get_download_path152_v0}"
move_to_bin__153_v0 "${ret_get_download_path152_v0__62_17}" "htmx-lsp"
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
echo "Install Marksman LSP"
get_download_path__152_v0 "artempyanykh/marksman" 1
ret_get_download_path152_v0__65_17="${ret_get_download_path152_v0}"
move_to_bin__153_v0 "${ret_get_download_path152_v0__65_17}" "marksman"
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
echo "Install Lua LSP"
dir_exists__36_v0 "/opt/lua-language-server"
ret_dir_exists36_v0__68_12="${ret_dir_exists36_v0}"
if [ "$(( ! ${ret_dir_exists36_v0__68_12} ))" != 0 ]; then
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
symlink_create__41_v0 "/opt/lua-language-server/bin/lua-language-server" "/usr/local/bin/lua-language-server"
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
cd "/tmp" || exit
npm_lsp_4=("vscode-langservers-extracted" "@tailwindcss/language-server" "@olrtg/emmet-language-server" "intelephense" "bash-language-server")
npm_lsp_name_5=("CSS, HTML, JSON LSP" "Tailwind LSP" "Emmet LSP" "Intelephense LSP" "Bash LSP")
index_7=0;
for lsp_6 in "${npm_lsp_4[@]}"; do
    echo "Install ${npm_lsp_name_5[${index_7}]}"
    npm i -g "${lsp_6}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo "Error"'!'" Exit code: ${__status}"
    fi
    (( index_7++ )) || true
done
command_lsp_8=("pip install python-lsp-server" "gem install ruby-lsp")
command_lsp_name_9=("Python LSP" "Ruby LSP")
index_11=0;
for lsp_10 in "${command_lsp_8[@]}"; do
    echo "Install ${command_lsp_name_9[${index_11}]}"
    ${lsp_10}
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo "Error"'!'" Exit code: ${__status}"
    fi
    (( index_11++ )) || true
done
