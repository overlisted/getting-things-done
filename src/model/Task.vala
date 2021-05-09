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

        public int32 id;
        public string title;
        public string notes;
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
                    if (deadline.compare (finished_on) == -1) {
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

            task.@delete.connect (() => {
                subtasks.remove (task);
            });

            subtask_added (task);
        }

        public void foreach_flat (ForeachFunc f) {
            foreach (var task in subtasks) {
                f (task);
            }
        }

        public void foreach_rec (ForeachFunc f) {
            foreach_rec_step (f, this);
        }

        public signal void subtask_added (Task subtask);
        public signal void @delete ();

        static void foreach_rec_step (ForeachFunc f, Task task) {
            task.foreach_flat (it => {
                f (it);
                foreach_rec_step (f, it);
            });
        }

        construct {
            id = Random.int_range (int32.MIN, int32.MAX);
            started = new DateTime.now_utc ();
            subtasks = new List<Task> ();
        }
    }
}
