{ ... }:

{
  home.file.".steampipe/config/aws.spc".text = ''
    connection "default" {
      plugin = "aws"
    }

    connection "dev" {
      plugin  = "aws"
      profile = "dev"
    }
  '';
}
