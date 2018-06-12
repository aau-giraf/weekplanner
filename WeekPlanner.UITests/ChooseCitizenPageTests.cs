using System;
using System.IO;
using System.Linq;
using NUnit.Framework;
using Xamarin.UITest;
using Xamarin.UITest.Queries;
using static WeekPlanner.UITests.UITestStrings;
using static WeekPlanner.UITests.LoginPageTests;

namespace WeekPlanner.UITests
{
    [TestFixture(Platform.Android)]
    [TestFixture(Platform.iOS)]
    public class ChooseCitizenPageTests
    {
        IApp _app;
        readonly Platform _platform;


      
        public ChooseCitizenPageTests(Platform platform)
        {
            _platform = platform;
        }

        [SetUp]
        public void BeforeEachTest()
        {
            _app = AppInitializer.StartApp(_platform);
			EnterUsernameAndPassword(_app);
            _app.PressEnter();
            _app.WaitForElement(ChooseCitizenPage);
        }
        
        [Test]
        public void BackButton_NavigatesToLoginPage()
        {
			_app.Tap(BackButton);

            var result = _app.WaitForElement(LoginButton);

            Assert.AreEqual(1, result.Length);
        }

        [Test]
        public void CitizenTap_NavigatesToCitizenSchedulesPage()
        {
            _app.Tap(x => x.Text(User1));

			var result = _app.WaitForElement(CitizenSchedulePage);

            Assert.AreEqual(1, result.Length);
        }

        [Test]
        public void Search_CitizenFind()
        {
            _app.Tap(SearchBar);
            _app.EnterText(User1);
            _app.PressEnter();

            var result = _app.Query(x => x.Text(User1));

            Assert.AreEqual(1, result.Length);
        }
    }
}
