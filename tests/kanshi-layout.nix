let
  flake = builtins.getFlake (toString ../.);
  settings =
    flake.nixosConfigurations.helios.config.home-manager.users.mahoney.services.kanshi.settings;
  dockedOpen = builtins.elemAt settings 1;
  dockedClosed = builtins.elemAt settings 2;
  dockedOpenOutputs = dockedOpen.profile.outputs;
  dockedClosedOutputs = dockedClosed.profile.outputs;
  lgOpen = builtins.elemAt dockedOpenOutputs 0;
  dellOpen = builtins.elemAt dockedOpenOutputs 1;
  lgClosed = builtins.elemAt dockedClosedOutputs 0;
  dellClosed = builtins.elemAt dockedClosedOutputs 1;
in
assert (lgOpen.criteria == "LG Electronics LG ULTRAFINE 412NTKF3S797");
assert (lgOpen.transform == "90");
assert (dellOpen.criteria == "Dell Inc. DELL U2723QE 9P79FH3");
assert (dellOpen.transform == null);
assert (lgClosed.criteria == "LG Electronics LG ULTRAFINE 412NTKF3S797");
assert (lgClosed.transform == "90");
assert (dellClosed.criteria == "Dell Inc. DELL U2723QE 9P79FH3");
assert (dellClosed.transform == null);
assert (dockedOpen.profile.exec == [ ]);
assert (dockedClosed.profile.exec == [ ]);
true
