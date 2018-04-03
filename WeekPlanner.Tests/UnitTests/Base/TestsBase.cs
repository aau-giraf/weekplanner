using System.Linq;
using AutoFixture;
using AutoFixture.AutoMoq;

namespace WeekPlanner.Tests.UnitTests.Base
{
    public abstract class TestsBase
    {
        protected readonly IFixture Fixture;

        protected TestsBase()
        {
            Fixture = new Fixture().Customize(new AutoMoqCustomization());
            
            // Limits the recursion depth when generating objects, so we use it for ResponseGirafUserDTO
            Fixture.Behaviors.OfType<ThrowingRecursionBehavior>().ToList()
                .ForEach(b => Fixture.Behaviors.Remove(b));
            Fixture.Behaviors.Add(new OmitOnRecursionBehavior());
        }
    }
}