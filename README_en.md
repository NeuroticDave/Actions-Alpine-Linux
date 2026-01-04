# Actions-Alpine-Linux
This project provides a way to build Alpine Linux system that can run directly on FriendlyElec development boards.  
[切换到中文](README.md)  
### Basic Information
- Account: Username is root, password is fa
- Network: The first network interface is configured for DHCP to automatically obtain an IP address
- Login: Serial terminal and SSH login are enabled
### Running the Alpine from TF Card
Download the image file with “-sd-” in the name, use your preferred flashing tool to write the image file to the TF card, then insert the TF card into the development board. Power on the board, and the Alpine Linux system will start.
### Flashing the Alpine to eMMC
Download the image file with “-eflasher-” in the name, use your preferred flashing tool to write the image file to the TF card, then insert the TF card into the development board. Power on the board, and it will automatically flash the system to eMMC. After flashing is complete, removing the TF card will trigger an automatic reboot and boot into the Alpine Linux system on eMMC.
### Customizing Alpine Linux
- Please refer to this link: https://wiki.friendlyelec.com/wiki/index.php/Getting_Started_with_Alpine-Linux
### Release Notes
* 2025/12/31
    *  Bump to v3.23
* 2025/07/09
    *  Add support for NanoPi-R76S
    *  Fix eflasher image issue
* 2025/06/25
    *  Add support for NanoPi-R3S-LTS
* 2025/06/06
    *  Add support for NanoPi-M5
    *  Bump to v3.22
- 2025/03/14 First release
