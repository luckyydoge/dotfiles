#!/bin/sh

mkdir /run/user/1000/podman

podman system service -t 0 unix:///run/user/1000/podman/podman.sock &

xwayland-satellite :12 &

DISPLAY=:12 intellij-idea-ultimate-edition
