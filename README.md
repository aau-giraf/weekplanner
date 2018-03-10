## Weekplanner

This repository contains the rewritten Weekplanner built with Xamarin.

## Contributing

We are using the Gitflow brancing pattern so all development must be done in either a feature branch or the `develop` branch.

1. Clone the project
2. `git checkout develop`
3. Go to Phabricator to see which user stories need to be implemented

## Implementing a User Story

- Create a new View (ContentPage)
- Create a button in TestingPage.xaml and make it navigate to your new View
- Create a ViewModel and make it inherit from BaseViewModel then hook it up to the View through BindingContext
- Use DataBinding (MVVM) to synchronize between the View and ViewModel
- Use MessagingCenter to communicate between pages
- Use Commands to execute actions eg. when clicking a button
- Use Navigation.PushAsync for navigation
- Use DependencyService for dependency injection
- [Xamarin Forms Documentation](https://developer.xamarin.com/guides/xamarin-forms/)

## License

Copyright [yyyy] [name of copyright owner]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
