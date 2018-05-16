using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using IO.Swagger.Model;
using WeekPlanner.Models;
using Xamarin.Forms.Internals;

namespace WeekPlanner.Helpers
{
    public static class ActivityDTOExtensions
    {
        public static ActivityWithNotifyDTO ToActivityWithNotifyDTO(this ActivityDTO activityDTO)
        {
            return new ActivityWithNotifyDTO(activityDTO.Pictogram, activityDTO.Order,
                activityDTO.State, activityDTO.IsChoiceBoard, activityDTO.Id)
            {
                ChoiceBoardID = activityDTO.ChoiceBoardID
            };
        }

        public static ActivityDTO ToActivityDTO(this ActivityWithNotifyDTO activityWithNotifyDTO)
        {
            return new ActivityDTO(activityWithNotifyDTO.Pictogram, activityWithNotifyDTO.Order, 
                activityWithNotifyDTO.State, activityWithNotifyDTO.IsChoiceBoard, activityWithNotifyDTO.Id)
                {
                ChoiceBoardID = activityWithNotifyDTO.ChoiceBoardID
                };
        }

        public static IEnumerable<ActivityWithNotifyDTO> ToActivityWithNotifyDTOs(
            this IEnumerable<ActivityDTO> activityDTOs)
        {
            return activityDTOs.Select(a => a.ToActivityWithNotifyDTO());
        }
        
        public static IEnumerable<ActivityDTO> ToActivityDTOs(
            this IEnumerable<ActivityWithNotifyDTO> activityWithNotifyDTOs)
        {
            return activityWithNotifyDTOs.Select(a => a.ToActivityDTO());
        }

        public static void AddRange<T>(this ObservableCollection<T> observableCollection, 
            IEnumerable<T> rangeToAdd)
        {
            rangeToAdd.ForEach(observableCollection.Add);
        }
    }
}