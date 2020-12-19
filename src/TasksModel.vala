namespace GTD {
    public class TasksModel {
        GTD.Task[] tasks;
        public Gtk.TreeStore tree = new Gtk.TreeStore.newv ({typeof (string)});
        
        public void @foreach (GTD.Task.ForeachFunc f) {
            foreach (var task in tasks) {
                f (task);
                task.foreach_rec (f);
            }
        }

        public void add_task (GTD.Task task) {
            tasks += task;
            add_task_rec (task, null);
        }

        void add_task_rec (GTD.Task task, Gtk.TreeIter? top) {
            Gtk.TreeIter iter;
            tree.append (out iter, top);
            tree.@set (iter, 0, task.title);

            foreach (GTD.Task subtask in task.subtasks) add_task_rec (subtask, iter);
        }
    }
}
