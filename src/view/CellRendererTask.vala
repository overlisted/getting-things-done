namespace GTD {
    public class CellRendererTask : Gtk.CellRendererText {
        private static Gdk.RGBA color_unfinished = { red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0 };
        private static Gdk.RGBA color_overdue = { red: 1.0, green: 0.7, blue: 0.7, alpha: 1.0 };
        private static Gdk.RGBA color_done_too_late = { red: 0.8, green: 0.5, blue: 0.2, alpha: 1.0 };

        public GTD.Task task { get; set; }

        construct {
            ellipsize = Pango.EllipsizeMode.END;
            notify["task"].connect (() => {
                text = task.title;

                foreground_set = false;
                strikethrough_set = false;
                switch (task.state) {
                    case UNFINISHED: {
                        foreground_rgba = color_unfinished;
                        break;
                    }
                    case DONE: {
                        strikethrough = true;
                        break;
                    }
                    case OVERDUE: {
                        foreground_rgba = color_overdue;
                        break;
                    }
                    case DONE_TOO_LATE: {
                        foreground_rgba = color_done_too_late;
                        break;
                    }
                }
            });
        }
    }
}
