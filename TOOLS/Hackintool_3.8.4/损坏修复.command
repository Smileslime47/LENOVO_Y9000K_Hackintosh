#!/bin/bash
clear
RED='\033[0;31m'
GRN='\033[0;32m'
BLU='\033[0;34m'
NC='\033[0m'
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$parent_path"
echo ""
echo ""
echo -e "「xxx已损坏，无法打开」或者 「来自身份不明开发者」修复脚本 ${RED}Modified by HeiPG.cn${NC}"
echo ""
echo -e "${BLU}脚本将执行「开启所有源」以及「移除APP安全隔离属性」两项操作${NC}"
echo ""
echo -e "${BLU}请输入开机密码，输入完成后按下回车键（输入过程中密码是看不见的）${NC}"
echo ""
echo ""
sudo spctl --master-disable
app_path=$( find "$parent_path" -name '*.app' -maxdepth 1)
app_name=${app_path##*/}
app_bashname=${app_name// /\ }
sudo xattr -rd com.apple.quarantine /Applications/"$app_bashname"
echo ""
echo ""
echo -e "${GRN}操作完成，如还无法使用，请安装Xcode自行签名软件或关闭系统完整性保护（SIP），参考：https://heipg.cn/tutorial/solution-for-macos-10-15-catalina-cant-run-apps.html${NC}"
echo ""
echo -e "${GRN}请访问：HeiPG.cn${NC}"