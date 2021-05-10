namespace GTD {
    public class App : Gtk.Application {
        public Settings settings;

        construct {
            application_id = "com.github.overlisted.getting-things-done";
            flags = ApplicationFlags.FLAGS_NONE;
            settings = new Settings (application_id);
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

            var window = new GTD.Window (this);
            window.show_all ();
        }
    }
}
