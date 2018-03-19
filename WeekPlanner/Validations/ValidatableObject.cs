using System.Collections.Generic;
using System.Linq;
using WeekPlanner.ViewModels.Base;

namespace WeekPlanner.Validations
{
    public class ValidatableObject<T> : ExtendedBindableObject, IValidity
    {
        private readonly IEnumerable<IValidationRule<T>> _validations;
		private IReadOnlyList<string> _errors;
        private T _value;
        private bool _isValid;

        public IEnumerable<IValidationRule<T>> Validations => _validations;

		public IReadOnlyList<string> Errors
		{
			get
			{
				return _errors;
			}
			set
			{
				_errors = value;
				RaisePropertyChanged(() => Errors);
			}
		}

        public T Value
        {
            get
            {
                return _value;
            }
            set
            {
                _value = value;
                RaisePropertyChanged(() => Value);
            }
        }

        public bool IsValid
        {
            get
            {
                return _isValid;
            }
            set
            {
                _isValid = value;
                RaisePropertyChanged(() => IsValid);
            }
        }

        public ValidatableObject(params IValidationRule<T>[] validations)
        {
            _isValid = true;
            _errors = new List<string>();
            _validations = validations;
        }

        public bool Validate()
        {
            IEnumerable<string> errors = _validations.Where(v => !v.Check(Value))                             
                .Select(v => v.ValidationMessage);

			Errors = errors.ToList();
            IsValid = !Errors.Any();

            return this.IsValid;
        }
    }
}
