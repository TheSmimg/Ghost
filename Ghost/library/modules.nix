{ lib, attrs }: let
  inherit (builtins) toString pathExists readDir;
  inherit (lib) id nameValuePair filterAttrs concatLists mapAttrsToList attrValues hasSuffix hasPrefix removeSuffix;
in rec {
  mapModules = dir: fn:
    attrs.mapFilterAttrs' (n: v:
      let path = "${toString dir}/${n}"; in
        if v == "directory" && pathExists "${path}/default.nix"
          then nameValuePair n (fn path)
        else if v == "regular"      &&
                n != "default.nix"  &&
                n != "flake.nix"    &&
                n != "theme.nix"    &&
                (hasSuffix ".nix" n)
          then nameValuePair (removeSuffix ".nix" n) (fn path)
        else
          nameValuePair "" null
      )
      (n: v: v != null && !(hasPrefix "_" n))
      (readDir dir);

  mapModulesRec = dir: fn: let
    dirs = mapAttrsToList (k: _: "${dir}/${k}") (
      filterAttrs (n: v: v == "directory" && !(hasPrefix "_" n)) (readDir dir));
    
    files = attrValues (mapModules dir id);
    paths = files ++ concatLists (map (d: mapModulesRec d id) dirs);
  in map fn paths;
}

