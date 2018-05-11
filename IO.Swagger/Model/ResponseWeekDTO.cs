/* 
 * The Giraf REST API
 *
 * No description provided (generated by Swagger Codegen https://github.com/swagger-api/swagger-codegen)
 *
 * OpenAPI spec version: v1
 * 
 * Generated by: https://github.com/swagger-api/swagger-codegen.git
 */

using System;
using System.Linq;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;
using System.Collections;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Runtime.Serialization;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using System.ComponentModel.DataAnnotations;
using SwaggerDateConverter = IO.Swagger.Client.SwaggerDateConverter;

namespace IO.Swagger.Model
{
    /// <summary>
    /// ResponseWeekDTO
    /// </summary>
    [DataContract]
    public partial class ResponseWeekDTO :  IEquatable<ResponseWeekDTO>, IValidatableObject
    {
        /// <summary>
        /// Defines ErrorKey
        /// </summary>
        [JsonConverter(typeof(StringEnumConverter))]
        public enum ErrorKeyEnum
        {
            
            /// <summary>
            /// Enum Error for value: Error
            /// </summary>
            [EnumMember(Value = "Error")]
            Error = 1,
            
            /// <summary>
            /// Enum FormatError for value: FormatError
            /// </summary>
            [EnumMember(Value = "FormatError")]
            FormatError = 2,
            
            /// <summary>
            /// Enum NoError for value: NoError
            /// </summary>
            [EnumMember(Value = "NoError")]
            NoError = 3,
            
            /// <summary>
            /// Enum NotAuthorized for value: NotAuthorized
            /// </summary>
            [EnumMember(Value = "NotAuthorized")]
            NotAuthorized = 4,
            
            /// <summary>
            /// Enum NotFound for value: NotFound
            /// </summary>
            [EnumMember(Value = "NotFound")]
            NotFound = 5,
            
            /// <summary>
            /// Enum ApplicationNotFound for value: ApplicationNotFound
            /// </summary>
            [EnumMember(Value = "ApplicationNotFound")]
            ApplicationNotFound = 6,
            
            /// <summary>
            /// Enum ChoiceContainsInvalidPictogramId for value: ChoiceContainsInvalidPictogramId
            /// </summary>
            [EnumMember(Value = "ChoiceContainsInvalidPictogramId")]
            ChoiceContainsInvalidPictogramId = 7,
            
            /// <summary>
            /// Enum CitizenAlreadyHasGuardian for value: CitizenAlreadyHasGuardian
            /// </summary>
            [EnumMember(Value = "CitizenAlreadyHasGuardian")]
            CitizenAlreadyHasGuardian = 8,
            
            /// <summary>
            /// Enum CitizenNotFound for value: CitizenNotFound
            /// </summary>
            [EnumMember(Value = "CitizenNotFound")]
            CitizenNotFound = 9,
            
            /// <summary>
            /// Enum DepartmentAlreadyOwnsResource for value: DepartmentAlreadyOwnsResource
            /// </summary>
            [EnumMember(Value = "DepartmentAlreadyOwnsResource")]
            DepartmentAlreadyOwnsResource = 10,
            
            /// <summary>
            /// Enum DepartmentNotFound for value: DepartmentNotFound
            /// </summary>
            [EnumMember(Value = "DepartmentNotFound")]
            DepartmentNotFound = 11,
            
            /// <summary>
            /// Enum EmailServiceUnavailable for value: EmailServiceUnavailable
            /// </summary>
            [EnumMember(Value = "EmailServiceUnavailable")]
            EmailServiceUnavailable = 12,
            
            /// <summary>
            /// Enum ImageAlreadyExistOnPictogram for value: ImageAlreadyExistOnPictogram
            /// </summary>
            [EnumMember(Value = "ImageAlreadyExistOnPictogram")]
            ImageAlreadyExistOnPictogram = 13,
            
            /// <summary>
            /// Enum ImageNotContainedInRequest for value: ImageNotContainedInRequest
            /// </summary>
            [EnumMember(Value = "ImageNotContainedInRequest")]
            ImageNotContainedInRequest = 14,
            
