namespace GTD {
    public class App : Gtk.Application {
        construct {
            application_id = "com.github.overlisted.getting-things-done";
            flags = ApplicationFlags.FLAGS_NONE;
        }

        protected override void activate () {
            var window = new GTD.Window (this);
            window.show_all ();
        }
    }
}
