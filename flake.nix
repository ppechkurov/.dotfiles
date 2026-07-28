{
  description = "My NixOS config flake";

  inputs = {
    nixpkgs-25_11.url = "nixpkgs/nixos-25.11";
    nixpkgs.url = "nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager-25_11.url = "github:nix-community/home-manager/release-25.11";
    home-manager-25_11.inputs.nixpkgs.follows = "nixpkgs-25_11";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.darwin.follows = "";

    minimal-tmux.url = "github:niksingh710/minimal-tmux-status";

    mailserver.url = "gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-26.05";
    mailserver.inputs.nixpkgs.follows = "nixpkgs";

    jira.url = "git+ssh://git@github.com/ppechkurov/jira.git";
    jira.type = "git";
    jira.ref = "refs/tags/v0.0.6";
    jira.inputs.nixpkgs.follows = "nixpkgs";

    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    noctalia.url = "github:noctalia-dev/noctalia-shell/v4.7.7";
    noctalia.inputs.nixpkgs.follows = "nixpkgs-unstable";

    tuicr.url = "github:agavra/tuicr/v0.19.1";
    tuicr.inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  outputs =
    { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } (
      inputs.import-tree [
        ./dendritic
        ./deploy
      ]
    );
}
