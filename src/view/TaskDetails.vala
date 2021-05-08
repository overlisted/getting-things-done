namespace GTD {
    public class TaskDetails : Gtk.Box {
        unowned GTD.Task task;

        public TaskDetails (GTD.Task task) {
            Object (orientation: Gtk.Orientation.VERTICAL);
            this.task = task;

            var label = new Gtk.Label (task.title) {
                selectable = true,
                xalign = 0,
                ellipsize = Pango.EllipsizeMode.END
            };

            label.get_style_context ().add_class (Granite.STYLE_CLASS_H1_LABEL);

            var text = new Gtk.Label (task.notes) {
                selectable = true,
                wrap = true,
                xalign = 0,
                yalign = 0
            };

            if (text.label == "") {
                text.label = _("No notes");
                text.get_style_context ().add_class (Gtk.STYLE_CLASS_DIM_LABEL);
            };

            var scrolled = new Gtk.ScrolledWindow (null, null) {
                hscrollbar_policy = Gtk.PolicyType.NEVER
            };

            scrolled.add (text);

            var add_subtask_button = new Gtk.Button () {
                image = new Gtk.Image.from_icon_name ("list-add", LARGE_TOOLBAR),
                tooltip_text = _("Add a subtask")
            };

            add_subtask_button.clicked.connect (() => {
                new NewTaskDialog (task);
            });

            var content = new Gtk.Box (Gtk.Orientation.VERTICAL, 6) {
                margin = 12,
                margin_top = 0
            };

            content.pack_start (label, false);
            content.pack_end (scrolled);

            var header = new Hdy.HeaderBar () {
                decoration_layout = ":maximize",
                show_close_button = true
            };

            unowned Gtk.StyleContext header_context = header.get_style_context ();
            header_context.add_class (Gtk.STYLE_CLASS_FLAT);

            header.pack_end (add_subtask_button);

            pack_start (header, false);
            pack_end (content);

            show_all ();
        }
    }
}
