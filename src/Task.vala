namespace GTD {
    public class Task : Object {
        public string title;
        public List<Task> subtasks;

        construct {
            subtasks = new List<Task> ();
        }
    }
}
