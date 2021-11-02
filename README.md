# Weekplanner
This repository contains the frontend part of the weekplanner-app, which communicates with uses the api-client-repository to communicate with the backend (web-api-repository). 

The frontend uses the Flutter framework to maintain the UI, it is currently running on Flutter version 2.0.5. The language used in this repository is Dart, which is the language the Flutter framework uses.

# Branches
This repository uses the scaled trunkbased branching strategy, as explained here: [Github setup](https://github.com/aau-giraf/.github/blob/main/wiki/about/github.md). In this repository the "trunk" is named develop, and this is the branch that all developers should branch from when fixing an issue. The naming convention for these branches are:

| Issue type | Name                   | Example     |
| :--------: | :--------------------- | :---------: |
| User Story | feature/*issue-number* | feature/697 |
| Task       | task/*issue-number*    | task/918    |
| Bug fix    | bug-fix/*issue-number* | bug-fix/299 |

Other than the branches being used for development and the trunk, there exists some release branches, where the newest release branch is running on the PROD-environment. The release branches can only be created by members of the release group in the organization, and they should adhere to the following naming convention:
- Naming is release-*release-version* fx release-1.0
- A hot-fix on a release will increment the number after the dot (.)
- A new release will increment the number before the dot (.)


This is a frontend repository. The Weekplanner application is written in Flutter.

The Weekplanner is an application to create and maintain a week schedule of a citizen. This schedule shows a plan of the activities due for the day/week of a citizen and is essentially an important tool. It is a digitisation of an already existing week plan that the guardians maintain on a pin-up board at the institutions. The weekplanner repository contains the Flutter Weekplanner application that is used to compile to both iOS and Android devices.

The weekplanner repository is dependent on the api_client repository, which it uses to communicate with the backend, hosted in web-api.

[![Flutter Android and iOS verification](https://github.com/aau-giraf/weekplanner/actions/workflows/flutter-verification.yml/badge.svg)](https://github.com/aau-giraf/weekplanner/actions/workflows/flutter-verification.yml)
[![codecov](https://codecov.io/gh/aau-giraf/weekplanner/branch/develop/graph/badge.svg)](https://codecov.io/gh/aau-giraf/weekplanner)


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
