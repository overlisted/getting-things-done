namespace GTD {
    public class TaskDetails : Gtk.Box {
        unowned GTD.Task task;

        public TaskDetails (GTD.Task task) {
            Object (orientation: Gtk.Orientation.VERTICAL);
            this.task = task;

            var label = new Gtk.Label (task.title);
            label.selectable = true;
            label.get_style_context ().add_class (Granite.STYLE_CLASS_H1_LABEL);
            label.xalign = 0;
            label.ellipsize = Pango.EllipsizeMode.END;

            var text = new Gtk.Label (task.notes);
            text.selectable = true;
            text.wrap = true;
            text.xalign = 0;
            text.yalign = 0;

            if (text.label == "") {
                text.label = _("No notes");
                text.get_style_context ().add_class (Gtk.STYLE_CLASS_DIM_LABEL);
            }

            var scrolled = new Gtk.ScrolledWindow (null, null);
            scrolled.hscrollbar_policy = Gtk.PolicyType.NEVER;
            scrolled.add (text);

            var add_subtask_button = new Gtk.Button () {
                image = new Gtk.Image.from_icon_name ("list-add", LARGE_TOOLBAR),
                tooltip_text = _("Add a subtask")
            };

            add_subtask_button.clicked.connect (() => {
                new NewTaskDialog (task);
            });

            var content = new Gtk.Box (Gtk.Orientation.VERTICAL, 6);
            content.margin = 12;
            content.margin_top = 0;
            content.pack_start (label, false);
            content.pack_end (scrolled);

            var header = new Hdy.HeaderBar () {
                decoration_layout = ":maximize",
                show_close_button = true
            };

            unowned Gtk.StyleContext header_context = header.get_style_context ();
            header_context.add_class (Granite.STYLE_CLASS_DEFAULT_DECORATION);
            header_context.add_class (Gtk.STYLE_CLASS_FLAT);

            header.pack_end (add_subtask_button);

            pack_start (header, false);
            pack_end (content);

            show_all ();
        }
    }
}
