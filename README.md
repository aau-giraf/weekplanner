# Weekplanner

![Build Status](https://github.com/aau-giraf/weekplanner/workflows/CI/badge.svg)

This is the ongoing project on moving from Xamarin to Flutter.

To get started please refer to the Flutter website, for now.

## Prerequisites

This project is based on Flutter, you can install flutter from here: https://flutter.dev/docs/get-started/install

## Contributing

We are using the [GitFlow](https://github.com/aau-giraf/wiki/blob/master/process_manual/code_workflow.md#essential-parts-of-gitflow) brancing pattern so all development must be done in either a feature branch or the `develop` branch.

1. Clone the project
2. Run `git checkout develop`
3. Go to the [issues tab](https://github.com/aau-giraf/weekplanner/issues) to see which user stories need to be implemented

### Todo's
- Tests
    - On RouteBuilder.
    - On Application-screen/BLoC.
    - On BlocProviderTree & BlocProvider.
- API still misses some features.
    - API should support unsuccessfull calls to the back-end
    - API should expose backend error messages to the BLoC, such that it can be communicated to the users.
- Actually good looking and well functional views.

## Pull Requests

Pull Requests are used for code review. Before submitting a Pull Request make sure to merge `develop` into your branch, so your Pull Request can be performed automatically.

## Branching rules
When creating a new branch for this project. One should stay on the Weekplanner-repository. To name a new branch use the `flutter/`-prefix. Otherwise just like normal.

## License

GNU GENERAL PUBLIC LICENSE V3

Copyright [2020] [Aalborg University]
