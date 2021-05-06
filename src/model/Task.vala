namespace GTD {
    public enum TaskState {
        UNFINISHED,
        DONE,
        OVERDUE,
        DONE_TOO_LATE
    }

    public class Task : Object {
        public delegate void ForeachFunc (GTD.Task task);

        public weak Task? parent; // `weak`: not today, memory leak!

        public string uuid;
        public string title;
        public DateTime started { get; construct; }
        DateTime? _deadline = null;
        public DateTime? deadline {
            get {
                return _deadline;
            }
            set {
                _deadline = value;
                foreach_flat (it => {
                    if (it.deadline.difference (value) < 0) {
                        it.deadline = value;
                    }
                });
            }
        }

        public DateTime? finished_on;
        public bool is_finished {
            get {
                return finished_on != null;
            }
            set {
                if (value) {
                    finished_on = new DateTime.now_utc ();
                } else {
                    finished_on = null;
                }

                foreach_flat (it => {
                    it.is_finished = value;
                });
            }
        }

        public TaskState state {
            get {
                if (is_finished) {
                    if (deadline == null) return DONE;
                    if (finished_on.compare (deadline) == -1) {
                        return DONE_TOO_LATE;
                    } else {
                        return DONE;
                    }
                } else {
                    if (deadline == null) return UNFINISHED;
                    if (deadline.compare (new DateTime.now_utc ()) == -1) {
                        return OVERDUE;
                    } else {
                        return UNFINISHED;
                    }
                }
            }
        }

        public List<Task> subtasks;

        public void add_subtask (owned Task task) {
            subtasks.append (task);
            task.parent = this;
        }

        public void foreach_flat (ForeachFunc f) {
            foreach (var task in subtasks) {
                f (task);
            }
        }

        public void foreach_rec (ForeachFunc f) {
            foreach_rec_step (f, this);
        }

        static void foreach_rec_step (ForeachFunc f, Task task) {
            task.foreach_flat (it => {
                foreach_rec_step (f, it);
                f (it);
            });
        }

        construct {
            uuid = Uuid.string_random ();
            started = new DateTime.now_utc ();
            subtasks = new List<Task> ();
        }
    }
}
