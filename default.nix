{ pkgs ? import <nixpkgs> {} }:

with pkgs;

buildEnv {
  name = "cloud";
  paths = [
      terraform
  ];
}