            /// <summary>
            /// Enum InvalidCredentials for value: InvalidCredentials
            /// </summary>
            [EnumMember(Value = "InvalidCredentials")]
            InvalidCredentials = 15,
            
            /// <summary>
            /// Enum InvalidModelState for value: InvalidModelState
            /// </summary>
            [EnumMember(Value = "InvalidModelState")]
            InvalidModelState = 16,
            
            /// <summary>
            /// Enum InvalidProperties for value: InvalidProperties
            /// </summary>
            [EnumMember(Value = "InvalidProperties")]
            InvalidProperties = 17,
            
            /// <summary>
            /// Enum MissingProperties for value: MissingProperties
            /// </summary>
            [EnumMember(Value = "MissingProperties")]
            MissingProperties = 18,
            
            /// <summary>
            /// Enum NoWeekScheduleFound for value: NoWeekScheduleFound
            /// </summary>
            [EnumMember(Value = "NoWeekScheduleFound")]
            NoWeekScheduleFound = 19,
            
            /// <summary>
            /// Enum PasswordNotUpdated for value: PasswordNotUpdated
            /// </summary>
            [EnumMember(Value = "PasswordNotUpdated")]
            PasswordNotUpdated = 20,
            
            /// <summary>
            /// Enum PictogramHasNoImage for value: PictogramHasNoImage
            /// </summary>
            [EnumMember(Value = "PictogramHasNoImage")]
            PictogramHasNoImage = 21,
            
            /// <summary>
            /// Enum PictogramNotFound for value: PictogramNotFound
            /// </summary>
            [EnumMember(Value = "PictogramNotFound")]
            PictogramNotFound = 22,
            
            /// <summary>
            /// Enum QueryFailed for value: QueryFailed
            /// </summary>
            [EnumMember(Value = "QueryFailed")]
            QueryFailed = 23,
            
            /// <summary>
            /// Enum ResourceMustBePrivate for value: ResourceMustBePrivate
            /// </summary>
            [EnumMember(Value = "ResourceMustBePrivate")]
            ResourceMustBePrivate = 24,
            
            /// <summary>
            /// Enum ResourceNotFound for value: ResourceNotFound
            /// </summary>
            [EnumMember(Value = "ResourceNotFound")]
            ResourceNotFound = 25,
            
            /// <summary>
            /// Enum ResourceNotOwnedByDepartment for value: ResourceNotOwnedByDepartment
            /// </summary>
            [EnumMember(Value = "ResourceNotOwnedByDepartment")]
            ResourceNotOwnedByDepartment = 26,
            
            /// <summary>
            /// Enum ResourceIDUnreadable for value: ResourceIDUnreadable
            /// </summary>
            [EnumMember(Value = "ResourceIDUnreadable")]
            ResourceIDUnreadable = 27,
            
            /// <summary>
            /// Enum RoleMustBeCitizien for value: RoleMustBeCitizien
            /// </summary>
            [EnumMember(Value = "RoleMustBeCitizien")]
            RoleMustBeCitizien = 28,
            
            /// <summary>
            /// Enum RoleNotFound for value: RoleNotFound
            /// </summary>
            [EnumMember(Value = "RoleNotFound")]
            RoleNotFound = 29,
            
            /// <summary>
            /// Enum ThumbnailDoesNotExist for value: ThumbnailDoesNotExist
            /// </summary>
            [EnumMember(Value = "ThumbnailDoesNotExist")]
            ThumbnailDoesNotExist = 30,
            
            /// <summary>
            /// Enum UserAlreadyExists for value: UserAlreadyExists
            /// </summary>
            [EnumMember(Value = "UserAlreadyExists")]
            UserAlreadyExists = 31,
            
            /// <summary>
            /// Enum UserNameAlreadyTakenWithinDepartment for value: UserNameAlreadyTakenWithinDepartment
            /// </summary>
            [EnumMember(Value = "UserNameAlreadyTakenWithinDepartment")]
            UserNameAlreadyTakenWithinDepartment = 32,
            
