using System;
using System.Threading.Tasks;

namespace WeekPlanner.Services
{
    public interface IDialogService
    {
        Task ShowAlertAsync(string message, string btnText = "OK", string title = null);
        Task<bool> ConfirmAsync(string message, string title = null, string cancelText = "Nej", string okText = "Ja");
        Task<string> ActionSheetAsync(string title = null, string cancel = "Annuller", string destructive = null, params string[] buttons);
    }
}
