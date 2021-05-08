namespace GTD {
    errordomain TreeAccessError {
        OUT_OF_RANGE
    }

    public class TasksModel : Object, Gtk.TreeModel {
        public GTD.Task root_task = new GTD.Task () { title = "", notes = "" };

        Gee.HashMap<int32, unowned GTD.Task> id_lookup_map = new Gee.HashMap<int32, unowned GTD.Task> (); // :sanic:

        construct {
            root_task.subtask_added.connect (on_subtask_added);
        }

        void on_subtask_added (GTD.Task subtask) {
            subtask.subtask_added.connect (on_subtask_added);

            id_lookup_map[subtask.id] = subtask;

            row_inserted (subtask_to_path (subtask), task_to_iter (subtask));

            if (subtask.parent != null && subtask.parent.subtasks.length () == 1) {
                row_has_child_toggled (subtask_to_path (subtask.parent), task_to_iter (subtask.parent));
            }
        }

        int32 path_to_id (GTD.Task parent, int[] indices) throws TreeAccessError {
            if (parent.subtasks.length () == 0) throw new TreeAccessError.OUT_OF_RANGE ("");

            if (indices.length == 1) {
                return parent.subtasks.nth_data (indices[0]).id;
            } else {
                return path_to_id (parent.subtasks.nth_data (indices[0]), indices[1:]);
            }
        }

        int find_subtask_index (GTD.Task parent, GTD.Task task) {
            for (int i = 0; i < parent.subtasks.length (); i++) {
                if (parent.subtasks.nth_data (i) == task) return i;
            }

            return -1;
        }

        public GTD.Task iter_to_task (Gtk.TreeIter iter) {
            return id_lookup_map[iter.stamp];
        }

        Gtk.TreePath subtask_to_path (GTD.Task task) {
            var result = new Gtk.TreePath ();
            var parent = task.parent;

            while (parent != null) {
                result.prepend_index (find_subtask_index (parent, task));

                task = parent;
                parent = task.parent;
            }

            return result;
        }

        Gtk.TreeIter task_to_iter (GTD.Task task) {
            return Gtk.TreeIter () { stamp = (int) task.id };
        }

        public Type get_column_type (int index) {
            return typeof (GTD.Task);
        }

        public Gtk.TreeModelFlags get_flags () {
            return 0;
        }

        public bool get_iter (out Gtk.TreeIter iter, Gtk.TreePath path) {
            iter = Gtk.TreeIter ();

            try {
                var id = path_to_id (root_task, path.get_indices ());
                iter = Gtk.TreeIter () { stamp = (int) id };

                return true;
            } catch {

                return false;
            }
        }

        public int get_n_columns () {
            return 1;
        }

        public Gtk.TreePath? get_path (Gtk.TreeIter iter) {
            return new Gtk.TreePath.from_indices (subtask_to_path (iter_to_task (iter)));
        }

        public void get_value (Gtk.TreeIter iter, int column, out Value value) {
            value = iter_to_task (iter);
        }

        public bool iter_children (out Gtk.TreeIter iter, Gtk.TreeIter? parent) {
            iter = Gtk.TreeIter ();

            if (parent == null) {
                if (root_task.subtasks.length () > 0) iter = task_to_iter (root_task.subtasks.nth_data (0));

                return root_task.subtasks.length () > 0;
            } else {
                if (iter_has_child (parent)) {
                    iter = task_to_iter (iter_to_task (parent).subtasks.nth_data (0));
                }

                return iter_has_child (parent);
            }
        }

        public bool iter_has_child (Gtk.TreeIter iter) {
            return iter_to_task (iter).subtasks.length () > 0;
        }

        public int iter_n_children (Gtk.TreeIter? iter) {
            if (iter == null) {
                return (int) root_task.subtasks.length ();
            } else {
                return (int) iter_to_task (iter).subtasks.length ();
            }
        }

        public bool iter_next (ref Gtk.TreeIter iter) {
            var task = iter_to_task (iter);
            var index = find_subtask_index (task.parent, task);

            if (index == task.parent.subtasks.length () - 1) {
                return false;
            } else {
                iter = task_to_iter (task.parent.subtasks.nth_data (index + 1));

                return true;
            }
        }

        public bool iter_nth_child (out Gtk.TreeIter iter, Gtk.TreeIter? parent, int n) {
            if (parent == null) {
                iter = task_to_iter (root_task.subtasks.nth_data (n));

                return n < root_task.subtasks.length ();
            } else {
                var task = iter_to_task (parent);

                iter = task_to_iter (task.subtasks.nth_data (n));

                return n < task.subtasks.length ();
            }
        }

        public bool iter_parent (out Gtk.TreeIter iter, Gtk.TreeIter child) {
            var task = iter_to_task (child);

            iter = task_to_iter (task.parent);

            return task.parent != root_task && task.parent != null;
        }
    }
}
