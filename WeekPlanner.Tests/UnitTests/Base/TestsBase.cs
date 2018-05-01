using System;
using System.Linq;
using System.Threading.Tasks;
using AutoFixture;
using AutoFixture.AutoMoq;
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
        /// <typeparam name="TS">Type of the sender, typically viewmodel</typeparam>
        /// <typeparam name="TR">Type of the response, for example ResponseWeekDTO</typeparam>
        public void FreezeMockOfIRequestService<TS,TR>() where TS : class where TR : class
        {
            Func<TS, Func<Task<TR>>, Func<TR, Task>, Func<Task>, Func<Task>,
                    string, string, Task>
                sendRequestAndThenAsyncMock =
                    async (sender, requestAsync, onSuccessAsync, onExceptionAsync, onRequestFailedAsync,
                        exceptionMessage, requestFailedMessage) =>
                    {
                        var res = await requestAsync.Invoke();
                        await onSuccessAsync(res);
                    };
            var mockRequest = Fixture.Freeze<Mock<IRequestService>>().Setup(r =>
                    r.SendRequestAndThenAsync(It.IsAny<TS>(), It.IsAny<Func<Task<TR>>>(),
                        It.IsAny<Func<TR, Task>>(), It.IsAny<Func<Task>>(), It.IsAny<Func<Task>>(),
                        It.IsAny<string>(), It.IsAny<string>()))
                .Returns(sendRequestAndThenAsyncMock);
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