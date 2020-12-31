namespace GTD {
    public class Task : Object {
        public delegate void ForeachFunc (GTD.Task task);
        
        public string uuid;
        public string title;
        public List<Task> subtasks;

        public void foreach_flat (ForeachFunc f) {
            foreach (var task in subtasks) {
                f (task);
            }
        }

        public void foreach_rec (ForeachFunc f) {
            foreach_rec_step (f, this);
        }

        static void foreach_rec_step (ForeachFunc f, Task task) {
            task.foreach_flat (it => {
                foreach_rec_step (f, it);
                f (it);
            });
        }

        construct {
            uuid = Uuid.string_random ();
            subtasks = new List<Task> ();
        }
    }
}
