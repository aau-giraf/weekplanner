using System.ComponentModel;
using System.Runtime.CompilerServices;
using System.Text;
using IO.Swagger.Model;
using WeekPlanner.Annotations;

namespace WeekPlanner.Models
{
    /// <summary>
    /// ActivityDTO
    /// </summary>
    public class ActivityWithNotifyDTO : INotifyPropertyChanged
    {
        public ActivityDTO.StateEnum? State { get; set; }

        public ActivityWithNotifyDTO(WeekPictogramDTO Pictogram = default(WeekPictogramDTO), int? Order = default(int?), ActivityDTO.StateEnum? State = default(ActivityDTO.StateEnum?), bool? IsChoiceBoard = default(bool?), long? Id = default(long?))
        {
            this.Pictogram = Pictogram;
            this.Order = Order;
            this.State = State;
            this.IsChoiceBoard = IsChoiceBoard;
            this.Id = Id;
        }
        
        public WeekPictogramDTO Pictogram { get; set; }

        public int? Order { get; set; }

        public long? Id { get; private set; }

        public bool? IsChoiceBoard { get; set; }
        public long? ChoiceBoardID { get; set; }

        public event PropertyChangedEventHandler PropertyChanged;

        [NotifyPropertyChangedInvocator]
        protected virtual void OnPropertyChanged([CallerMemberName] string propertyName = null)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }
        
        public override string ToString()
        {
            var sb = new StringBuilder();
            sb.Append("class ActivityDTO {\n");
            sb.Append("  Pictogram: ").Append(Pictogram).Append("\n");
            sb.Append("  Order: ").Append(Order).Append("\n");
            sb.Append("  State: ").Append(State).Append("\n");
            sb.Append("  Id: ").Append(Id).Append("\n");
            sb.Append("  IsChoiceBoard: ").Append(IsChoiceBoard).Append("\n");
            sb.Append("}\n");
            return sb.ToString();
        }
    }
}