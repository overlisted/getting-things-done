namespace GTD {
    public class CellRendererTask : Gtk.CellRendererText {
        private static Gdk.RGBA COLOR_UNFINISHED = { red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0 };
        private static Gdk.RGBA COLOR_OVERDUE = { red: 1.0, green: 0.7, blue: 0.7, alpha: 1.0 };
        private static Gdk.RGBA COLOR_DONE_TOO_LATE = { red: 0.8, green: 0.5, blue: 0.2, alpha: 1.0 };

        public GTD.Task task { get; set; }

        construct {
            notify["task"].connect(() => {
                text = task.title;

                background_set = false;
                strikethrough_set = false;
                switch (task.state) {
                    case UNFINISHED: {
                        background_rgba = COLOR_UNFINISHED;
                        break;
                    }
                    case DONE: {
                        strikethrough = true;
                        break;
                    }
                    case OVERDUE: {
                        background_rgba = COLOR_OVERDUE;
                        break;
                    }
                    case DONE_TOO_LATE: {
                        background_rgba = COLOR_DONE_TOO_LATE;
                        break;
                    }
                }
            });
        }
    }
}
