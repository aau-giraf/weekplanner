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
using System.Text;
using System.Collections.Generic;
using System.Runtime.Serialization;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using System.ComponentModel.DataAnnotations;

namespace IO.Swagger.Model
{
    /// <summary>
    /// A weekday displays what a citizen should do in the course of the day. A weekday may be populated with  a series of Pictograms and choices. They make up the building blocks of Weeks.
    /// </summary>
    [DataContract]
    public partial class Weekday :  IEquatable<Weekday>, IValidatableObject
    {
        /// <summary>
        /// An enum defining which day of the week this instance represents.
        /// </summary>
        /// <value>An enum defining which day of the week this instance represents.</value>
        [JsonConverter(typeof(StringEnumConverter))]
        public enum DayEnum
        {
            
            /// <summary>
            /// Enum Monday for "Monday"
            /// </summary>
            [EnumMember(Value = "Monday")]
            Monday,
            
            /// <summary>
            /// Enum Tuesday for "Tuesday"
            /// </summary>
            [EnumMember(Value = "Tuesday")]
            Tuesday,
            
            /// <summary>
            /// Enum Wednesday for "Wednesday"
            /// </summary>
            [EnumMember(Value = "Wednesday")]
            Wednesday,
            
            /// <summary>
            /// Enum Thursday for "Thursday"
            /// </summary>
            [EnumMember(Value = "Thursday")]
            Thursday,
            
            /// <summary>
            /// Enum Friday for "Friday"
            /// </summary>
            [EnumMember(Value = "Friday")]
            Friday,
            
            /// <summary>
            /// Enum Saturday for "Saturday"
            /// </summary>
            [EnumMember(Value = "Saturday")]
            Saturday,
            
            /// <summary>
            /// Enum Sunday for "Sunday"
            /// </summary>
            [EnumMember(Value = "Sunday")]
            Sunday
        }

        /// <summary>
        /// An enum defining which day of the week this instance represents.
        /// </summary>
        /// <value>An enum defining which day of the week this instance represents.</value>
        [DataMember(Name="day", EmitDefaultValue=false)]
        public DayEnum? Day { get; set; }
        /// <summary>
        /// Initializes a new instance of the <see cref="Weekday" /> class.
        /// </summary>
        /// <param name="Id">The id of the weekday..</param>
        /// <param name="LastEdit">The last time the weekday was edited..</param>
        /// <param name="ElementsSet">A flag indicated whether or not the weekday has been populated..</param>
        /// <param name="Day">An enum defining which day of the week this instance represents..</param>
        /// <param name="Elements">A collection of elements that make up the week..</param>
        public Weekday(long? Id = default(long?), DateTime? LastEdit = default(DateTime?), bool? ElementsSet = default(bool?), DayEnum? Day = default(DayEnum?), List<WeekdayResource> Elements = default(List<WeekdayResource>))
        {
            this.Id = Id;
            this.LastEdit = LastEdit;
            this.ElementsSet = ElementsSet;
            this.Day = Day;
            this.Elements = Elements;
        }
        
        /// <summary>
        /// The id of the weekday.
        /// </summary>
        /// <value>The id of the weekday.</value>
        [DataMember(Name="id", EmitDefaultValue=false)]
        public long? Id { get; set; }

        /// <summary>
        /// The last time the weekday was edited.
        /// </summary>
        /// <value>The last time the weekday was edited.</value>
        [DataMember(Name="lastEdit", EmitDefaultValue=false)]
        public DateTime? LastEdit { get; set; }

        /// <summary>
        /// A flag indicated whether or not the weekday has been populated.
        /// </summary>
        /// <value>A flag indicated whether or not the weekday has been populated.</value>
        [DataMember(Name="elementsSet", EmitDefaultValue=false)]
        public bool? ElementsSet { get; set; }


        /// <summary>
        /// A collection of elements that make up the week.
        /// </summary>
        /// <value>A collection of elements that make up the week.</value>
        [DataMember(Name="elements", EmitDefaultValue=false)]
        public List<WeekdayResource> Elements { get; set; }

        /// <summary>
        /// Returns the string presentation of the object
        /// </summary>
        /// <returns>String presentation of the object</returns>
        public override string ToString()
        {
            var sb = new StringBuilder();
            sb.Append("class Weekday {\n");
            sb.Append("  Id: ").Append(Id).Append("\n");
            sb.Append("  LastEdit: ").Append(LastEdit).Append("\n");
            sb.Append("  ElementsSet: ").Append(ElementsSet).Append("\n");
            sb.Append("  Day: ").Append(Day).Append("\n");
            sb.Append("  Elements: ").Append(Elements).Append("\n");
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
            return this.Equals(obj as Weekday);
        }

        /// <summary>
        /// Returns true if Weekday instances are equal
        /// </summary>
        /// <param name="other">Instance of Weekday to be compared</param>
        /// <returns>Boolean</returns>
        public bool Equals(Weekday other)
        {
            // credit: http://stackoverflow.com/a/10454552/677735
            if (other == null)
                return false;

            return 
                (
                    this.Id == other.Id ||
                    this.Id != null &&
                    this.Id.Equals(other.Id)
                ) && 
                (
                    this.LastEdit == other.LastEdit ||
                    this.LastEdit != null &&
                    this.LastEdit.Equals(other.LastEdit)
                ) && 
                (
                    this.ElementsSet == other.ElementsSet ||
                    this.ElementsSet != null &&
                    this.ElementsSet.Equals(other.ElementsSet)
                ) && 
                (
                    this.Day == other.Day ||
                    this.Day != null &&
                    this.Day.Equals(other.Day)
                ) && 
                (
                    this.Elements == other.Elements ||
                    this.Elements != null &&
                    this.Elements.SequenceEqual(other.Elements)
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
                if (this.Id != null)
                    hash = hash * 59 + this.Id.GetHashCode();
                if (this.LastEdit != null)
                    hash = hash * 59 + this.LastEdit.GetHashCode();
                if (this.ElementsSet != null)
                    hash = hash * 59 + this.ElementsSet.GetHashCode();
                if (this.Day != null)
                    hash = hash * 59 + this.Day.GetHashCode();
                if (this.Elements != null)
                    hash = hash * 59 + this.Elements.GetHashCode();
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
