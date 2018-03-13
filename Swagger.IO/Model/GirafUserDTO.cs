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
using System.Collections.Generic;
using System.Runtime.Serialization;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using System.ComponentModel.DataAnnotations;

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
            /// Enum Citizen for "Citizen"
            /// </summary>
            [EnumMember(Value = "Citizen")]
            Citizen,
            
            /// <summary>
            /// Enum Department for "Department"
            /// </summary>
            [EnumMember(Value = "Department")]
            Department,
            
            /// <summary>
            /// Enum Guardian for "Guardian"
            /// </summary>
            [EnumMember(Value = "Guardian")]
            Guardian,
            
            /// <summary>
            /// Enum SuperUser for "SuperUser"
            /// </summary>
            [EnumMember(Value = "SuperUser")]
            SuperUser
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
        public GirafUserDTO() { }
        /// <summary>
        /// Initializes a new instance of the <see cref="GirafUserDTO" /> class.
        /// </summary>
        /// <param name="Role">List of the roles the current user is defined as in the system..</param>
        /// <param name="GuardianOf">List of users the user is guardian of. Is simply null if the user isn&#39;t a guardian. Contains guardians if the user is a Department.</param>
        /// <param name="Id">Id (required).</param>
        /// <param name="Username">Username (required).</param>
        /// <param name="ScreenName">The display name of the user..</param>
        /// <param name="UserIcon">A byte array containing the user&#39;s profile icon..</param>
        /// <param name="Department">The key of the user&#39;s department..</param>
        /// <param name="WeekScheduleIds">WeekScheduleIds (required).</param>
        /// <param name="Resources">Resources (required).</param>
        /// <param name="Settings">Settings (required).</param>
        public GirafUserDTO(RoleEnum? Role = default(RoleEnum?), List<GirafUserDTO> GuardianOf = default(List<GirafUserDTO>), string Id = default(string), string Username = default(string), string ScreenName = default(string), byte[] UserIcon = default(byte[]), long? Department = default(long?), List<WeekDTO> WeekScheduleIds = default(List<WeekDTO>), List<ResourceDTO> Resources = default(List<ResourceDTO>), LauncherOptionsDTO Settings = default(LauncherOptionsDTO))
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
            this.GuardianOf = GuardianOf;
            this.ScreenName = ScreenName;
            this.UserIcon = UserIcon;
            this.Department = Department;
        }
        

        /// <summary>
        /// List of users the user is guardian of. Is simply null if the user isn&#39;t a guardian. Contains guardians if the user is a Department
        /// </summary>
        /// <value>List of users the user is guardian of. Is simply null if the user isn&#39;t a guardian. Contains guardians if the user is a Department</value>
        [DataMember(Name="guardianOf", EmitDefaultValue=false)]
        public List<GirafUserDTO> GuardianOf { get; set; }

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
            sb.Append("  GuardianOf: ").Append(GuardianOf).Append("\n");
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
        /// <param name="obj">Object to be compared</param>
        /// <returns>Boolean</returns>
        public override bool Equals(object obj)
        {
            // credit: http://stackoverflow.com/a/10454552/677735
            return this.Equals(obj as GirafUserDTO);
        }

        /// <summary>
        /// Returns true if GirafUserDTO instances are equal
        /// </summary>
        /// <param name="other">Instance of GirafUserDTO to be compared</param>
        /// <returns>Boolean</returns>
        public bool Equals(GirafUserDTO other)
        {
            // credit: http://stackoverflow.com/a/10454552/677735
            if (other == null)
                return false;

            return 
                (
                    this.Role == other.Role ||
                    this.Role != null &&
                    this.Role.Equals(other.Role)
                ) && 
                (
                    this.GuardianOf == other.GuardianOf ||
                    this.GuardianOf != null &&
                    this.GuardianOf.SequenceEqual(other.GuardianOf)
                ) && 
                (
                    this.Id == other.Id ||
                    this.Id != null &&
                    this.Id.Equals(other.Id)
                ) && 
                (
                    this.Username == other.Username ||
                    this.Username != null &&
                    this.Username.Equals(other.Username)
                ) && 
                (
                    this.ScreenName == other.ScreenName ||
                    this.ScreenName != null &&
                    this.ScreenName.Equals(other.ScreenName)
                ) && 
                (
                    this.UserIcon == other.UserIcon ||
                    this.UserIcon != null &&
                    this.UserIcon.Equals(other.UserIcon)
                ) && 
                (
                    this.Department == other.Department ||
                    this.Department != null &&
                    this.Department.Equals(other.Department)
                ) && 
                (
                    this.WeekScheduleIds == other.WeekScheduleIds ||
                    this.WeekScheduleIds != null &&
                    this.WeekScheduleIds.SequenceEqual(other.WeekScheduleIds)
                ) && 
                (
                    this.Resources == other.Resources ||
                    this.Resources != null &&
                    this.Resources.SequenceEqual(other.Resources)
                ) && 
                (
                    this.Settings == other.Settings ||
                    this.Settings != null &&
                    this.Settings.Equals(other.Settings)
                );
        }

        /// <summary>
        /// Gets the hash code
        /// </summary>
        /// <returns>Hash code</returns>
        public override int GetHashCode()
        {
            // credit: http://stackoverflow.com/a/263416/677735
            unchecked // Overflow is fine, just wrap
            {
                int hash = 41;
                // Suitable nullity checks etc, of course :)
                if (this.Role != null)
                    hash = hash * 59 + this.Role.GetHashCode();
                if (this.GuardianOf != null)
                    hash = hash * 59 + this.GuardianOf.GetHashCode();
                if (this.Id != null)
                    hash = hash * 59 + this.Id.GetHashCode();
                if (this.Username != null)
                    hash = hash * 59 + this.Username.GetHashCode();
                if (this.ScreenName != null)
                    hash = hash * 59 + this.ScreenName.GetHashCode();
                if (this.UserIcon != null)
                    hash = hash * 59 + this.UserIcon.GetHashCode();
                if (this.Department != null)
                    hash = hash * 59 + this.Department.GetHashCode();
                if (this.WeekScheduleIds != null)
                    hash = hash * 59 + this.WeekScheduleIds.GetHashCode();
                if (this.Resources != null)
                    hash = hash * 59 + this.Resources.GetHashCode();
                if (this.Settings != null)
                    hash = hash * 59 + this.Settings.GetHashCode();
                return hash;
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
