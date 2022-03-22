 **本人repo所附工具均参照过协议兼容(主要为MIT协议)，如果你是这里某个工具的作者且认为构成了侵权，请联系我进行删除**  
 **If you are the author of a tool here and think it constitutes infringement, please pm me to delete it**

# 你可能会用到的工具：
-拯救者系列一键修改BIOS：  
https://github.com/xiaoMGitHub/LEGION_Y7000Series_Insyde_Advanced_Settings_Tools    
用于修改那些拯救者系列bios中没有列出的关键选项，如CFGLock等 

-Hackintools:  
https://github.com/headkaze/Hackintool  
仅限macOS，用于查看系统各种硬件信息，可以用来检查系统状况，同时可以在磁盘挂载你的ESP分区，结合OCC可以实现脱离windows修改你的opencore  

-OpenCoreConfigurator（OCC）:  
https://mackie100projects.altervista.org/opencore-configurator/  
基于macOS的plist修改器，非常重要，让你可以在macos下直接修改你efi的配置文件  

-OpenCoreAuxiliaryTools（OCAT）:  
https://github.com/ic005k/OCAuxiliaryTools  
基于windows的plist修改器，在你还没有安装好macOS之前通过这个进行你的配置文件的修改，安装好之后建议直接在macos下用OCC进行配置  

-Heliport/itlwm:  
https://openintelwireless.github.io/itlwm/FAQ.html#usage  
https://github.com/OpenIntelWireless/itlwm  
如果你选择使用itlwm驱动你的网卡，那么你需要通过这个来连接wifi，而不是系统自带的wifi控件  

-SSDTTime：  
https://github.com/corpnewt/SSDTTime  
可以帮助你自动生成你需要的几个SSDT(AWAC,EC,HPET,PLUG,PMC)  

-USBToolBox:  
https://github.com/USBToolBox/tool  
一种USB定制工具，可以帮助你生成USBMaps.kexts，避开apple的端口限制

-macRecovery:  
在你下载的OpenCore->Utilities->macrecovery处，如果你无法进入macOS的**安装引导**的话，可以尝试运行这里的macrecovery.py,将得到的两个BaseSystem文件放到ESP分区下的com.apple.recovery.boot文件夹（自行创建）