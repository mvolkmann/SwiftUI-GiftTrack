fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios tests

```sh
[bundle exec] fastlane ios tests
```

Run tests

### ios certs

```sh
[bundle exec] fastlane ios certs
```

Creates a signing certificate and provisioning profile

### ios build

```sh
[bundle exec] fastlane ios build
```



### ios beta

```sh
[bundle exec] fastlane ios beta
```



### ios screenshots

```sh
[bundle exec] fastlane ios screenshots
```

Generates localized screenshots

### ios frames

```sh
[bundle exec] fastlane ios frames
```

Creates new screenshots from existing ones that have device frames

### ios upload_screenshots

```sh
[bundle exec] fastlane ios upload_screenshots
```

Uploads localized screenshots to App Store

### ios version

```sh
[bundle exec] fastlane ios version
```

Prints the version and build number

### ios prod

```sh
[bundle exec] fastlane ios prod
```



----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
