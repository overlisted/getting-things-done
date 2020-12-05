namespace GTD {
    public class TasksView : Gtk.TreeView {
        Gtk.TreeStore store;

        construct {
            store = new Gtk.TreeStore (2, typeof (string), typeof (Gtk.Popover));

            var title_renderer = new Gtk.CellRendererText ();
            var title_column = new Gtk.TreeViewColumn.with_attributes (_("Title"), title_renderer, "text", 0);

            append_column(title_column);

            model = store;
        }

        public void add_task(GTD.Task task, Gtk.TreeIter? top) {
            Gtk.TreeIter iter;
            store.append (out iter, top);
            store.@set (iter, 0, task.title);

            foreach (GTD.Task subtask in task.subtasks) add_task (subtask, iter);
        }
    }
}
