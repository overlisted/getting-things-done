namespace GTD {
    public class App : Gtk.Application {
        public Settings settings;
        public TasksModel tasks;

        bool with_dialog = false;

        construct {
            application_id = "com.github.overlisted.getting-things-done";
            flags = ApplicationFlags.FLAGS_NONE;
            settings = new Settings (application_id);

            add_main_option ("new-task", '\0', 0, 0, "Open the \"New Task\" dialog", null);
        }

        protected override int handle_local_options (VariantDict options) {
            if (options.contains ("new-task")) with_dialog = true;

            return -1;
        }

        protected override void activate () {
            var gtk_settings = Gtk.Settings.get_default ();
            if (!gtk_settings.gtk_theme_name.has_prefix ("io.elementary")) {
                gtk_settings.gtk_theme_name = "io.elementary.stylesheet.lime";
            }
            gtk_settings.gtk_icon_theme_name = "elementary";
            gtk_settings.gtk_cursor_theme_name = "elementary";

            var provider = new Gtk.CssProvider ();
            provider.load_from_resource ("/com/github/overlisted/getting-things-done/overrides.css");
            Gtk.StyleContext.add_provider_for_screen (
                Gdk.Screen.get_default (), provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
            );

            var example_task = new GTD.Task () { title = "A huge task", notes = "This one seems too hard, maybe it can be split up?" };
            var subtask1 = new GTD.Task () { title = "A smaller task", notes = "", deadline = new DateTime.now_utc ().add_hours (-1) };
            var subtask2 = new GTD.Task () { title = "Another small task and we're already done!", notes = "", finished_on = new DateTime.now_utc ().add_hours (-1), notes = "There is a few ways you could do this. \n1. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum." };

            tasks = new TasksModel ();
            tasks.root_task.add_subtask (example_task);
            example_task.add_subtask (subtask1);
            example_task.add_subtask (subtask2);

            var window = new GTD.Window (this);
            window.show_all ();
            if (with_dialog) new NewTaskDialog (tasks.root_task);
        }
    }
}
