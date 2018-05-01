using System;
using System.Windows.Input;

namespace WeekPlanner.Helpers
{
    /// <summary>
    /// Class SingleExecuteCommand.
    /// </summary>
    public class SingleExecuteCommand : ICommand
    {
        /// <summary>
        /// The _execute
        /// </summary>
        private readonly Action _execute;

        /// <summary>
        /// The _can execute
        /// </summary>
        protected Func<bool> _canExecute;

        protected DateTime LastExecutedTimeStamp;

        /// <summary>
        /// Initializes a new instance of the <see cref="SingleExecuteCommand"/> class.
        /// </summary>
        /// <param name="execute">The execute.</param>
        /// <param name="canExecute">The can execute.</param>
        /// <param name="secondsBetweenEachExecute">Time is seconds between each possible execute.</param>
        /// <exception cref="ArgumentNullException">execute</exception>
        public SingleExecuteCommand(Action execute, Func<bool> canExecute = null, int secondsBetweenEachExecute = 3)
        {
            _execute = execute ?? throw new ArgumentNullException(nameof(execute));
            
            LastExecutedTimeStamp = DateTime.MinValue;

            _sufficientSecondsInSeconds = secondsBetweenEachExecute;
            
            if (canExecute != null)
            {
                _canExecute = canExecute;
            }
        }
        
        protected SingleExecuteCommand()
        {}

        private readonly int _sufficientSecondsInSeconds = 3;

        protected bool SufficienctTimeHasPassedSinceLastExecute() => 
            (DateTime.Now - LastExecutedTimeStamp).Seconds > _sufficientSecondsInSeconds;

        /// <inheritdoc />
        /// <summary>
        /// Occurs when changes occur that affect whether the command should execute.
        /// </summary>
        public event EventHandler CanExecuteChanged;

        /// <summary>
        /// Raises the can execute changed.
        /// </summary>
        public void RaiseCanExecuteChanged()
        {
            CanExecuteChanged?.Invoke(this, EventArgs.Empty);
        }

        /// <inheritdoc />
        /// <summary>
        /// Defines the method that determines whether the command can execute in its current state.
        /// </summary>
        /// <param name="parameter">Data used by the command.  If the command does not require data to be passed, this object can be set to null.</param>
        /// <returns>true if this command can be executed; otherwise, false.</returns>
        public bool CanExecute(object parameter)
        {
            return _canExecute == null || _canExecute.Invoke();
        }

        /// <inheritdoc />
        /// <summary>
        /// Defines the method to be called when the command is invoked.
        /// Only executes if CanExecute is true and more than the given time has passed.
        /// Default time is 3 seconds.
        /// </summary>
        /// <param name="parameter">Data used by the command.  If the command does not require data to be passed, this object can be set to null.</param>
        public virtual void Execute(object parameter)
        {
            if (CanExecute(parameter) && SufficienctTimeHasPassedSinceLastExecute())
            {
                LastExecutedTimeStamp = DateTime.Now;
                _execute.Invoke();
            }
        }
    }

    public class SingleExecuteCommand<T> : SingleExecuteCommand
    {
        private readonly Action<T> _execute;
        
        public SingleExecuteCommand(Action<T> execute, Func<bool> canExecute = null)
        {
            _execute = execute ?? throw new ArgumentNullException(nameof(execute));
            
            LastExecutedTimeStamp = DateTime.MinValue;
            
            if (canExecute != null)
            {
                _canExecute = canExecute;
            }
        }
        
        /// <inheritdoc />
        /// <summary>
        /// Defines the method to be called when the command is invoked.
        /// </summary>
        /// <param name="parameter">Data used by the command.  If the command does not require data to be passed, this object can be set to null.</param>
        public override void Execute(object parameter)
        {
            if (CanExecute(parameter) && SufficienctTimeHasPassedSinceLastExecute())
            {
                LastExecutedTimeStamp = DateTime.Now;
                _execute.Invoke((T) parameter);
            }
        }
        
    }

}