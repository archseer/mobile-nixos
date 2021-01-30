{ lib, pkgs, baseModules, modules, ... }:

let
  # Keep modules from this eval around
  modules' = modules;

  # We can make use the normal NixOS evalConfig here.
  evalConfig = import "${pkgs.path}/nixos/lib/eval-config.nix";
in
{
  lib = {
    mobile-nixos = {
      # `config.lib.mobile-nixos.composeConfig` is the supported method used to
      # re-evaluate a configuration with additional configuration.
      # Can be used exactly like `evalConfig`, with one additional param.
      # The `config` param directly takes a module (attrset or function).
      composeConfig = { config ? {}, modules ? [], ... }@args:
      let
        filteredArgs = lib.filterAttrs (k: v: k != "config") args;
      in
      evalConfig (
        filteredArgs // {
        inherit baseModules;
        # Merge in this eval's modules with the argument's modules, and finally
        # with the given config.
        modules = modules' ++ modules ++ [ config ];
      });
    };
  };
}