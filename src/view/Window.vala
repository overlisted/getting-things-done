namespace GTD {
    public class Window : Hdy.ApplicationWindow {
        static construct {
            Hdy.init ();
        }

        construct {
            title = "Getting Things Done";
            default_width = 1280;
            default_height = 720;

            get_style_context ().add_class (Granite.STYLE_CLASS_ROUNDED);

            var example_task = new GTD.Task () { title = "A huge task" };
            example_task.add_subtask (new GTD.Task () { title = "A smaller task", deadline = new DateTime.now_utc ().add_hours (-1) });
            example_task.add_subtask (new GTD.Task () { title = "Another small task and we're already done!", finished_on = new DateTime.now_utc ().add_hours (-1) });

            var tasks_model = new TasksModel ();
            tasks_model.add_task (example_task);

            add (new MainLayout (tasks_model));
        }

        public Window (App app) {
            Object (application: app);
        }
    }
}
