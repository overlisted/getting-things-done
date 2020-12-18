namespace GTD {
    public class TasksView : Gtk.TreeView {
        TasksModel tasks;

        public TasksView (TasksModel tasks) {
            this.tasks = tasks;

            var title_renderer = new Gtk.CellRendererText ();
            var title_column = new Gtk.TreeViewColumn.with_attributes (_("Title"), title_renderer, "text", 0);

            append_column(title_column);

            model = tasks.tree;
            headers_visible = false;
        }
    }
}
