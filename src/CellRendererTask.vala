namespace GTD {
    public class CellRendererTask : Gtk.CellRendererText {
        GTD.Task _task { get; set; }
        public GTD.Task task {
            get {
                return _task;
            }
            set {
                _task = value;
                text = value.title;
            }
        }
    }
}
