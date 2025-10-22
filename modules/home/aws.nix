{ pkgs, flakeRoot, ... }:
{
  home.packages = with pkgs; [ awscli ];
  home.file.".aws/config".source = "${flakeRoot}/.secrets/aws-config";
}
