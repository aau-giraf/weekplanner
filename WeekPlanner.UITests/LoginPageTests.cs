using System;
using System.IO;
using System.Linq;
using NUnit.Framework;
using Xamarin.UITest;
using Xamarin.UITest.Queries;
using static WeekPlanner.UITests.UITestStrings;

namespace WeekPlanner.UITests
{
    [TestFixture(Platform.Android)]
    [TestFixture(Platform.iOS)]
    public class LoginPageTests
    {
        private IApp _app;
        private readonly Platform _platform;
             
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
            EnterUsernameAndPassword(_app);
            _app.PressEnter();
            
            var result = _app.WaitForElement(ChooseCitizenPage);
			Assert.AreEqual(1, result.Length);
        }

        [Test]
        public void Login_UsingGuardianAndButtonPress_NavigatesToChooseCitizenPage()
        {
            EnterUsernameAndPassword(_app);
            _app.DismissKeyboard();
            _app.WaitForElement(LoginButton, "Timed out", TimeSpan.FromSeconds(10));
            _app.Tap(LoginButton);

            var result = _app.WaitForElement(ChooseCitizenPage);
            Assert.AreEqual(1, result.Length);
        }

		public static void EnterUsernameAndPassword(IApp app)
        {
            app.Tap(UsernameEntry);
            app.EnterText(Username);
            app.PressEnter();
            app.WaitForElement(PasswordEntry);
            app.EnterText(Password);   
        }
        #endregion
        
        #region ValidationErrors
        [Test]
        public void EntryErrorMessages_NothingDone_NotShown_Username()
        {
            var usernameResult = _app.Query(UsernameValidationErrorLabel);

            Assert.AreEqual(string.Empty, usernameResult.First().Text);
        }

        [Test]
        public void EntryErrorMessages_NothingDone_NotShown_Password()
        {
            var passwordResult = _app.Query(PasswordValidationErrorLabel);

            Assert.AreEqual(string.Empty, passwordResult.First().Text);
        }

        [Test]
        public void UsernameErrorMessage_EmptyUsername_Shown()
        {
            _app.Tap(UsernameEntry);
            _app.PressEnter();
            var result = _app.Query(UsernameValidationErrorLabel);
			Assert.AreNotEqual(string.Empty, result.FirstOrDefault()?.Text);
        }
        
        
		[Test] // Failing
        public void PasswordErrorMessage_EmptyPassword_Shown()
        {
            _app.Tap(PasswordEntry);
            _app.PressEnter();
            var result = _app.Query(PasswordValidationErrorLabel);
			Assert.AreNotEqual(string.Empty, result.FirstOrDefault()?.Text);
        }
        #endregion
        
        
    }
}
