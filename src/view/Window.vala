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

            var example_task = new GTD.Task () { title = "A huge task", notes = "This one seems too hard, maybe it can be split up?" };
            var subtask1 = new GTD.Task () { title = "A smaller task", notes = "", deadline = new DateTime.now_utc ().add_hours (-1) };
            var subtask2 = new GTD.Task () { title = "Another small task and we're already done!", notes = "", finished_on = new DateTime.now_utc ().add_hours (-1), notes = "There is a few ways you could do this. \n1. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum." };

            var tasks_model = new TasksModel ();
            tasks_model.root_task.add_subtask (example_task);
            example_task.add_subtask (subtask1);
            example_task.add_subtask (subtask2);

            add (new MainLayout (tasks_model));
        }

        public Window (App app) {
            Object (application: app);
        }
    }
}
