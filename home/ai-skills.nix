{ config, lib, pkgs, ... }:

let
  skillRoot = ../skills;

  skillNames =
    if builtins.pathExists skillRoot
    then
      builtins.attrNames
        (lib.filterAttrs (_: type: type == "directory") (builtins.readDir skillRoot))
    else
      [];

  mkSkillDirs = targetRoot:
    builtins.listToAttrs (map
      (name: {
        name = "${targetRoot}/${name}";
        value = {
          source = skillRoot + "/${name}";
          recursive = true;
          force = true;
        };
      })
      skillNames);
in
{
  home.file =
    mkSkillDirs ".claude/skills"
    // mkSkillDirs ".codex/skills";
}
