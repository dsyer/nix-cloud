{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let

in buildEnv {
  name = "cloud";
  paths = [
      terraform
  ];
}