namespace GTD {
    public class TaskDetails : Gtk.Box {
        GTD.Task task;

        public TaskDetails (GTD.Task task) {
            Object (orientation: Gtk.Orientation.HORIZONTAL, spacing: 6);
            this.task = task;

            var label = new Gtk.Label (task.title);
            label.get_style_context ().add_class (".title");

            add (label);
        }
    }
}