            /// <summary>
            /// Enum UserAlreadyHasAccess for value: UserAlreadyHasAccess
            /// </summary>
            [EnumMember(Value = "UserAlreadyHasAccess")]
            UserAlreadyHasAccess = 33,
            
            /// <summary>
            /// Enum UserAlreadyHasIconUsePut for value: UserAlreadyHasIconUsePut
            /// </summary>
            [EnumMember(Value = "UserAlreadyHasIconUsePut")]
            UserAlreadyHasIconUsePut = 34,
            
            /// <summary>
            /// Enum UserAlreadyOwnsResource for value: UserAlreadyOwnsResource
            /// </summary>
            [EnumMember(Value = "UserAlreadyOwnsResource")]
            UserAlreadyOwnsResource = 35,
            
            /// <summary>
            /// Enum UserAndCitizenMustBeInSameDepartment for value: UserAndCitizenMustBeInSameDepartment
            /// </summary>
            [EnumMember(Value = "UserAndCitizenMustBeInSameDepartment")]
            UserAndCitizenMustBeInSameDepartment = 36,
            
            /// <summary>
            /// Enum UserCannotBeGuardianOfYourself for value: UserCannotBeGuardianOfYourself
            /// </summary>
            [EnumMember(Value = "UserCannotBeGuardianOfYourself")]
            UserCannotBeGuardianOfYourself = 37,
            
            /// <summary>
            /// Enum UserDoesNotOwnResource for value: UserDoesNotOwnResource
            /// </summary>
            [EnumMember(Value = "UserDoesNotOwnResource")]
            UserDoesNotOwnResource = 38,
            
            /// <summary>
            /// Enum UserHasNoIcon for value: UserHasNoIcon
            /// </summary>
            [EnumMember(Value = "UserHasNoIcon")]
            UserHasNoIcon = 39,
            
            /// <summary>
            /// Enum UserHasNoIconUsePost for value: UserHasNoIconUsePost
            /// </summary>
            [EnumMember(Value = "UserHasNoIconUsePost")]
            UserHasNoIconUsePost = 40,
            
            /// <summary>
            /// Enum UserMustBeGuardian for value: UserMustBeGuardian
            /// </summary>
            [EnumMember(Value = "UserMustBeGuardian")]
            UserMustBeGuardian = 41,
            
            /// <summary>
            /// Enum UserNotFound for value: UserNotFound
            /// </summary>
            [EnumMember(Value = "UserNotFound")]
            UserNotFound = 42,
            
            /// <summary>
            /// Enum WeekScheduleNotFound for value: WeekScheduleNotFound
            /// </summary>
            [EnumMember(Value = "WeekScheduleNotFound")]
            WeekScheduleNotFound = 43,
            
            /// <summary>
            /// Enum Forbidden for value: Forbidden
            /// </summary>
            [EnumMember(Value = "Forbidden")]
            Forbidden = 44,
            
            /// <summary>
            /// Enum PasswordMissMatch for value: PasswordMissMatch
            /// </summary>
            [EnumMember(Value = "PasswordMissMatch")]
            PasswordMissMatch = 45,
            
            /// <summary>
            /// Enum TwoDaysCannotHaveSameDayProperty for value: TwoDaysCannotHaveSameDayProperty
            /// </summary>
            [EnumMember(Value = "TwoDaysCannotHaveSameDayProperty")]
            TwoDaysCannotHaveSameDayProperty = 46,
            
            /// <summary>
            /// Enum UserHasNoCitizens for value: UserHasNoCitizens
            /// </summary>
            [EnumMember(Value = "UserHasNoCitizens")]
            UserHasNoCitizens = 47,
            
            /// <summary>
            /// Enum UserHasNoGuardians for value: UserHasNoGuardians
            /// </summary>
            [EnumMember(Value = "UserHasNoGuardians")]
            UserHasNoGuardians = 48,
            
