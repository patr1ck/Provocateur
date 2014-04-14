Provocateur
===========

A library which allows remote configuration of app variables through MultipeerConnectivity.framework

This project is made up of multiple, totally incomplete parts:

## Provocateur
A static library you can include in your iOS app and use to specify which variables you want to be able to change live.

## ProvocateurExample
An example iOS app which demos the above.

## Headquaters
An iOS app that can connect to apps which use the Provocateur library and change their variables on the fly. Right now it only works as a proof-of-concept with the ProvocateurExample app, but it can, should, and will evenutally be expanded to full-blown app which can dynamically create a manipulation UI based on the types and values contained in the connected app's Overridables.plist.

All of this is super-alpha, but it is at least now in a good starting point for a real project.
