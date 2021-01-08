namespace GTD {
    public class TaskDetails : Gtk.Box {
        unowned GTD.Task task;

        public TaskDetails (GTD.Task task) {
            Object (orientation: Gtk.Orientation.HORIZONTAL, spacing: 6);
            this.task = task;

            var label = new Gtk.Label (task.title);
            label.hexpand = true;
            label.get_style_context ().add_class (Granite.STYLE_CLASS_H2_LABEL);

            pack_start (label, false);
        }
    }
}