            /// <summary>
            /// Enum DepartmentHasNoCitizens for value: DepartmentHasNoCitizens
            /// </summary>
            [EnumMember(Value = "DepartmentHasNoCitizens")]
            DepartmentHasNoCitizens = 49,
            
            /// <summary>
            /// Enum UnknownError for value: UnknownError
            /// </summary>
            [EnumMember(Value = "UnknownError")]
            UnknownError = 50,
            
            /// <summary>
            /// Enum CouldNotCreateDepartmentUser for value: CouldNotCreateDepartmentUser
            /// </summary>
            [EnumMember(Value = "CouldNotCreateDepartmentUser")]
            CouldNotCreateDepartmentUser = 51,
            
            /// <summary>
            /// Enum UserNotFoundInDepartment for value: UserNotFoundInDepartment
            /// </summary>
            [EnumMember(Value = "UserNotFoundInDepartment")]
            UserNotFoundInDepartment = 52,
            
            /// <summary>
            /// Enum NoWeekTemplateFound for value: NoWeekTemplateFound
            /// </summary>
            [EnumMember(Value = "NoWeekTemplateFound")]
            NoWeekTemplateFound = 53,
            
            /// <summary>
            /// Enum UserAlreadyHasDepartment for value: UserAlreadyHasDepartment
            /// </summary>
            [EnumMember(Value = "UserAlreadyHasDepartment")]
            UserAlreadyHasDepartment = 54,
            
            /// <summary>
            /// Enum MissingSettings for value: MissingSettings
            /// </summary>
            [EnumMember(Value = "MissingSettings")]
            MissingSettings = 55,
            
            /// <summary>
            /// Enum InvalidAmountOfWeekdays for value: InvalidAmountOfWeekdays
            /// </summary>
            [EnumMember(Value = "InvalidAmountOfWeekdays")]
            InvalidAmountOfWeekdays = 56,
            
            /// <summary>
            /// Enum WeekAlreadyExists for value: WeekAlreadyExists
            /// </summary>
            [EnumMember(Value = "WeekAlreadyExists")]
            WeekAlreadyExists = 57,
            
            /// <summary>
            /// Enum InvalidDay for value: InvalidDay
            /// </summary>
            [EnumMember(Value = "InvalidDay")]
            InvalidDay = 58,
            
            /// <summary>
            /// Enum DuplicateWeekScheduleName for value: DuplicateWeekScheduleName
            /// </summary>
            [EnumMember(Value = "DuplicateWeekScheduleName")]
            DuplicateWeekScheduleName = 59,
            
            /// <summary>
            /// Enum ColorMustHaveUniqueDay for value: ColorMustHaveUniqueDay
            /// </summary>
            [EnumMember(Value = "ColorMustHaveUniqueDay")]
            ColorMustHaveUniqueDay = 60,
            
            /// <summary>
            /// Enum InvalidHexValues for value: InvalidHexValues
            /// </summary>
            [EnumMember(Value = "InvalidHexValues")]
            InvalidHexValues = 61,
            
            /// <summary>
            /// Enum WeekTemplateNotFound for value: WeekTemplateNotFound
            /// </summary>
            [EnumMember(Value = "WeekTemplateNotFound")]
            WeekTemplateNotFound = 62,
            
            /// <summary>
            /// Enum NotImplemented for value: NotImplemented
            /// </summary>
            [EnumMember(Value = "NotImplemented")]
            NotImplemented = 63,
            
            /// <summary>
            /// Enum UserMustBeInDepartment for value: UserMustBeInDepartment
            /// </summary>
            [EnumMember(Value = "UserMustBeInDepartment")]
            UserMustBeInDepartment = 64
        }

        /// <summary>
        /// Gets or Sets ErrorKey
        /// </summary>
        [DataMember(Name="errorKey", EmitDefaultValue=false)]
        public ErrorKeyEnum? ErrorKey { get; set; }
        /// <summary>
        /// Initializes a new instance of the <see cref="ResponseWeekDTO" /> class.
        /// </summary>
        /// <param name="Data">Data.</param>
        /// <param name="Success">Success.</param>
        /// <param name="ErrorProperties">ErrorProperties.</param>
        public ResponseWeekDTO(WeekDTO Data = default(WeekDTO), bool? Success = default(bool?), List<string> ErrorProperties = default(List<string>))
        {
            this.Data = Data;
            this.Success = Success;
            this.ErrorProperties = ErrorProperties;
        }
        
