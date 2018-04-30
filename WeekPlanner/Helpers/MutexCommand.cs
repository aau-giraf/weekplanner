using System;
using System.Windows.Input;

namespace WeekPlanner.Helpers
{
    /// <summary>
    /// Class MutexCommand.
    /// </summary>
    public class MutexCommand : ICommand, ITapLock
    {
        /// <summary>
        /// The _execute
        /// </summary>
        private readonly Action execute;

        /// <summary>
        /// The _can execute
        /// </summary>
        private readonly Func<bool> canExecute;

        /// <summary>
        /// Gets or sets the tap lock variables.
        /// </summary>
        /// <value>The tap lock variables.</value>
        public TapLockVars TapLockVars { get; set; }

        /// <summary>
        /// Initializes a new instance of the <see cref="MutexCommand"/> class.
        /// </summary>
        /// <param name="execute">The execute.</param>
        /// <param name="canExecute">The can execute.</param>
        /// <exception cref="ArgumentNullException">execute</exception>
        public MutexCommand(Action execute, Func<bool> canExecute = null)
        {
            this.execute = execute ?? throw new ArgumentNullException(nameof(execute));

            if (canExecute != null)
            {
                this.canExecute = canExecute;
            }
        }

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

        /// <summary>
        /// Defines the method that determines whether the command can execute in its current state.
        /// </summary>
        /// <param name="parameter">Data used by the command.  If the command does not require data to be passed, this object can be set to null.</param>
        /// <returns>true if this command can be executed; otherwise, false.</returns>
        public bool CanExecute(object parameter)
        {
            return canExecute == null || canExecute.Invoke();
        }

        /// <summary>
        /// Defines the method to be called when the command is invoked.
        /// </summary>
        /// <param name="parameter">Data used by the command.  If the command does not require data to be passed, this object can be set to null.</param>
        public virtual void Execute(object parameter)
        {
            if (CanExecute(parameter) && this.AcquireTapLock())
            {
                execute.Invoke();
            }
        }
    }

    /// <summary>
    /// Class MutexCommand.
    /// </summary>
    public class MutexCommand<T> : ICommand, ITapLock
    {
        /// <summary>
        /// The _execute
        /// </summary>
        private readonly Action<T> execute;

        /// <summary>
        /// The _can execute
        /// </summary>
        private readonly Func<bool> canExecute;

        /// <summary>
        /// Gets or sets the tap lock variables.
        /// </summary>
        /// <value>The tap lock variables.</value>
        public TapLockVars TapLockVars { get; set; }

        /// <summary>
        /// Initializes a new instance of the <see cref="MutexCommand"/> class.
        /// </summary>
        /// <param name="execute">The execute.</param>
        /// <param name="canExecute">The can execute.</param>
        /// <exception cref="ArgumentNullException">execute</exception>
        public MutexCommand(Action<T> execute, Func<bool> canExecute = null)
        {
            this.execute = execute ?? throw new ArgumentNullException(nameof(execute));

            if (canExecute != null)
            {
                this.canExecute = canExecute;
            }
        }

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

        /// <summary>
        /// Defines the method that determines whether the command can execute in its current state.
        /// </summary>
        /// <param name="parameter">Data used by the command.  If the command does not require data to be passed, this object can be set to null.</param>
        /// <returns>true if this command can be executed; otherwise, false.</returns>
        public bool CanExecute(object parameter)
        {
            return canExecute == null || canExecute.Invoke();
        }

        /// <summary>
        /// Defines the method to be called when the command is invoked.
        /// </summary>
        /// <param name="parameter">Data used by the command.  If the command does not require data to be passed, this object can be set to null.</param>
        public virtual void Execute(object parameter)
        {
            if (CanExecute(parameter) && this.AcquireTapLock())
            {
                execute.Invoke((T)parameter);
            }
        }
    }
    
    public interface ITapLock
    {
        TapLockVars TapLockVars { get; set; }
    }

    public struct TapLockVars
    {   
        public bool Locked;
    }
    public static class TapLockExtensions
    {

        private static DateTime _lastTappedTime = DateTime.Now;
        public static bool AcquireTapLock(this ITapLock obj)
        {
            // if locked is true, return false
            // if locked is false, set to true and return true
            try
            {
                var vars = obj.TapLockVars;
                return (!vars.Locked && (vars.Locked = true) && (obj.TapLockVars = vars).Locked) ||
                       _lastTappedTime.AddSeconds(3) < DateTime.Now;
            }
            finally
            {
                _lastTappedTime = DateTime.Now;
            }


        }

        public static void ReleaseTapLock(this ITapLock obj)
        {
            var vars = obj.TapLockVars;
            vars.Locked = false;
            obj.TapLockVars = vars;
        }

    }
}