#Provocateur

A set of tools which allows remote editing of app variables through MultipeerConnectivity.framework.

This project is made up of multiple parts:

### Provocateur
A static library you can include in your iOS app and use to specify which variables you want to be able to change live.

### ProvocateurExample
An example iOS app which demos the above.

### Headquaters
An iOS app that can connect to apps that use the Provocateur library and change their variables on the fly.

## Setup

1. Ensure Cocoapods is installed
1. Run `pod install`
1. Build and run the app through the .xcworkspace

## Contributing

Pull requests gladly accepted. Or feel free to file issues you run into.

## License

MIT Licensed, see LICENSE for details.
