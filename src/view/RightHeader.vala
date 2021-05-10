namespace GTD {
    public class RightHeader : Hdy.HeaderBar {
        public RightHeader () {
            Object (decoration_layout: ":maximize", show_close_button: true);

            get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
        }
    }
}
