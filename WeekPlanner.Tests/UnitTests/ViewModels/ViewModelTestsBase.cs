using System.Linq;
using AutoFixture;
using AutoFixture.AutoMoq;

namespace WeekPlanner.Tests.UnitTests.ViewModels
{
    public abstract class ViewModelTestsBase
    {
        protected readonly IFixture Fixture;

        protected ViewModelTestsBase()
        {
            Fixture = new Fixture().Customize(new AutoMoqCustomization());
            
            // Limits the recursion depth when generating objects, so we use it for ResponseGirafUserDTO
            Fixture.Behaviors.OfType<ThrowingRecursionBehavior>().ToList()
                .ForEach(b => Fixture.Behaviors.Remove(b));
            Fixture.Behaviors.Add(new OmitOnRecursionBehavior());
        }
    }
}