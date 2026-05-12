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
    // mkSkillDirs ".coding_agent/skills";

  home.activation.materializeCodexSkills =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      set -eu

      target="${config.home.homeDirectory}/.codex/skills"
      mkdir -p "$target"

      ${lib.concatMapStringsSep "\n" (name: ''
        rm -rf "$target/${name}"
        mkdir -p "$target/${name}"
        ${pkgs.rsync}/bin/rsync -aL --delete "${skillRoot}/${name}/" "$target/${name}/"
      '') skillNames}
    '';
}
