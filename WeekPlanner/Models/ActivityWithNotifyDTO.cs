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
        private ActivityDTO.StateEnum? _state;
        private WeekPictogramDTO _pictogram;
        private int? _order;
        private bool? _isChoiceBoard;
        private long? _choiceBoardId;

        public ActivityWithNotifyDTO(WeekPictogramDTO Pictogram = default(WeekPictogramDTO), int? Order = default(int?), ActivityDTO.StateEnum? State = default(ActivityDTO.StateEnum?), bool? IsChoiceBoard = default(bool?), long? Id = default(long?))
        {
            this.Pictogram = Pictogram;
            this.Order = Order;
            this.State = State;
            this.IsChoiceBoard = IsChoiceBoard;
            this.Id = Id;
        }

        public ActivityDTO.StateEnum? State
        {
            get => _state;
            set
            {
                if (value == _state) return;
                _state = value;
                OnPropertyChanged();
            }
        }

        public WeekPictogramDTO Pictogram
        {
            get => _pictogram;
            set
            {
                if (Equals(value, _pictogram)) return;
                _pictogram = value;
                OnPropertyChanged();
            }
        }

        public int? Order
        {
            get => _order;
            set
            {
                if (value == _order) return;
                _order = value;
                OnPropertyChanged();
            }
        }

        public long? Id { get; private set; }

        public bool? IsChoiceBoard
        {
            get => _isChoiceBoard;
            set
            {
                if (value == _isChoiceBoard) return;
                _isChoiceBoard = value;
                OnPropertyChanged();
            }
        }

        public long? ChoiceBoardID
        {
            get => _choiceBoardId;
            set
            {
                if (value == _choiceBoardId) return;
                _choiceBoardId = value;
                OnPropertyChanged();
            }
        }

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