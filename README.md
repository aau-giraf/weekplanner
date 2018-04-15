## Weekplanner

This repository contains the rewritten Weekplanner built with Xamarin.

## Prerequisites
- .NET Core 2.0 or newer
- Xamarin SDK

## Contributing

We are using the GitFlow brancing pattern so all development must be done in either a feature branch or the `develop` branch.

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

## Updating Swagger Client

### 1. Generate Swagger Client with swagger-codegen
Assuming the backend is running on http://localhost:5000

1. Install Swagger CLI (https://swagger.io/docs/swagger-tools/#installation-11) 
2. Generate new client
    - cd to repository root
    - Either `source update_swagger.sh` 
    - OR run `swagger-codegen generate -i http://localhost:5000/swagger/v1/swagger.json -l csharp -o GeneratedClient`

OR with https://editor.swagger.io/

1. Go to File > Import URL > http://localhost:5000/swagger/v1/swagger.json
3. Generate Client > csharp

### 2. Fix the generated client

1. If you didn't use `update_swagger.sh` then copy and paste (overwrite) the IO.Swagger folder from inside GeneratedClient/src/ to the root of weekplanner and delete the GeneratedClient/ directory
2. Swagger has a problem generating enums, which is problem in the generated WeekDayDTO. The following hack solves it:
Start the enum from 0 instead of 1 to reflect the actual backend
3. Fix compile error:
```
foreach(var param in fileParams)
{
    request.AddFile(param.Value.Name, param.Value.Writer, param.Value.FileName, param.Value.ContentType);
}
```
ApiClient.cs line 135
Simply remove/comment those lines. No need to fix it since we don't work with files.

## API Reference

For API reference start the API and navigate to http://localhost:5000/swagger

## Contributors

- SW608F18
- SW609F18
- SW610F18 

## License

Copyright [2018] [Aalborg University]