{ lib }: let
  inherit (lib)
    mapAttrsToList filterAttrs mapAttrs mapAttrs' zipAttrsWith isAttrs isList concatLists
    tail head all last;
in rec {
  attrsToList = attrs:
    mapAttrsToList (name: value: { inherit name value; }) attrs;
  
  mapFilterAttrs =
    fn: predicate: attrs: filterAttrs predicate (mapAttrs fn attrs);

  mapFilterAttrs' = fn: predicate: attrs:
    filterAttrs predicate (mapAttrs' fn attrs);

  mergeAttrs' = attrList:
    let f = attrPath:
      zipAttrsWith (n: values:
        if (tail values) == []
          then head values
        else if all isList values
          then concatLists values
        else if all isAttrs values
          then f (attrPath ++ [n]) values
        else
          last values
      );
    in
      f [] attrList;
}

