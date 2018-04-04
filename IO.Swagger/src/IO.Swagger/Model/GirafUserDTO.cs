/* 
 * My API
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
    /// Defines the structure of GirafUsers when serializing and deserializing data. Data transfer objects (DTOs)   were introduced in the project due to problems with circular references in the model classes.
    /// </summary>
    [DataContract]
    public partial class GirafUserDTO :  IEquatable<GirafUserDTO>, IValidatableObject
    {
        /// <summary>
        /// List of the roles the current user is defined as in the system.
        /// </summary>
        /// <value>List of the roles the current user is defined as in the system.</value>
        [JsonConverter(typeof(StringEnumConverter))]
        public enum RoleEnum
        {
            
            /// <summary>
            /// Enum Citizen for value: Citizen
            /// </summary>
            [EnumMember(Value = "Citizen")]
            Citizen = 1,
            
            /// <summary>
            /// Enum Department for value: Department
            /// </summary>
            [EnumMember(Value = "Department")]
            Department = 2,
            
            /// <summary>
            /// Enum Guardian for value: Guardian
            /// </summary>
            [EnumMember(Value = "Guardian")]
            Guardian = 3,
            
            /// <summary>
            /// Enum SuperUser for value: SuperUser
            /// </summary>
            [EnumMember(Value = "SuperUser")]
            SuperUser = 4
        }

        /// <summary>
        /// List of the roles the current user is defined as in the system.
        /// </summary>
        /// <value>List of the roles the current user is defined as in the system.</value>
        [DataMember(Name="role", EmitDefaultValue=false)]
        public RoleEnum? Role { get; set; }
        /// <summary>
        /// Initializes a new instance of the <see cref="GirafUserDTO" /> class.
        /// </summary>
        [JsonConstructorAttribute]
        protected GirafUserDTO() { }
        /// <summary>
        /// Initializes a new instance of the <see cref="GirafUserDTO" /> class.
        /// </summary>
        /// <param name="Role">List of the roles the current user is defined as in the system..</param>
        /// <param name="RoleName">List of the roles the current user is defined as in the system..</param>
        /// <param name="Citizens">List of users the user is guardian of. Is simply null if the user isn&#39;t a guardian. Contains guardians if the user is a Department.</param>
        /// <param name="Guardians">Gets or sets guardians of a user..</param>
        /// <param name="Id">Id (required).</param>
        /// <param name="Username">Username (required).</param>
        /// <param name="ScreenName">The display name of the user..</param>
        /// <param name="UserIcon">A byte array containing the user&#39;s profile icon..</param>
        /// <param name="Department">The key of the user&#39;s department..</param>
        /// <param name="WeekScheduleIds">WeekScheduleIds (required).</param>
        /// <param name="Resources">Resources (required).</param>
        /// <param name="Settings">Settings (required).</param>
        public GirafUserDTO(RoleEnum? Role = default(RoleEnum?), string RoleName = default(string), List<GirafUserDTO> Citizens = default(List<GirafUserDTO>), List<GirafUserDTO> Guardians = default(List<GirafUserDTO>), string Id = default(string), string Username = default(string), string ScreenName = default(string), byte[] UserIcon = default(byte[]), long? Department = default(long?), List<WeekDTO> WeekScheduleIds = default(List<WeekDTO>), List<ResourceDTO> Resources = default(List<ResourceDTO>), LauncherOptionsDTO Settings = default(LauncherOptionsDTO))
        {
            // to ensure "Id" is required (not null)
            if (Id == null)
            {
                throw new InvalidDataException("Id is a required property for GirafUserDTO and cannot be null");
            }
            else
            {
                this.Id = Id;
            }
            // to ensure "Username" is required (not null)
            if (Username == null)
            {
                throw new InvalidDataException("Username is a required property for GirafUserDTO and cannot be null");
            }
            else
            {
                this.Username = Username;
            }
            // to ensure "WeekScheduleIds" is required (not null)
            if (WeekScheduleIds == null)
            {
                throw new InvalidDataException("WeekScheduleIds is a required property for GirafUserDTO and cannot be null");
            }
            else
            {
                this.WeekScheduleIds = WeekScheduleIds;
            }
            // to ensure "Resources" is required (not null)
            if (Resources == null)
            {
                throw new InvalidDataException("Resources is a required property for GirafUserDTO and cannot be null");
            }
            else
            {
                this.Resources = Resources;
            }
            // to ensure "Settings" is required (not null)
            if (Settings == null)
            {
                throw new InvalidDataException("Settings is a required property for GirafUserDTO and cannot be null");
            }
            else
            {
                this.Settings = Settings;
            }
            this.Role = Role;
            this.RoleName = RoleName;
            this.Citizens = Citizens;
            this.Guardians = Guardians;
            this.ScreenName = ScreenName;
            this.UserIcon = UserIcon;
            this.Department = Department;
        }
        

        /// <summary>
        /// List of the roles the current user is defined as in the system.
        /// </summary>
        /// <value>List of the roles the current user is defined as in the system.</value>
        [DataMember(Name="roleName", EmitDefaultValue=false)]
        public string RoleName { get; set; }

        /// <summary>
        /// List of users the user is guardian of. Is simply null if the user isn&#39;t a guardian. Contains guardians if the user is a Department
        /// </summary>
        /// <value>List of users the user is guardian of. Is simply null if the user isn&#39;t a guardian. Contains guardians if the user is a Department</value>
        [DataMember(Name="citizens", EmitDefaultValue=false)]
        public List<GirafUserDTO> Citizens { get; set; }

        /// <summary>
        /// Gets or sets guardians of a user.
        /// </summary>
        /// <value>Gets or sets guardians of a user.</value>
        [DataMember(Name="guardians", EmitDefaultValue=false)]
        public List<GirafUserDTO> Guardians { get; set; }

        /// <summary>
        /// Gets or Sets Id
        /// </summary>
        [DataMember(Name="id", EmitDefaultValue=false)]
        public string Id { get; set; }

        /// <summary>
        /// Gets or Sets Username
        /// </summary>
        [DataMember(Name="username", EmitDefaultValue=false)]
        public string Username { get; set; }

        /// <summary>
        /// The display name of the user.
        /// </summary>
        /// <value>The display name of the user.</value>
        [DataMember(Name="screenName", EmitDefaultValue=false)]
        public string ScreenName { get; set; }

        /// <summary>
        /// A byte array containing the user&#39;s profile icon.
        /// </summary>
        /// <value>A byte array containing the user&#39;s profile icon.</value>
        [DataMember(Name="userIcon", EmitDefaultValue=false)]
        public byte[] UserIcon { get; set; }

        /// <summary>
        /// The key of the user&#39;s department.
        /// </summary>
        /// <value>The key of the user&#39;s department.</value>
        [DataMember(Name="department", EmitDefaultValue=false)]
        public long? Department { get; set; }

        /// <summary>
        /// Gets or Sets WeekScheduleIds
        /// </summary>
        [DataMember(Name="weekScheduleIds", EmitDefaultValue=false)]
        public List<WeekDTO> WeekScheduleIds { get; set; }

        /// <summary>
        /// Gets or Sets Resources
        /// </summary>
        [DataMember(Name="resources", EmitDefaultValue=false)]
        public List<ResourceDTO> Resources { get; set; }

        /// <summary>
        /// Gets or Sets Settings
        /// </summary>
        [DataMember(Name="settings", EmitDefaultValue=false)]
        public LauncherOptionsDTO Settings { get; set; }

        /// <summary>
        /// Returns the string presentation of the object
        /// </summary>
        /// <returns>String presentation of the object</returns>
        public override string ToString()
        {
            var sb = new StringBuilder();
            sb.Append("class GirafUserDTO {\n");
            sb.Append("  Role: ").Append(Role).Append("\n");
            sb.Append("  RoleName: ").Append(RoleName).Append("\n");
            sb.Append("  Citizens: ").Append(Citizens).Append("\n");
            sb.Append("  Guardians: ").Append(Guardians).Append("\n");
            sb.Append("  Id: ").Append(Id).Append("\n");
            sb.Append("  Username: ").Append(Username).Append("\n");
            sb.Append("  ScreenName: ").Append(ScreenName).Append("\n");
            sb.Append("  UserIcon: ").Append(UserIcon).Append("\n");
            sb.Append("  Department: ").Append(Department).Append("\n");
            sb.Append("  WeekScheduleIds: ").Append(WeekScheduleIds).Append("\n");
            sb.Append("  Resources: ").Append(Resources).Append("\n");
            sb.Append("  Settings: ").Append(Settings).Append("\n");
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
            return this.Equals(input as GirafUserDTO);
        }

        /// <summary>
        /// Returns true if GirafUserDTO instances are equal
        /// </summary>
        /// <param name="input">Instance of GirafUserDTO to be compared</param>
        /// <returns>Boolean</returns>
        public bool Equals(GirafUserDTO input)
        {
            if (input == null)
                return false;

            return 
                (
                    this.Role == input.Role ||
                    (this.Role != null &&
                    this.Role.Equals(input.Role))
                ) && 
                (
                    this.RoleName == input.RoleName ||
                    (this.RoleName != null &&
                    this.RoleName.Equals(input.RoleName))
                ) && 
                (
                    this.Citizens == input.Citizens ||
                    this.Citizens != null &&
                    this.Citizens.SequenceEqual(input.Citizens)
                ) && 
                (
                    this.Guardians == input.Guardians ||
                    this.Guardians != null &&
                    this.Guardians.SequenceEqual(input.Guardians)
                ) && 
                (
                    this.Id == input.Id ||
                    (this.Id != null &&
                    this.Id.Equals(input.Id))
                ) && 
                (
                    this.Username == input.Username ||
                    (this.Username != null &&
                    this.Username.Equals(input.Username))
                ) && 
                (
                    this.ScreenName == input.ScreenName ||
                    (this.ScreenName != null &&
                    this.ScreenName.Equals(input.ScreenName))
                ) && 
                (
                    this.UserIcon == input.UserIcon ||
                    (this.UserIcon != null &&
                    this.UserIcon.Equals(input.UserIcon))
                ) && 
                (
                    this.Department == input.Department ||
                    (this.Department != null &&
                    this.Department.Equals(input.Department))
                ) && 
                (
                    this.WeekScheduleIds == input.WeekScheduleIds ||
                    this.WeekScheduleIds != null &&
                    this.WeekScheduleIds.SequenceEqual(input.WeekScheduleIds)
                ) && 
                (
                    this.Resources == input.Resources ||
                    this.Resources != null &&
                    this.Resources.SequenceEqual(input.Resources)
                ) && 
                (
                    this.Settings == input.Settings ||
                    (this.Settings != null &&
                    this.Settings.Equals(input.Settings))
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
                if (this.Role != null)
                    hashCode = hashCode * 59 + this.Role.GetHashCode();
                if (this.RoleName != null)
                    hashCode = hashCode * 59 + this.RoleName.GetHashCode();
                if (this.Citizens != null)
                    hashCode = hashCode * 59 + this.Citizens.GetHashCode();
                if (this.Guardians != null)
                    hashCode = hashCode * 59 + this.Guardians.GetHashCode();
                if (this.Id != null)
                    hashCode = hashCode * 59 + this.Id.GetHashCode();
                if (this.Username != null)
                    hashCode = hashCode * 59 + this.Username.GetHashCode();
                if (this.ScreenName != null)
                    hashCode = hashCode * 59 + this.ScreenName.GetHashCode();
                if (this.UserIcon != null)
                    hashCode = hashCode * 59 + this.UserIcon.GetHashCode();
                if (this.Department != null)
                    hashCode = hashCode * 59 + this.Department.GetHashCode();
                if (this.WeekScheduleIds != null)
                    hashCode = hashCode * 59 + this.WeekScheduleIds.GetHashCode();
                if (this.Resources != null)
                    hashCode = hashCode * 59 + this.Resources.GetHashCode();
                if (this.Settings != null)
                    hashCode = hashCode * 59 + this.Settings.GetHashCode();
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
