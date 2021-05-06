namespace GTD {
    public class TaskDetails : Gtk.Box {
        unowned GTD.Task task;

        public TaskDetails (GTD.Task task) {
            Object (orientation: Gtk.Orientation.VERTICAL);
            this.task = task;

            var label = new Gtk.Label (task.title);
            label.get_style_context ().add_class (Granite.STYLE_CLASS_H2_LABEL);
            label.xalign = 0;

            var add_subtask_button = new Gtk.Button () {
                image = new Gtk.Image.from_icon_name ("list-add", LARGE_TOOLBAR),
                tooltip_text = _("Add a subtask")
            };

            add_subtask_button.clicked.connect (() => {
                new NewTaskDialog (null, task);
            });

            var content = new Gtk.Box (Gtk.Orientation.VERTICAL, 6);
            content.margin = 6;
            content.margin_top = 0;
            content.add (label);

            var header = new Hdy.HeaderBar () {
                decoration_layout = ":maximize",
                show_close_button = true
            };

            unowned Gtk.StyleContext header_context = header.get_style_context ();
            header_context.add_class (Granite.STYLE_CLASS_DEFAULT_DECORATION);
            header_context.add_class (Gtk.STYLE_CLASS_FLAT);

            header.pack_end (add_subtask_button);

            add (header);
            add (content);

            show_all ();
        }
    }
}
