namespace GTD {
    public class App : Gtk.Application {
        public Settings settings;

        construct {
            application_id = "com.github.overlisted.getting-things-done";
            flags = ApplicationFlags.FLAGS_NONE;
            settings = new Settings (application_id);
        }

        protected override void activate () {
            var window = new GTD.Window (this);
            window.show_all ();
        }
    }
}
