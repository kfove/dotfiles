{ config, lib, pkgs, ... }:

{
  imports =
    [
      # 硬件相关
      ./hardware-configuration.nix
      # 我要 van 游戏
      ./steam.nix
    ];

  # 允许不自由的软件, 比如 nvidia
  nixpkgs.config.allowUnfree = true;
  # 使用 Grub 启动
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
  boot.loader = {
    efi.efiSysMountPoint = "/boot";

    grub = {
      enable = true;
      devices = [ "nodev" ];
      efiInstallAsRemovable = true;
      efiSupport = true;
      useOSProber = true;
    };
  };

  # 主机名
  networking.hostName = "nixos_dk";
  # 网络设置 使用nm
  # networking.wireless.enable = true;  # 不必关注， nm 接管一切
  networking.networkmanager.enable = true;
  programs.nm-applet.enable = true;

  # 时区
  time.timeZone = "Asia/Shanghai";

  # 区域设置
  i18n.defaultLocale = "en_US.UTF-8";
  # 输入方式, 选择fcitx5
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-chinese-addons
      fcitx5-rime
    ];
  };
  # xserver 启用
  # services.xserver.enable = true;
  # 显卡设备
  services.xserver.videoDrivers = [ "amdgpu" "nvidia" ];

  # OpenGL 的选择
  hardware.opengl = {
    extraPackages = [
      pkgs.amdvlk
    ];
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
  hardware.opengl.extraPackages32 = [
    pkgs.driversi686Linux.amdvlk
  ];
  # Nvidia Fuck You !!!
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };




  # 启用 CUPS, 打印机用的
  # services.printing.enable = true;

  # 启用声音， 这里使用 pipewire
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # 触控支持
  # services.xserver.libinput.enable = true;

  # 用户
  users.users.dingduck = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    packages = with pkgs; [ ];
  };

  # 系统包
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    curl
    git
  ];
  # 打开ssh
  # services.openssh.enable = true;

  # 防火墙相关
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # 防火墙的启用
  # networking.firewall.enable = false;

  # 从目标系统复制 configuration.nix
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  system.stateVersion = "23.11";
  # 允许不自由的包
  environment.variables = { };
}

