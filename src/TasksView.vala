namespace GTD {
    public class TasksView {
        TasksModel tasks;
        Gtk.TreeView tree;
        public Gtk.Box box;

        public TasksView (TasksModel tasks) {
            this.tasks = tasks;
            this.tree = new Gtk.TreeView.with_model (tasks.tree);
            this.box = new Gtk.Box (HORIZONTAL, 0);
            tree.headers_visible = false;

            var title_renderer = new Gtk.CellRendererText ();
            var title_column = new Gtk.TreeViewColumn.with_attributes (_("Title"), title_renderer, "text", 0);

            tree.append_column (title_column);

            box.homogeneous = false;
            box.pack_start (tree, true, true, 0);
        }
    }
}
