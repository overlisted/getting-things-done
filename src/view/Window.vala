namespace GTD {
    public class Window : Hdy.ApplicationWindow {
        static construct {
            Hdy.init ();
        }

        public Window (App app) {
            Object (application: app, title: "Getting Things Done", default_width: 1280, default_height: 720);

            get_style_context ().add_class (Granite.STYLE_CLASS_ROUNDED);

            add (new MainLayout (app.tasks));
        }
    }
}
