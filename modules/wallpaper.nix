# Wallpaper recoloured into the theme.nix palette at build time with lutgen,
# so changing a colour in theme.nix recolours the wallpaper too.
#
# The source image is wallpapers/wallpaper.{jpg,jpeg,png,webp} (credits in
# wallpapers/README.md). It must be `git add`ed: flakes only see tracked files.
# Returns null when there's no image, so hosts fall back to a solid background.
{
  pkgs,
  lib,
  theme,
  source ? lib.findFirst builtins.pathExists null (
    map (ext: ../wallpapers + "/wallpaper.${ext}") [ "jpg" "jpeg" "png" "webp" ]
  ),
  # Gaussian RBF with preserved luminosity keeps the photo's light and shadow while
  # remapping hues; -L 0.5 weights matches towards colourful palette entries over greys.
  lutgenArgs ? [ "-R" "-P" "-L" "0.5" ],
}:

let
  # Leave out the mid greys (gray1-4): with them, coloured light gets mapped to grey
  # because Oxocarbon has no warm hues to match it against.
  colours = lib.unique (
    lib.attrValues (removeAttrs theme.palette [ "gray1" "gray2" "gray3" "gray4" ])
    ++ lib.attrValues theme.ansi.bright
  );
in
if source == null then
  null
else
  pkgs.runCommand "wallpaper.png" { nativeBuildInputs = [ pkgs.lutgen ]; } ''
    lutgen apply ${lib.escapeShellArgs lutgenArgs} -o $out ${source} -- ${lib.escapeShellArgs colours}
  ''
