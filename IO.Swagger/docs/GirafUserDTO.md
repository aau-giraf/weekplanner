# IO.Swagger.Model.GirafUserDTO
## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**Role** | **string** | List of the roles the current user is defined as in the system. | [optional] 
**RoleName** | **string** | List of the roles the current user is defined as in the system. | [optional] 
**Citizens** | [**List&lt;GirafUserDTO&gt;**](GirafUserDTO.md) | List of users the user is guardian of. Is simply null if the user isn&#39;t a guardian. Contains guardians if the user is a Department | [optional] 
**Guardians** | [**List&lt;GirafUserDTO&gt;**](GirafUserDTO.md) | Gets or sets guardians of a user. | [optional] 
**Id** | **string** |  | 
**Username** | **string** |  | 
**ScreenName** | **string** | The display name of the user. | [optional] 
**UserIcon** | **byte[]** | A byte array containing the user&#39;s profile icon. | [optional] 
**Department** | **long?** | The key of the user&#39;s department. | [optional] 
**WeekScheduleIds** | [**List&lt;WeekDTO&gt;**](WeekDTO.md) |  | 
**Resources** | [**List&lt;ResourceDTO&gt;**](ResourceDTO.md) |  | 
**Settings** | [**LauncherOptionsDTO**](LauncherOptionsDTO.md) |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)

