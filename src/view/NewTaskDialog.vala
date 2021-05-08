namespace GTD {
    public class NewTaskDialog : Granite.Dialog {
        private DateTime merge_date_and_time (DateTime date, DateTime time) {
            return date
                .add_hours (time.get_hour ())
                .add_minutes (time.get_minute ())
                .add_seconds (time.get_second ());
        }

        public NewTaskDialog (GTD.Task parent_task) {
            Object (resizable: false);

            var title_entry = new Gtk.Entry ();

            var deadline_date_entry = new Granite.Widgets.DatePicker ();
            var deadline_time_entry = new Granite.Widgets.TimePicker ();
            var deadline_switch = new Gtk.Switch ();
            deadline_switch.bind_property ("active", deadline_date_entry, "sensitive", SYNC_CREATE);
            deadline_switch.bind_property ("active", deadline_time_entry, "sensitive", SYNC_CREATE);
            var notes_text = new Gtk.TextView () {
                margin = 3,
                wrap_mode = Gtk.WrapMode.WORD_CHAR
            };

            var notes_scrolled = new Gtk.ScrolledWindow (null, null) {
                hscrollbar_policy = Gtk.PolicyType.NEVER,
                height_request = 100,
                expand = true
            };

            notes_scrolled.add (notes_text);

            var notes_frame = new Gtk.Frame (null);
            notes_frame.add (notes_scrolled);

            var layout = new Gtk.Grid () {
                column_spacing = 12
            };

            layout.attach (new Granite.HeaderLabel (_("Title:")), 0, 1);
            layout.attach (title_entry, 0, 2, 3);
            layout.attach (new Granite.HeaderLabel (_("Deadline:")), 0, 3);
            layout.attach (deadline_switch, 0, 4);
            layout.attach (deadline_date_entry, 1, 4);
            layout.attach (deadline_time_entry, 2, 4);
            layout.attach (new Granite.HeaderLabel (_("Notes:")), 0, 5);
            layout.attach (notes_frame, 0, 6, 3);

            var buttons = new Gtk.ButtonBox (Gtk.Orientation.HORIZONTAL) {
                spacing = 6,
                baseline_position = Gtk.BaselinePosition.CENTER,
                layout_style = Gtk.ButtonBoxStyle.END
            };

            var cancel = new Gtk.Button.with_label (_("Cancel"));
            cancel.clicked.connect (destroy);

            var create = new Gtk.Button.with_label (_("Create Task")) {
                sensitive = false
            };

            create.clicked.connect (() => {
                var task = new GTD.Task () { title = title_entry.text, notes = notes_text.buffer.text };

                if (deadline_switch.active) {
                    task.deadline = merge_date_and_time (deadline_date_entry.date, deadline_time_entry.time);
                }

                parent_task.add_subtask (task);

                destroy ();
            });

            create.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);

            buttons.add (cancel);
            buttons.add (create);

            title_entry.changed.connect (() => {
               create.sensitive = title_entry.text.length > 0;
            });

            var content_area = get_content_area ();
            content_area.margin_start = 12;
            content_area.margin_end = 12;
            content_area.spacing = 12;

            content_area.add (layout);
            content_area.add (buttons);

            show_all ();
        }
    }
}
