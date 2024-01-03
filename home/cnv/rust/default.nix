{
    pkgs,
    config,
    lib,
    ...
}:

{
    home.packages = with pkgs; [
      rustc cargo rustfmt rustPackages.clippy rustfmt rust-analyzer
    ];
  }
