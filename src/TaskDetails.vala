namespace GTD {
    public class TaskDetails {
        public Gtk.Box box;
        GTD.Task task;

        public TaskDetails (GTD.Task task) {
            this.task = task;
            this.box = new Gtk.Box (VERTICAL, 6);

            var label = new Gtk.Label (task.title);
            label.get_style_context ().add_class (".title");

            box.add (label);
        }
    }
}