        /// <summary>
        /// Gets or Sets Data
        /// </summary>
        [DataMember(Name="data", EmitDefaultValue=false)]
        public WeekDTO Data { get; set; }

        /// <summary>
        /// Gets or Sets Success
        /// </summary>
        [DataMember(Name="success", EmitDefaultValue=false)]
        public bool? Success { get; set; }

        /// <summary>
        /// Gets or Sets ErrorProperties
        /// </summary>
        [DataMember(Name="errorProperties", EmitDefaultValue=false)]
        public List<string> ErrorProperties { get; set; }


        /// <summary>
        /// Returns the string presentation of the object
        /// </summary>
        /// <returns>String presentation of the object</returns>
        public override string ToString()
        {
            var sb = new StringBuilder();
            sb.Append("class ResponseWeekDTO {\n");
            sb.Append("  Data: ").Append(Data).Append("\n");
            sb.Append("  Success: ").Append(Success).Append("\n");
            sb.Append("  ErrorProperties: ").Append(ErrorProperties).Append("\n");
            sb.Append("  ErrorKey: ").Append(ErrorKey).Append("\n");
            sb.Append("}\n");
            return sb.ToString();
        }
  
        /// <summary>
        /// Returns the JSON string presentation of the object
        /// </summary>
        /// <returns>JSON string presentation of the object</returns>
        public string ToJson()
        {
            return JsonConvert.SerializeObject(this, Formatting.Indented);
        }

        /// <summary>
        /// Returns true if objects are equal
        /// </summary>
        /// <param name="input">Object to be compared</param>
        /// <returns>Boolean</returns>
        public override bool Equals(object input)
        {
            return this.Equals(input as ResponseWeekDTO);
        }

        /// <summary>
        /// Returns true if ResponseWeekDTO instances are equal
        /// </summary>
        /// <param name="input">Instance of ResponseWeekDTO to be compared</param>
        /// <returns>Boolean</returns>
        public bool Equals(ResponseWeekDTO input)
        {
            if (input == null)
                return false;

            return 
                (
                    this.Data == input.Data ||
                    (this.Data != null &&
                    this.Data.Equals(input.Data))
                ) && 
                (
                    this.Success == input.Success ||
                    (this.Success != null &&
                    this.Success.Equals(input.Success))
                ) && 
                (
                    this.ErrorProperties == input.ErrorProperties ||
                    this.ErrorProperties != null &&
                    this.ErrorProperties.SequenceEqual(input.ErrorProperties)
                ) && 
                (
                    this.ErrorKey == input.ErrorKey ||
                    (this.ErrorKey != null &&
                    this.ErrorKey.Equals(input.ErrorKey))
                );
        }

        /// <summary>
        /// Gets the hash code
        /// </summary>
        /// <returns>Hash code</returns>
        public override int GetHashCode()
        {
            unchecked // Overflow is fine, just wrap
            {
                int hashCode = 41;
                if (this.Data != null)
                    hashCode = hashCode * 59 + this.Data.GetHashCode();
                if (this.Success != null)
                    hashCode = hashCode * 59 + this.Success.GetHashCode();
                if (this.ErrorProperties != null)
                    hashCode = hashCode * 59 + this.ErrorProperties.GetHashCode();
                if (this.ErrorKey != null)
                    hashCode = hashCode * 59 + this.ErrorKey.GetHashCode();
                return hashCode;
            }
        }

        /// <summary>
        /// To validate all properties of the instance
        /// </summary>
        /// <param name="validationContext">Validation context</param>
        /// <returns>Validation Result</returns>
        IEnumerable<System.ComponentModel.DataAnnotations.ValidationResult> IValidatableObject.Validate(ValidationContext validationContext)
        {
            yield break;
        }
    }

}
