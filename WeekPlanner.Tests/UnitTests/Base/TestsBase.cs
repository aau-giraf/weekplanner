using System;
using System.Linq;
using System.Threading.Tasks;
using AutoFixture;
using AutoFixture.AutoMoq;
using IO.Swagger.Client;
using IO.Swagger.Model;
using Moq;
using WeekPlanner.Services.Request;
using WeekPlanner.ViewModels;

namespace WeekPlanner.Tests.UnitTests.Base
{
    public abstract class TestsBase
    {
        protected readonly IFixture Fixture;

        /// <summary>
        /// Freezes mock of IRequestService.
        /// </summary>
        /// <typeparam name="TR">Type of the response, for example ResponseWeekDTO</typeparam>
        public void FreezeMockOfIRequestService<TR>() where TR : class
        {
            async Task SendRequestAndThenAsyncMock(Func<Task<TR>> requestAsync, Func<TR, Task> onSuccessAsync, 
                Func<Task> onExceptionAsync, Func<Task> onRequestFailedAsync, string exceptionMessage, string requestFailedMessage)
            {
                var res = await requestAsync.Invoke();
                await onSuccessAsync(res);
            }

            Fixture.Freeze<Mock<IRequestService>>().Setup(r =>
                    r.SendRequestAndThenAsync(It.IsAny<Func<Task<TR>>>(),
                        It.IsAny<Func<TR, Task>>(), It.IsAny<Func<Task>>(), It.IsAny<Func<Task>>(),
                        It.IsAny<string>(), It.IsAny<string>()))
                .Returns((Func<Func<Task<TR>>, Func<TR, Task>, Func<Task>, Func<Task>,
                    string, string, Task>) SendRequestAndThenAsyncMock);
        }
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