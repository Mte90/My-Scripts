#!/usr/bin/env bash
# Written in [Amber](https://amber-lang.com/)
# version: 0.3.3-alpha
# date: 2024-07-04 12:03:51
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
	local download_url=$1
	local binary=$2
	download__33_v0 "${download_url}" "${binary}"
	__AF_download33_v0__8_8=$__AF_download33_v0
	if [ $__AF_download33_v0__8_8 != 0 ]; then
		mv ${binary} /usr/local/bin
		__AS=$?
		make_executable__31_v0 "/usr/local/bin/${binary}"
		__AF_make_executable31_v0__10_9=$__AF_make_executable31_v0
		echo $__AF_make_executable31_v0__10_9 >/dev/null 2>&1
	else
		echo "Download for ${binary} at ${download_url} failed"
	fi
}
cd /tmp >/dev/null 2>&1
__AS=$?
echo "Install PHPactor LSP"
get_download_path__40_v0 "phpactor/phpactor" 0
__AF_get_download_path40_v0__19_13="${__AF_get_download_path40_v0}"
move_to_bin__41_v0 "${__AF_get_download_path40_v0__19_13}" "phpactor"
__AF_move_to_bin41_v0__19_1=$__AF_move_to_bin41_v0
echo $__AF_move_to_bin41_v0__19_1 >/dev/null 2>&1
echo "Install Typos LSP"
get_download_path__40_v0 "tekumara/typos-lsp" 6
__AF_get_download_path40_v0__22_20="${__AF_get_download_path40_v0}"
__0_download_url="${__AF_get_download_path40_v0__22_20}"
download__33_v0 "${__0_download_url}" "typos.tar.gz"
__AF_download33_v0__23_4=$__AF_download33_v0
if [ $__AF_download33_v0__23_4 != 0 ]; then
	tar -zxvf ./typos.tar.gz -C ./typos-lsp >/dev/null 2>&1
	__AS=$?
	rm ./typos.tar.gz >/dev/null 2>&1
	__AS=$?
	mv typos-lsp /usr/local/bin
	__AS=$?
	make_executable__31_v0 "/usr/local/bin/typos-lsp"
	__AF_make_executable31_v0__29_5=$__AF_make_executable31_v0
	echo $__AF_make_executable31_v0__29_5 >/dev/null 2>&1
fi
echo "Install GitLab CI LSP"
get_download_path__40_v0 "alesbrelih/gitlab-ci-ls" 3
__AF_get_download_path40_v0__33_13="${__AF_get_download_path40_v0}"
move_to_bin__41_v0 "${__AF_get_download_path40_v0__33_13}" "gitlab-ci-ls"
__AF_move_to_bin41_v0__33_1=$__AF_move_to_bin41_v0
echo $__AF_move_to_bin41_v0__33_1 >/dev/null 2>&1
echo "Install HTMX LSP"
get_download_path__40_v0 "ThePrimeagen/htmx-lsp" 2
__AF_get_download_path40_v0__36_13="${__AF_get_download_path40_v0}"
move_to_bin__41_v0 "${__AF_get_download_path40_v0__36_13}" "htmx-lsp"
__AF_move_to_bin41_v0__36_1=$__AF_move_to_bin41_v0
echo $__AF_move_to_bin41_v0__36_1 >/dev/null 2>&1
echo "Install Marksman LSP"
get_download_path__40_v0 "artempyanykh/marksman" 1
__AF_get_download_path40_v0__39_13="${__AF_get_download_path40_v0}"
move_to_bin__41_v0 "${__AF_get_download_path40_v0__39_13}" "marksman"
__AF_move_to_bin41_v0__39_1=$__AF_move_to_bin41_v0
echo $__AF_move_to_bin41_v0__39_1 >/dev/null 2>&1
echo "Install Lua LSP"
dir_exist__4_v0 "/opt/lua-language-server"
__AF_dir_exist4_v0__42_8=$__AF_dir_exist4_v0
if [ $(echo '!' $__AF_dir_exist4_v0__42_8 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
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
__1_npm_lsp=("${__AMBER_ARRAY_0[@]}")
__AMBER_ARRAY_1=("CSS, HTML, JSON LSP" "Tailwind LSP" "Emmet LSP" "Intelephense LSP" "Bash LSP")
__2_npm_lsp_name=("${__AMBER_ARRAY_1[@]}")
index=0
for lsp in "${__1_npm_lsp[@]}"; do
	echo "Install ${__2_npm_lsp_name[${index}]}"
	npm i -g ${lsp}
	__AS=$?
	if [ $__AS != 0 ]; then
		echo "Error! Exit code: $__AS"
	fi
	((index++)) || true
done
__AMBER_ARRAY_2=("pip install python-lsp-server" "gem install ruby-lsp")
__3_command_lsp=("${__AMBER_ARRAY_2[@]}")
__AMBER_ARRAY_3=("Python LSP" "Ruby LSP")
__4_command_lsp_name=("${__AMBER_ARRAY_3[@]}")
index=0
for lsp in "${__3_command_lsp[@]}"; do
	echo "Install ${__4_command_lsp_name[${index}]}"
	${lsp}
	__AS=$?
	if [ $__AS != 0 ]; then
		echo "Error! Exit code: $__AS"
	fi
	((index++)) || true
done
