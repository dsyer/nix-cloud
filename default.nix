{ pkgs ? import <nixpkgs> {} }:

with pkgs;

buildEnv {
  name = "cloud";
  paths = [
      google-cloud-sdk
      terraform
  ];
}