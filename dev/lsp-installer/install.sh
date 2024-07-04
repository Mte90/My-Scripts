#!/usr/bin/env bash
# Written in [Amber](https://amber-lang.com/)
# version: 0.3.3-alpha
# date: 2024-07-04 11:50:58
function dir_exist__4_v0 {
	local path=$1
	[ -d "${path}" ]
	__AS=$?
	if [ $__AS != 0 ]; then
		__AF_dir_exist4_v0=0
		return 0
	fi
	__AF_dir_exist4_v0=1
	return 0
}
function file_exist__5_v0 {
	local path=$1
	[ -f "${path}" ]
	__AS=$?
	if [ $__AS != 0 ]; then
		__AF_file_exist5_v0=0
		return 0
	fi
	__AF_file_exist5_v0=1
	return 0
}
function is_command__28_v0 {
	local command=$1
	[ -x "$(command -v ${command})" ]
	__AS=$?
	if [ $__AS != 0 ]; then
		__AF_is_command28_v0=0
		return 0
	fi
	__AF_is_command28_v0=1
	return 0
}
function make_executable__31_v0 {
	local path=$1
	file_exist__5_v0 "${path}"
	__AF_file_exist5_v0__180_8=$__AF_file_exist5_v0
	if [ $__AF_file_exist5_v0__180_8 != 0 ]; then
		chmod +x "${path}"
		__AS=$?
		__AF_make_executable31_v0=1
		return 0
	fi
	echo "The file ${path} doesn't exist!"
	__AF_make_executable31_v0=0
	return 0
}
function download__33_v0 {
	local url=$1
	local path=$2
	is_command__28_v0 "curl"
	__AF_is_command28_v0__200_9=$__AF_is_command28_v0
	is_command__28_v0 "wget"
	__AF_is_command28_v0__203_9=$__AF_is_command28_v0
	is_command__28_v0 "aria2c"
	__AF_is_command28_v0__206_9=$__AF_is_command28_v0
	if [ $__AF_is_command28_v0__200_9 != 0 ]; then
		curl -o "${path}" "${url}"
		__AS=$?
	elif [ $__AF_is_command28_v0__203_9 != 0 ]; then
		wget "${url}" -P "${path}"
		__AS=$?
	elif [ $__AF_is_command28_v0__206_9 != 0 ]; then
		aria2c "${url}" -d "${path}"
		__AS=$?
	else
		__AF_download33_v0=0
		return 0
	fi
	__AF_download33_v0=1
	return 0
}
function get_download_path__40_v0 {
	local repo=$1
	local position=$2
	__AMBER_VAL_0=$(curl -sL https://api.github.com/repos/${repo}/releases | jq -r ".[0].assets.[${position}].browser_download_url")
	__AS=$?
	__AF_get_download_path40_v0="${__AMBER_VAL_0}"
	return 0
}
function move_to_bin__41_v0 {
	local binary=$1
	mv ${binary} /usr/local/bin
	__AS=$?
	make_executable__31_v0 "/usr/local/bin/${binary}"
	__AF_make_executable31_v0__9_5=$__AF_make_executable31_v0
	echo $__AF_make_executable31_v0__9_5 >/dev/null 2>&1
}
cd /tmp >/dev/null 2>&1
__AS=$?
echo "Install PHPactor LSP"
get_download_path__40_v0 "phpactor/phpactor" 0
__AF_get_download_path40_v0__15_20="${__AF_get_download_path40_v0}"
__0_download_url="${__AF_get_download_path40_v0__15_20}"
download__33_v0 "${__0_download_url}" "phpactor"
__AF_download33_v0__16_1=$__AF_download33_v0
echo $__AF_download33_v0__16_1 >/dev/null 2>&1
move_to_bin__41_v0 "phpactor"
__AF_move_to_bin41_v0__17_1=$__AF_move_to_bin41_v0
echo $__AF_move_to_bin41_v0__17_1 >/dev/null 2>&1
echo "Install Typos LSP"
get_download_path__40_v0 "tekumara/typos-lsp" 6
__AF_get_download_path40_v0__20_20="${__AF_get_download_path40_v0}"
__1_download_url="${__AF_get_download_path40_v0__20_20}"
download__33_v0 "${__1_download_url}" "typos.tar.gz"
__AF_download33_v0__21_1=$__AF_download33_v0
echo $__AF_download33_v0__21_1 >/dev/null 2>&1
tar -zxvf ./typos.tar.gz -C ./typos-lsp >/dev/null 2>&1
__AS=$?
move_to_bin__41_v0 "typos-lsp"
__AF_move_to_bin41_v0__25_1=$__AF_move_to_bin41_v0
echo $__AF_move_to_bin41_v0__25_1 >/dev/null 2>&1
echo "Install GitLab CI LSP"
get_download_path__40_v0 "alesbrelih/gitlab-ci-ls" 3
__AF_get_download_path40_v0__28_20="${__AF_get_download_path40_v0}"
__2_download_url="${__AF_get_download_path40_v0__28_20}"
download__33_v0 "${__2_download_url}" "gitlab-ci-ls"
__AF_download33_v0__29_1=$__AF_download33_v0
echo $__AF_download33_v0__29_1 >/dev/null 2>&1
move_to_bin__41_v0 "gitlab-ci-ls"
__AF_move_to_bin41_v0__30_1=$__AF_move_to_bin41_v0
echo $__AF_move_to_bin41_v0__30_1 >/dev/null 2>&1
echo "Install HTMX LSP"
get_download_path__40_v0 "ThePrimeagen/htmx-lsp" 2
__AF_get_download_path40_v0__33_20="${__AF_get_download_path40_v0}"
__3_download_url="${__AF_get_download_path40_v0__33_20}"
download__33_v0 "${__3_download_url}" "htmx-lsp"
__AF_download33_v0__34_1=$__AF_download33_v0
echo $__AF_download33_v0__34_1 >/dev/null 2>&1
move_to_bin__41_v0 "htmx-lsp"
__AF_move_to_bin41_v0__35_1=$__AF_move_to_bin41_v0
echo $__AF_move_to_bin41_v0__35_1 >/dev/null 2>&1
echo "Install Marksman LSP"
get_download_path__40_v0 "artempyanykh/marksman" 1
__AF_get_download_path40_v0__38_20="${__AF_get_download_path40_v0}"
__4_download_url="${__AF_get_download_path40_v0__38_20}"
download__33_v0 "${__4_download_url}" "marksman"
__AF_download33_v0__39_1=$__AF_download33_v0
echo $__AF_download33_v0__39_1 >/dev/null 2>&1
move_to_bin__41_v0 "marksman"
__AF_move_to_bin41_v0__40_1=$__AF_move_to_bin41_v0
echo $__AF_move_to_bin41_v0__40_1 >/dev/null 2>&1
echo "Install Lua LSP"
dir_exist__4_v0 "/opt/lua-language-server"
__AF_dir_exist4_v0__43_8=$__AF_dir_exist4_v0
if [ $(echo '!' $__AF_dir_exist4_v0__43_8 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
	cd /opt/
	__AS=$?
	git clone https://github.com/LuaLS/lua-language-server
	__AS=$?
else
	cd /opt/lua-language-server
	__AS=$?
fi
cd lua-language-server >/dev/null 2>&1
__AS=$?
git pull >/dev/null 2>&1
__AS=$?
./make.sh >/dev/null 2>&1
__AS=$?
ln -s /opt/lua-language-server/bin/lua-language-server /usr/local/bin/lua-language-server >/dev/null 2>&1
__AS=$?
cd /tmp >/dev/null 2>&1
__AS=$?
__AMBER_ARRAY_0=("vscode-langservers-extracted" "@tailwindcss/language-server" "@olrtg/emmet-language-server" "intelephense" "bash-language-server")
__5_npm_lsp=("${__AMBER_ARRAY_0[@]}")
__AMBER_ARRAY_1=("CSS, HTML, JSON LSP" "Tailwind LSP" "Emmet LSP" "Intelephense LSP" "Bash LSP")
__6_npm_lsp_name=("${__AMBER_ARRAY_1[@]}")
index=0
for lsp in "${__5_npm_lsp[@]}"; do
	echo "Install ${__6_npm_lsp_name[${index}]}"
	npm i -g ${lsp}
	__AS=$?
	if [ $__AS != 0 ]; then
		echo "Error! Exit code: $__AS"
	fi
	((index++)) || true
done
__AMBER_ARRAY_2=("pip install python-lsp-server" "gem install ruby-lsp")
__7_command_lsp=("${__AMBER_ARRAY_2[@]}")
__AMBER_ARRAY_3=("Python LSP" "Ruby LSP")
__8_command_lsp_name=("${__AMBER_ARRAY_3[@]}")
index=0
for lsp in "${__7_command_lsp[@]}"; do
	echo "Install ${__8_command_lsp_name[${index}]}"
	${lsp}
	__AS=$?
	if [ $__AS != 0 ]; then
		echo "Error! Exit code: $__AS"
	fi
	((index++)) || true
done
