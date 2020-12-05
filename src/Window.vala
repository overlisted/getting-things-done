namespace GTD {
    public class Window : Gtk.ApplicationWindow {
        static construct {
            Hdy.init ();
        }

        construct {
            title = "Getting Things Done";

            var header = new Hdy.HeaderBar ();
            header.has_subtitle = false;
            header.decoration_layout = "close:maximize";
            header.show_close_button = true;

            unowned Gtk.StyleContext header_context = header.get_style_context ();
            header_context.add_class ("default-decoration");
            header_context.add_class (Gtk.STYLE_CLASS_FLAT);

            var tasks_view = new TasksView ();

            add (tasks_view);
        }

        public Window (App app) {
            Object (application: app);
        }
    }
}