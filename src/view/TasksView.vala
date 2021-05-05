namespace GTD {
    public class TasksView : Gtk.Paned {
        TasksModel tasks;
        Gtk.TreeView tree;
        Gtk.Stack stack;
        Gtk.TreeViewColumn title_column;

        void initialize_stack () {
            var model_paths = new List<Gtk.TreePath> ();
            var model_tasks = new List<GTD.Task> ();
            tasks.tree.@foreach ((model, path, it) => {
                model_paths.append (path);
                return false;
            });

            tasks.@foreach (it => model_tasks.append (it));
            for (int i = 0; i < model_paths.length (); i++) {
                stack.add_named (new TaskDetails (model_tasks.nth (i).data), model_paths.nth (i).data.to_string ());
            }
        }

        public TasksView (TasksModel tasks, Gtk.Button new_task_button) {
            Object (orientation: Gtk.Orientation.HORIZONTAL);

            this.tasks = tasks;
            this.tree = new Gtk.TreeView.with_model (tasks.tree);
            this.stack = new Gtk.Stack ();
            tree.headers_visible = false;

            var cell_renderer = new CellRendererTask ();
            title_column = new Gtk.TreeViewColumn.with_attributes (_("Task"), cell_renderer, "task", 0);

            tree.append_column (title_column);

            stack.transition_type = SLIDE_LEFT;

            initialize_stack ();

            tasks.tree.row_deleted.connect (path => {
                stack.remove (stack.get_child_by_name (path.to_string ()));
            });

            tasks.tree.row_changed.connect ((path, iter) => {
                unowned GTD.Task task;
                tasks.tree.@get (iter, 0, out task);
                if (stack.get_child_by_name (path.to_string ()) == null) {
                    var view = new TaskDetails (task);
                    stack.add_named (view, path.to_string ());
                }
            });

            tree.row_activated.connect ((path, column) => stack.visible_child_name = path.to_string ());

            new_task_button.clicked.connect (() => {
                tasks.add_task (new GTD.Task () { title = "TODO" }); // TODO
            });

            pack1 (tree, true, false);
            pack2 (stack, true, true);
        }
    }
}
