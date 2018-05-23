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
    public class ChooseCitizenPageTests
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
        private const string LoginPage = "LoginPage";
        private const string CitizenSchedulePage = "CitizenSchedulesPage";
        private const string SearchBar = "SearchBar";
        private const string ListView = "The_ListView";

        public ChooseCitizenPageTests(Platform platform)
        {
            _platform = platform;
        }

        [SetUp]
        public void BeforeEachTest()
        {
            _app = AppInitializer.StartApp(_platform);
            _app.Tap(UsernameEntry);
            _app.EnterText("Graatand");
            _app.PressEnter();
            _app.WaitForElement(PasswordEntry);
            _app.EnterText("password");
            _app.PressEnter();
            _app.WaitForElement(ChooseCitizenPage);
        }

        [Test]
        public void AppLaunches()
        {
            _app.Screenshot("First screen.");
        }
        
        [Test]
        public void BackButton_NavigatesToLoginPage()
        {
            _app.TapCoordinates(50, 50);

            var result = _app.WaitForElement(LoginButton, "Timed out", TimeSpan.FromSeconds(10));

            Assert.AreEqual(1, result.Length);
        }

        [Test]
        public void CitizenTap_NavigatesToCitizenSchedulesPage()
        {
            _app.Repl();
            _app.Tap(x => x.Text("BirkenBorger1"));

            var result = _app.WaitForElement(CitizenSchedulePage);

            Assert.AreEqual(1, result.Length);
        }
    }
}
