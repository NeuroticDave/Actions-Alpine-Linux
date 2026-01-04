# Actions-Alpine-Linux
此项目用于构建可直接运行在友善电子开发板上的Alpine Linux系统。  
[Switch to English](README_en.md)  
### 基本信息 
- 帐号：root用户名密码为fa
- 网络：已配置第一个网口为dhcp自动获取IP地址
- 登录：已启用串口终端和SSH登录
### 通过TF卡运行系统
下载带 "-sd-" 字样的镜像文件，使用你熟悉的写卡工具将镜像文件写入TF卡，然后将TF卡插入开发板，上电启动开发板即可启动Alpine Linux系统。
### 烧写系统到eMMC运行
下载带 "-eflasher-" 字样的镜像文件，使用你熟悉的写卡工具将镜像文件写入TF卡，然后将TF卡插入开发板，上电启动开发板，会自动烧写系统到eMMC，烧写完成后，拨出TF卡会自动重启并进入eMMC中的Alpine Linux系统。
### 定制 Alpine Linux 系统
- 请参考这里: https://wiki.friendlyelec.com/wiki/index.php/Getting_Started_with_Alpine-Linux/zh
### 更新说明
* 2025/12/31
    *  更新版本到 v3.23
* 2025/07/09
    *  增加 NanoPi-R76S 支持
    *  修复 eflasher 固件问题
* 2025/06/25
    *  增加 NanoPi-R3S-LTS 支持
* 2025/06/06
    *  增加 NanoPi-M5 支持
    *  更新版本到 v3.22
* 2025/03/14 首次发布
