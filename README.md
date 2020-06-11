# Flutter Networking

A Flutter application repository for comparing [http](https://pub.dev/packages/http), [chopper](https://pub.dev/packages/chopper) & [retrofit](https://pub.dev/packages/retrofit) network layer implementations.

## Getting Started

 1. Checkout a branch `master`, `http`, `chopper`, `chopper-type-converter` or `retrofit`
 2. Run *build runner*:
    - `flutter pub run build_runner build` single-time build (should be run on each code change, eg. branch checkout)
    - `flutter pub run build_runner watch` automatically rebuilds app on each code change
 3. Run the app on device or emulator/simulator

## Testing
Run `flutter test`

## Branches

`master` - base implementation with mocked offline response

`http` - network implementaion using [http](https://pub.dev/packages/http) library

`chopper` - network implementaion using [chopper](https://pub.dev/packages/chopper) library

`chopper-type-converter` - extended `chopper` with custom type converter

`retrofit` - network implementaion using [retrofit](https://pub.dev/packages/retrofit) library
