namespace GTD {
    public class MainLayout : Gtk.Paned {
        TasksModel model;
        Gtk.TreeView tree;
        Gtk.Stack stack;
        Gtk.TreeViewColumn title_column;

        void initialize_stack () {
            var model_paths = new Gee.ArrayList<Gtk.TreePath> ();
            var model_tasks = new Gee.ArrayList<GTD.Task> ();

            model.@foreach ((model, path, it) => {
                model_paths.add (path);
                return false;
            });

            model.root_task.foreach_rec (it => model_tasks.add (it));

            for (int i = 0; i < model_paths.size; i++) {
                stack.add_named (new TaskDetails (model_tasks[i]), model_paths[i].to_string ());
            }
        }

        public MainLayout (TasksModel model) {
            Object (orientation: Gtk.Orientation.HORIZONTAL);

            var settings = new Settings ("com.github.overlisted.getting-things-done");
            settings.bind ("paned-position", this, "position", DEFAULT);

            var left_header = new Hdy.HeaderBar () {
                decoration_layout = "close:",
                show_close_button = true
            };

            var new_task_button = new Gtk.Button () {
                image = new Gtk.Image.from_icon_name ("list-add", LARGE_TOOLBAR),
                tooltip_text = _("New task")
            };

            left_header.pack_start (new_task_button);

            unowned Gtk.StyleContext left_header_context = left_header.get_style_context ();
            left_header_context.add_class (Gtk.STYLE_CLASS_FLAT);

            this.model = model;
            this.tree = new Gtk.TreeView.with_model (model) {
                headers_visible = false,
                activate_on_single_click = true
            };

            tree.expand_all ();

            this.stack = new Gtk.Stack () {
                homogeneous = false
            };

            var cell_renderer = new CellRendererTask ();
            title_column = new Gtk.TreeViewColumn.with_attributes (_("Task"), cell_renderer, "task", 0);

            tree.append_column (title_column);

            initialize_stack ();

            model.row_inserted.connect ((path, iter) => {
                stack.add_named (new TaskDetails (model.iter_to_task (iter)), path.to_string ());
            });

            model.row_has_child_toggled.connect (path => {
                tree.expand_row (path, true);
            });

            model.row_deleted.connect (path => {
                stack.remove (stack.get_child_by_name (path.to_string ()));
            });

            tree.row_activated.connect ((path, column) => stack.visible_child_name = path.to_string ());

            new_task_button.clicked.connect (() => {
                new NewTaskDialog (model.root_task);
            });

            var left = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            left.add (left_header);
            left.add (tree);
            left.get_style_context ().add_class (Gtk.STYLE_CLASS_SIDEBAR);

            pack1 (left, true, false);
            pack2 (stack, true, true);
        }
    }
}
