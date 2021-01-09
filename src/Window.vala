namespace GTD {
    public class Window : Gtk.ApplicationWindow {
        static construct {
            Hdy.init ();
        }

        construct {
            title = "Getting Things Done";

            var header = new Hdy.HeaderBar () {
                has_subtitle = false,
                decoration_layout = "close:maximize",
                show_close_button = true,
                title = "Getting Things Done"
            };

            unowned Gtk.StyleContext header_context = header.get_style_context ();
            header_context.add_class ("default-decoration");
            header_context.add_class (Gtk.STYLE_CLASS_FLAT);

            set_titlebar (header);

            var example_task = new GTD.Task () { title = "A huge task" };
            example_task.add_subtask (new GTD.Task () { title = "A smaller task", deadline = new DateTime.now_utc ().add_hours(-1) });
            example_task.add_subtask (new GTD.Task () { title = "Another small task and we're already done!", finished_on = new DateTime.now_utc ().add_hours(-1) });

            var tasks_model = new TasksModel ();
            tasks_model.add_task (example_task);

            add (new TasksView (tasks_model));
        }

        public Window (App app) {
            Object (application: app);
        }
    }
}
