namespace GTD {
    public class TasksModel {
        public Gtk.TreeStore tree = new Gtk.TreeStore.newv ({typeof (string)});

        public void add_task (GTD.Task task, Gtk.TreeIter? top) {
            Gtk.TreeIter iter;
            tree.append (out iter, top);
            tree.@set (iter, 0, task.title);

            foreach (GTD.Task subtask in task.subtasks) add_task (subtask, iter);
        }
    }
}
