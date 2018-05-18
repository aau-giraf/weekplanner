using System;
using System.IO;
using System.Linq;
using NUnit.Framework;
using Xamarin.UITest;
using Xamarin.UITest.Queries;

namespace WeekPlanner.UITests
{
    [TestFixture(Platform.Android)]
    //[TestFixture(Platform.iOS)]
    public class LoginPageTests
    {
        IApp _app;
        readonly Platform _platform;
        
        // Entries
        private const string UsernameEntry = "UsernameEntry";
        private const string PasswordEntry = "PasswordEntry";
        
        private const string UsernameValidationErrorLabel = "UsernameValidationErrors";
        private const string PasswordValidationErrorLabel = "PasswordValidationErrors";
        
        private const string LoginButton = "LoginButton";
        private const string ChooseCitizenPage = "ChooseCitizenPage";

        public LoginPageTests(Platform platform)
        {
            _platform = platform;
        }

        [SetUp]
        public void BeforeEachTest()
        {
            _app = AppInitializer.StartApp(_platform);
        }

        [Test]
        public void AppLaunches()
        {
            _app.Screenshot("First screen.");
        }

        #region Login
        [Test]
        public void Login_UsingGuardian_NavigatesToChooseCitizenPage()
        {
            _app.Tap(UsernameEntry);
            _app.EnterText("Graatand");
            _app.PressEnter();
            _app.WaitForElement(PasswordEntry);
            _app.EnterText("password");
            _app.PressEnter();
            
            var result = _app.WaitForElement(ChooseCitizenPage);
			Assert.AreEqual(1, result.Length);
        }

        [Test]
        public void Login_UsingGuardianAndButtonPress_NavigatesToChooseCitizenPage()
        {
            _app.Tap(UsernameEntry);
            _app.EnterText("Graatand");
            _app.PressEnter();
            _app.WaitForElement(PasswordEntry);
            _app.EnterText("password");
            _app.DismissKeyboard();
            _app.WaitForElement(LoginButton);
            _app.Tap(LoginButton);

            var result = _app.WaitForElement(ChooseCitizenPage);
            Assert.AreEqual(1, result.Length);
        }
        #endregion
        
        #region ValidationErrors
        [Test]
        public void EntryErrorMessages_NothingDone_NotShown()
        {
            var usernameResult = _app.Query(UsernameValidationErrorLabel);
            var passwordResult = _app.Query(PasswordValidationErrorLabel);
            Assert.AreEqual(0, usernameResult.Length);
            Assert.AreEqual(0, passwordResult.Length);
        }

        [Test]
        public void UsernameErrorMessage_EmptyUsername_Shown()
        {
            _app.Tap(UsernameEntry);
            _app.PressEnter();
            var result = _app.Query(UsernameValidationErrorLabel);
            Assert.AreEqual(0, result.Length);
        }
        
        [Test]
        public void PasswordErrorMessage_EmptyPassword_Shown()
        {
            _app.Tap(PasswordEntry);
            _app.PressEnter();
            var result = _app.Query(PasswordValidationErrorLabel);
            Assert.AreEqual(0, result.Length);
        }
        #endregion
    }
}
