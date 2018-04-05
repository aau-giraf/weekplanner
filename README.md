## Weekplanner

This repository contains the rewritten Weekplanner built with Xamarin.

## Prerequisites
- .NET Core 2.0 or newer
- Xamarin SDK

## Contributing

We are using the Gitflow brancing pattern so all development must be done in either a feature branch or the `develop` branch.

1. Clone the project
2. `git checkout develop`
3. Go to Phabricator to see which user stories need to be implemented

## Implementing a User Story

- Create a new View (ContentPage)
    - Set `ViewModelLocator.AutoWireViewModel="true"` at the top of the .xaml page
- Create a ViewModel and make it inherit from ViewModelBase
    - Register the ViewModel inside AppSetup.cs
- Create a button in TestingPage.xaml and make it navigate to your new View by using a Command
    - Use NavigationService.NavigateToAsync<xxxViewModel>() for navigation. All navigation logic should reside in the ViewModels.
    - Use Commands to execute actions eg. when clicking a button
- Use DataBinding (MVVM) to synchronize between the View and ViewModel
- Use MessagingCenter to communicate between pages
- Use AutoFixture with Moq for testing when possible, to avoid brittle tests
- [Xamarin Forms Documentation](https://developer.xamarin.com/guides/xamarin-forms/)
- [Autofac Documentation](http://autofac.readthedocs.io/en/latest/getting-started/index.html)
- [AutoFixture Documentation](https://github.com/AutoFixture/AutoFixture/wiki/Cheat-Sheet)
- Good sample application: [eShopOnContainers](https://github.com/dotnet-architecture/eShopOnContainers/)

## Pull Requests

Pull Requests are used for code review. Before submitting a Pull Request make sure to merge `develop` into your branch, so your Pull Request can be performed automatically.


## License

Copyright [2018] [Aalborg University]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
