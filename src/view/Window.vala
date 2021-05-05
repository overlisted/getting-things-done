namespace GTD {
    public class Window : Gtk.ApplicationWindow {
        static construct {
            Hdy.init ();
        }

        construct {
            title = "Getting Things Done";
            default_width = 640;
            default_height = 480;

            get_style_context ().add_class (Granite.STYLE_CLASS_ROUNDED);

            var header = new Hdy.HeaderBar () {
                has_subtitle = false,
                decoration_layout = "close:maximize",
                show_close_button = true,
                title = "Getting Things Done"
            };

            var new_task_button = new Gtk.Button () {
                image = new Gtk.Image.from_icon_name ("list-add", LARGE_TOOLBAR),
                tooltip_text = "New task"
            };

            header.pack_start (new_task_button);

            unowned Gtk.StyleContext header_context = header.get_style_context ();
            header_context.add_class (Granite.STYLE_CLASS_DEFAULT_DECORATION);
            header_context.add_class (Gtk.STYLE_CLASS_FLAT);

            set_titlebar (header);

            var example_task = new GTD.Task () { title = "A huge task" };
            example_task.add_subtask (new GTD.Task () { title = "A smaller task", deadline = new DateTime.now_utc ().add_hours (-1) });
            example_task.add_subtask (new GTD.Task () { title = "Another small task and we're already done!", finished_on = new DateTime.now_utc ().add_hours (-1) });

            var tasks_model = new TasksModel ();
            tasks_model.add_task (example_task);

            add (new TasksView (tasks_model, new_task_button));
        }

        public Window (App app) {
            Object (application: app);
        }
    }
}
