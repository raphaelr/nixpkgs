# This is called by update.py to print out the github handles of the
# JetBrains maintainers.
let
  pkgs = import ../../../../. { };
  lib = pkgs.lib;

  maintainers = lib.flatten (lib.mapAttrsToList (name: drv: drv.meta.maintainers or [ ]) pkgs.jetbrains);
  githubHandles = lib.unique (builtins.map (maintainer: maintainer.github) maintainers);
in

lib.concatMapStringsSep " " (handle: "@${handle}") githubHandles
