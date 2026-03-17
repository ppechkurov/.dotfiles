{
  description = "My NixOS config flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.darwin.follows = "";

    minimal-tmux.url = "github:niksingh710/minimal-tmux-status";

    mailserver.url =
      "gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-25.11";
    mailserver.inputs.nixpkgs.follows = "nixpkgs";

    jira.url = "git+ssh://git@github.com/ppechkurov/jira.git";
    jira.type = "git";
    jira.ref = "refs/tags/v0.0.5";
    jira.inputs.nixpkgs.follows = "nixpkgs";

    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    noctalia.url = "github:noctalia-dev/noctalia-shell";
    noctalia.inputs.nixpkgs.follows = "nixpkgs-unstable";
    noctalia.inputs.noctalia-qs.follows = "noctalia-qs";

    noctalia-qs.url = "github:noctalia-dev/noctalia-qs";
    noctalia-qs.inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  outputs = { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; }
    (inputs.import-tree [ ./dendritic ./deploy ]);
}
