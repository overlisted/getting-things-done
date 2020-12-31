namespace GTD {
    public class TasksModel {
        GTD.Task[] tasks;
        public Gtk.TreeStore tree = new Gtk.TreeStore.newv ({typeof (GTD.Task)});

        public void @foreach (GTD.Task.ForeachFunc f) {
            foreach (var task in tasks) {
                f (task);
                task.foreach_rec (f);
            }
        }

        public void remove_task (GTD.Task task) {
            remove_task_uuid (task.uuid);
        }

        // not tested lol
        public void remove_task_uuid (string uuid) {
            tree.@foreach ((model, path, iter) => {
                GTD.Task it;
                model.@get (iter, out it);

                if (it.uuid == uuid) {
                    tree.remove (ref iter);
                    return true;
                }

                return false;
            });
        }

        public void add_task (GTD.Task task) {
            tasks += task;
            add_task_rec (task, null);
        }

        void add_task_rec (GTD.Task task, Gtk.TreeIter? top) {
            Gtk.TreeIter iter;
            tree.append (out iter, top);
            tree.@set (iter, 0, task);

            foreach (GTD.Task subtask in task.subtasks) add_task_rec (subtask, iter);
        }
    }
}
