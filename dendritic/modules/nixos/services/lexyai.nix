{ inputs, ... }: {
  flake.modules.nixos.lexyai =
    { config, ... }:
    {
      imports = [ inputs.lexyai.nixosModules.default ];

      age.secrets.lexyai-env.file = ./lexyai.env.age;

      services.lexyai = {
        enable = true;
        environmentFile = config.age.secrets.lexyai-env.path;
      };

      systemd.services.lexyai.restartTriggers = [ config.age.secrets.lexyai-env.file ];
    };
}
