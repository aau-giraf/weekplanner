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
using System.IO;
using System.Text;
using System.Collections.Generic;
using System.Runtime.Serialization;
using Newtonsoft.Json;
using System.ComponentModel.DataAnnotations;

namespace IO.Swagger.Model
{
    /// <summary>
    /// This class is used when a new user is to be created. It simply defines the structure of the expected  json string.
    /// </summary>
    [DataContract]
    public partial class RegisterDTO :  IEquatable<RegisterDTO>, IValidatableObject
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="RegisterDTO" /> class.
        /// </summary>
        [JsonConstructorAttribute]
        protected RegisterDTO() { }
        /// <summary>
        /// Initializes a new instance of the <see cref="RegisterDTO" /> class.
        /// </summary>
        /// <param name="Username">The users username. (required).</param>
        /// <param name="Password">The users password. (required).</param>
        /// <param name="ConfirmPassword">The users password to avoid typos/mistakes. (required).</param>
        /// <param name="DepartmentId">The users departmentid. (required).</param>
        public RegisterDTO(string Username = default(string), string Password = default(string), string ConfirmPassword = default(string), long? DepartmentId = default(long?))
        {
            // to ensure "Username" is required (not null)
            if (Username == null)
            {
                throw new InvalidDataException("Username is a required property for RegisterDTO and cannot be null");
            }
            else
            {
                this.Username = Username;
            }
            // to ensure "Password" is required (not null)
            if (Password == null)
            {
                throw new InvalidDataException("Password is a required property for RegisterDTO and cannot be null");
            }
            else
            {
                this.Password = Password;
            }
            // to ensure "ConfirmPassword" is required (not null)
            if (ConfirmPassword == null)
            {
                throw new InvalidDataException("ConfirmPassword is a required property for RegisterDTO and cannot be null");
            }
            else
            {
                this.ConfirmPassword = ConfirmPassword;
            }
            // to ensure "DepartmentId" is required (not null)
            if (DepartmentId == null)
            {
                throw new InvalidDataException("DepartmentId is a required property for RegisterDTO and cannot be null");
            }
            else
            {
                this.DepartmentId = DepartmentId;
            }
        }
        
        /// <summary>
        /// The users username.
        /// </summary>
        /// <value>The users username.</value>
        [DataMember(Name="username", EmitDefaultValue=false)]
        public string Username { get; set; }

        /// <summary>
        /// The users password.
        /// </summary>
        /// <value>The users password.</value>
        [DataMember(Name="password", EmitDefaultValue=false)]
        public string Password { get; set; }

        /// <summary>
        /// The users password to avoid typos/mistakes.
        /// </summary>
        /// <value>The users password to avoid typos/mistakes.</value>
        [DataMember(Name="confirmPassword", EmitDefaultValue=false)]
        public string ConfirmPassword { get; set; }

        /// <summary>
        /// The users departmentid.
        /// </summary>
        /// <value>The users departmentid.</value>
        [DataMember(Name="departmentId", EmitDefaultValue=false)]
        public long? DepartmentId { get; set; }

        /// <summary>
        /// Returns the string presentation of the object
        /// </summary>
        /// <returns>String presentation of the object</returns>
        public override string ToString()
        {
            var sb = new StringBuilder();
            sb.Append("class RegisterDTO {\n");
            sb.Append("  Username: ").Append(Username).Append("\n");
            sb.Append("  Password: ").Append(Password).Append("\n");
            sb.Append("  ConfirmPassword: ").Append(ConfirmPassword).Append("\n");
            sb.Append("  DepartmentId: ").Append(DepartmentId).Append("\n");
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
            return this.Equals(obj as RegisterDTO);
        }

        /// <summary>
        /// Returns true if RegisterDTO instances are equal
        /// </summary>
        /// <param name="other">Instance of RegisterDTO to be compared</param>
        /// <returns>Boolean</returns>
        public bool Equals(RegisterDTO other)
        {
            // credit: http://stackoverflow.com/a/10454552/677735
            if (other == null)
                return false;

            return 
                (
                    this.Username == other.Username ||
                    this.Username != null &&
                    this.Username.Equals(other.Username)
                ) && 
                (
                    this.Password == other.Password ||
                    this.Password != null &&
                    this.Password.Equals(other.Password)
                ) && 
                (
                    this.ConfirmPassword == other.ConfirmPassword ||
                    this.ConfirmPassword != null &&
                    this.ConfirmPassword.Equals(other.ConfirmPassword)
                ) && 
                (
                    this.DepartmentId == other.DepartmentId ||
                    this.DepartmentId != null &&
                    this.DepartmentId.Equals(other.DepartmentId)
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
                if (this.Username != null)
                    hash = hash * 59 + this.Username.GetHashCode();
                if (this.Password != null)
                    hash = hash * 59 + this.Password.GetHashCode();
                if (this.ConfirmPassword != null)
                    hash = hash * 59 + this.ConfirmPassword.GetHashCode();
                if (this.DepartmentId != null)
                    hash = hash * 59 + this.DepartmentId.GetHashCode();
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
