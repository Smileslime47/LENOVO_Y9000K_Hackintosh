# LENOVO_Y9000K_Hackintosh
OpenCore官方项目网址：https://github.com/acidanthera/OpenCorePkg  
建议的几个前例参考网站：  
-国光的参考教程：  
https://apple.sqlsec.com/  
-Y7000Series：  
https://github.com/xiaoMGitHub/LEGION_Y7000Series_Hackintosh/  
-Y9000X：  
https://github.com/SukkaW/Lenovo-Y9000X-Hackintosh

# 硬件配置
* 电脑型号：联想拯救者Y9000K2020H
* Cpu：Intel i7-10875h（Comet Lake系列）
* 网卡：Intel AX201
* 硬盘：Samsung PM981a 1T 后更换 Samsung 980 1T
* 声卡：Realtek ALC287
* 启动盘：SanDisk CZ73 64GB

# 工作状态
## 本人的efi工作状态：  
* 声卡 原声 音频输出（内建扬声器，3.5mm耳机直插）  
* USB3.0/2.0/Type-c传输正常  
* CPU电源管理/睿频控制正常  
* 集成显卡驱动，硬件图形加速，并已屏蔽GPU  
* 睡眠唤醒
* Hidpi功能
* 随航功能、wifi、蓝牙（无线随航/通用控制暂时无效，可能需要更换白果网卡）  
* Apple账号系统所有功能  
* 触摸板、键盘适配，fn功能键和全手势支持  
* 有线网卡传输正常
* 摄像头正常  
* 显示器亮度调节
* 电池百分比和监测正常  

## 缺失功能：  
* 麦克风无法检测，暂时懒得弄了，反正用不上  
* TouchID识别  

# 一些硬件上的建议
## 声卡
-编译最新版的1.7.1版本AppleALC并在NVRAM的boot-args设置**alcid=11**将可以检测到声卡，经测试3.5mm耳机接口直插可用，但扬声器无效，根据sukka的repo得知Y9k系列扬声器被连接到一个mac无法驱动的放大器上，解决方案在这里：  
https://gitee.com/YasuStudio/fix-speaker-y9000x  
即直接在terminal输入  
```
bash -c "$(curl -fsSL https://gitee.com/YasuStudio/fix-speaker-y9000x/raw/master/FixSpeaker-Y9000X.sh)" 
```
来解决扬声器问题

## 网卡
-y9000k2020用的网卡是cnvio协议的M.2双天线Intel AX201，电脑内预留的空间极小，博通有**BCM94360Z和BCM94352Z和dw系列**网卡可以兼容，但是千万不要买BCM94360CD之类的长款网卡，如果是其他型号的电脑强烈建议先拆开看看主板的预留空间是否足够。  
用itlwm驱动intel网卡需要搭配附带的Heliport app，airportitlwm配合bluetoolfix可以驱动蓝牙和wifi，但蓝牙的被发现功能失效无法正常使用通用控制。

## 显示器
-macOS自身的亮度控制是针对苹果显示器适配的，如果不能正常工作建议在appstore下载Brightness Slider

## 显卡
-macOS仅支持AMD系列显卡，较老版本会支持部分NVIDIA系列显卡，github上有人做过kepler架构的驱动（https://github.com/chris1111/Geforce-Kepler-patcher）  
但是turing架构基本上可以不用想了  
绝大多数hackintosh均由集成显卡驱动并屏蔽独立显卡（因为无法驱动，开着还耗电）

## 硬盘
-绝对要**避免pm981**系列硬盘，如果有，换一块兼容的ssd（比如980），然后在opencore里打补丁屏蔽981.  
虽然网上有成功用981安装的案例但极其繁琐，恢复法往往仅支持较低版本，更高版本需要先在其他硬盘按照正确方法安装好然后备份还原至981，而且系统稳定性无法保证.

## 触摸板
-触摸板是比较容易出问题的一个IO设备，无法识别时建议先检查一下kexts和acpi是否都装齐全了（当时本人就因为少装了一个SSDT-TPXX而一直不能识别到），不行再去看那些进阶一些的教程是否有动手能力实现


# OpenCore(EFI)组成
## ACPI方面
### 关键ACPI：
* SSDT-AWAC:修复时钟模块（RTC Clock）对MacOS的兼容
* SSDT-EC：Embeded Controller，修复嵌入式控制器
* SSDT-USBX：调整USB接口供电，同EC
* SSDT-HPET:修复 IRQ 冲突。在新版SSDTTime中由SSDT-H[ET实现，老版本则为SSDT-IRQ）
* SSDT-PLUG：CPU电源管理
* SSDT-XCPM：CPU电源管理
* SSDT-PNLFCFL:修复笔记本背光控制，用于intel coffeelake/cometlake系列cpu，其他架构建议用SSDT-PNLF

### 睡眠ACPI：
* SSDT-GPRW:修复macOS下睡眠自动唤醒的bug
* SSDT-PTSWAK：修复关机睡眠问题
* SSDT-SLEEP:启用s3睡眠

### 硬件适配ACPI：
* SSDT-DDGPU:用于禁用独立显卡
* SSDT-DNVME:用于禁用Mac不支持的pm981系列硬盘

### IO ACPI：
* SSDT-XOSI:修复触摸板连接问题
* SSDT-TPXX:定义触摸板设备名称（如TPAD）,使macOS能够识别触摸板
* SSDT-PS2K:修复PS/2设备连接问题，一般用于适配笔记本键盘
* SSDT-I2C：修复连接GPIO设备的兼容性（如触摸板）
* SSDT-GPIO:提供对于笔记本 VoodooI2C 的适配


## Kexts方面：
* AirportItlwm：Intel无线网卡驱动
* AppleALC：Apple声卡驱动，不兼容可以尝试VoodooHDA，经测试y9kk声卡为AL287，对应lay-out为11，可直接设置在nvram的boot-args内识别到声卡  
[不同型号声卡对应的layout-id对照表](https://github.com/acidanthera/AppleALC/wiki/Supported-codecs)
* IntelBlueFirmware/Bluetoolfixup:修复intel系列的蓝牙功能,两个搭配使用
* BrightnewsKet：键盘亮度功能键
* CPUTscSync：同步CPU Tsc，优化系统
* HibernationFixup:修复睡眠模式
* Lilu：Kexts依赖组件
* NvmeFix：修复Nvme硬盘兼容性问题
* RealtekRTL81111:有线网卡驱动
* SMCBatteryManager：读取笔记本电池容量
* SMCProcessor：监控CPU温度
* （SMCSuperIO）：监控风扇转速，我这里无法正常读取，因为用处不大懒得整就直接删了
* USBPorts/USBMap：USB端口定制，后者需要通过USBTool自行定制，二者选择一个即可
* VirtualSMC：模拟Apple SMC芯片
* Voodool2C(HID)：提供键盘/触摸板/鼠标的连接
* WhateverGreen：核显驱动

# 致谢
* 感谢提供了macOS的[Apple公司](https://www.apple.com.cn/)
* 感谢为Hackintosh及[OpenCore](https://github.com/acidanthera/OpenCorePkg)开发各种组件的开发者们
* 感谢在[Y7000系列](https://github.com/xiaoMGitHub/LEGION_Y7000Series_Hackintosh/)以及[Y9000系列](https://github.com/SukkaW/Lenovo-Y9000X-Hackintosh)上探索出较为完善的方案的前人们
* 感谢为我提供了许多帮助的各位大佬