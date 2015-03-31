using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Business.Logic.Layer.Managers.Tasks
{
    public class AsyncTaskManager
    {
        public Dictionary<Int32, Action> TaskQueue { get; set; }
        protected Dictionary<Int32, Task> RunningTasks { get; set; }

        public AsyncTaskManager()
        {
            TaskQueue = new Dictionary<int, Action>();
            RunningTasks = new Dictionary<int, Task>();
        }

        public void AddTask(Int32 id, Action workerAction)
        {
            TaskQueue.Add(id, workerAction);
        }

        public bool TasksInProgress()
        {
            if (RunningTasks.Count == 0)
            {
                return false;
            }

            return !RunningTasks.All(task => task.Value.IsCompleted);
        }

        public void RunTasks()
        {
            RunningTasks.Clear();

            foreach (Task sqlTask in TaskQueue.Select(action => new Task(action.Value)))
            {
                RunningTasks.Add(sqlTask.Id.GetHashCode(), sqlTask);
                sqlTask.Start();
            }
            TaskQueue.Clear();
        }
    }
}