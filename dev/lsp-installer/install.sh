#!/usr/bin/env bash
# Written in [Amber](https://amber-lang.com/)

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
function get_download_path__26_v0 {
	local repo=$1
	local position=$2
	__AMBER_VAL_0=$(curl -sL https://api.github.com/repos/${repo}/releases | jq -r ".[0].assets.[${position}].browser_download_url")
	__AS=$?
	__AF_get_download_path26_v0="${__AMBER_VAL_0}"
	return 0
}
cd /tmp >/dev/null 2>&1
__AS=$?
echo "Install PHPactor LSP"
get_download_path__26_v0 "phpactor/phpactor" 0
__AF_get_download_path26_v0__10="${__AF_get_download_path26_v0}"
__0_download_url="${__AF_get_download_path26_v0__10}"
wget ${__0_download_url}
__AS=$?
if [ $__AS != 0 ]; then
	echo "Error! Exit code: $__AS"
fi
mv phpactor.phar /usr/local/bin >/dev/null 2>&1
__AS=$?
chmod +x /usr/local/bin/phpactor >/dev/null 2>&1
__AS=$?
echo "Install Typos LSP"
get_download_path__26_v0 "tekumara/typos-lsp" 6
__AF_get_download_path26_v0__20="${__AF_get_download_path26_v0}"
__1_download_url="${__AF_get_download_path26_v0__20}"
wget ${__1_download_url}
__AS=$?
if [ $__AS != 0 ]; then
	echo "Error! Exit code: $__AS"
fi
tar -zxvf ./typos* -C ./typos-lsp >/dev/null 2>&1
__AS=$?
mv typos-lsp /usr/local/bin >/dev/null 2>&1
__AS=$?
chmod +x /usr/local/bin/typos-lsp >/dev/null 2>&1
__AS=$?
echo "Install GitLab CI LSP"
get_download_path__26_v0 "alesbrelih/gitlab-ci-ls" 3
__AF_get_download_path26_v0__31="${__AF_get_download_path26_v0}"
__2_download_url="${__AF_get_download_path26_v0__31}"
wget ${__2_download_url}
__AS=$?
if [ $__AS != 0 ]; then
	echo "Error! Exit code: $__AS"
fi
mv x86_64-unknown-linux-gnu /usr/local/bin/gitlab-ci-ls >/dev/null 2>&1
__AS=$?
chmod +x /usr/local/bin/gitlab-ci-ls >/dev/null 2>&1
__AS=$?
echo "Install HTMX LSP"
get_download_path__26_v0 "ThePrimeagen/htmx-lsp" 2
__AF_get_download_path26_v0__41="${__AF_get_download_path26_v0}"
__3_download_url="${__AF_get_download_path26_v0__41}"
wget ${__3_download_url}
__AS=$?
if [ $__AS != 0 ]; then
	echo "Error! Exit code: $__AS"
fi
mv htmx-lsp-linux-x64 /usr/local/bin/htmx-lsp >/dev/null 2>&1
__AS=$?
chmod +x /usr/local/bin/htmx-lsp >/dev/null 2>&1
__AS=$?
echo "Install Marksman LSP"
get_download_path__26_v0 "artempyanykh/marksman" 1
__AF_get_download_path26_v0__51="${__AF_get_download_path26_v0}"
__4_download_url="${__AF_get_download_path26_v0__51}"
wget ${__4_download_url}
__AS=$?
if [ $__AS != 0 ]; then
	echo "Error! Exit code: $__AS"
fi
mv marksman-linux-x64 /usr/local/bin/marksman >/dev/null 2>&1
__AS=$?
chmod +x /usr/local/bin/marksman >/dev/null 2>&1
__AS=$?
echo "Install Lua LSP"
dir_exist__4_v0 "/opt/lua-language-server"
__AF_dir_exist4_v0__61=$__AF_dir_exist4_v0
if [ $(echo '!' $__AF_dir_exist4_v0__61 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
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
__AMBER_ARRAY_0=("vscode-langservers-extracted" "@tailwindcss/language-server" "@olrtg/emmet-language-server" "intelephense$" "bash-language-server")
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
	let index=${index}+1
done
echo "Install Python LSP Server"
pip install python-lsp-server
__AS=$?
if [ $__AS != 0 ]; then
	echo "Error! Exit code: $__AS"
fi
echo "Install Ruby LSP"
gem install ruby-lsp
__AS=$?
if [ $__AS != 0 ]; then
	echo "Error! Exit code: $__AS"
fi
