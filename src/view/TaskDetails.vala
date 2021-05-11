namespace GTD {
    public class TaskDetails : Gtk.Box {
        unowned GTD.Task task;
        Gtk.Label dates;

        void rebuild_dates_text () {
            var dates_text = new StringBuilder ();

            /// TRANSLATORS: examples of %s: "Yesterday", "2 years ago"
            dates_text.append (_("Started <b>%s</b>").printf (Granite.DateTime.get_relative_datetime (task.started)));

            if (task.deadline != null) {
                dates_text.append (" – ");
                if (task.is_finished) {
                    dates_text.append (_("Was due <b>%s</b>").printf (format_due_date (task.deadline)));
                } else {
                    dates_text.append (_("Due <b>%s</b>").printf (format_due_date (task.deadline)));
                }
            }

            if (task.is_finished) {
                dates_text.append (" – ");
                dates_text.append (_("Finished <b>%s</b>")
                    .printf (Granite.DateTime.get_relative_datetime (task.finished_on)));
            }

            dates.label = (string) dates_text.data;
        }

        public TaskDetails (GTD.Task task) {
            Object (orientation: Gtk.Orientation.VERTICAL);
            this.task = task;

            var label = new Gtk.Label (null) {
                selectable = true,
                xalign = 0,
                ellipsize = Pango.EllipsizeMode.END
            };

            task.bind_property ("title", label, "label", SYNC_CREATE);

            label.get_style_context ().add_class (Granite.STYLE_CLASS_H1_LABEL);

            dates = new Gtk.Label ("") {
                xalign = 0,
                use_markup = true
            };

            rebuild_dates_text ();
            task.notify.connect (() => rebuild_dates_text ());
            Timeout.add_seconds (1, () => {
                var visible = ((Gtk.Stack) parent).visible_child == this;

                if (visible) rebuild_dates_text ();

                return true;
            });

            var text = new Gtk.Label (null) {
                selectable = true,
                wrap = true,
                xalign = 0,
                yalign = 0
            };

            var no_notes = _("No notes");

            task.bind_property ("notes", text, "label", SYNC_CREATE, (_, source, ref target) => {
                if (source == "") {
                    target.set_string (no_notes);
                    text.get_style_context ().add_class (Gtk.STYLE_CLASS_DIM_LABEL);
                } else {
                    target.set_string ((string) source);
                    text.get_style_context ().remove_class (Gtk.STYLE_CLASS_DIM_LABEL);
                }

                return true;
            });

            var scrolled = new Gtk.ScrolledWindow (null, null) {
                hscrollbar_policy = Gtk.PolicyType.NEVER
            };

            scrolled.add (text);

            var add_subtask_button = new Gtk.Button .with_label (_("Add a subtask"));

            add_subtask_button.clicked.connect (() => {
                new EditTaskDialog.add_task (task);
            });

            var finish_task_button = new Gtk.Button.with_label (
                task.is_finished ? _("Mark as unfinished") : _("Finish task")
            );

            finish_task_button.clicked.connect (() => {
                task.is_finished = !task.is_finished;
                finish_task_button.label = task.is_finished ? _("Mark as unfinished") : _("Finish task");
            });

            var delete_task_button = new Gtk.Button.with_label (_("Delete task"));

            delete_task_button.clicked.connect (() => {
                task.@delete ();
            });

            delete_task_button.get_style_context ().add_class (Gtk.STYLE_CLASS_DESTRUCTIVE_ACTION);

            var edit_button = new Gtk.Button.with_label (_("Edit task"));

            edit_button.clicked.connect (() => {
                new EditTaskDialog (task);
            });

            var content = new Gtk.Box (Gtk.Orientation.VERTICAL, 6) {
                margin = 12,
                margin_top = 0
            };

            content.pack_start (label, false);
            content.pack_start (dates, false);
            content.pack_end (scrolled);

            var header = new RightHeader ();

            header.pack_start (add_subtask_button);
            header.pack_start (finish_task_button);
            header.pack_start (delete_task_button);
            header.pack_start (edit_button);

            pack_start (header, false);
            pack_end (content);

            show_all ();
        }
    }
}
