namespace GTD {
    public class PlaceholderPage : Gtk.Box {
        public PlaceholderPage (TasksModel model) {
            Object (orientation: Gtk.Orientation.VERTICAL);

            var welcome = new Granite.Widgets.Welcome (_("No Tasks"), _("It's time to start getting things done!"));

            welcome.append ("list-add", _("Create a Task"), _("Make this place feel a bit less empty."));
            welcome.append ("go-first", _("Import Config"), "Not implemented");
            welcome.set_item_sensitivity (1, false);

            welcome.activated.connect (index => {
                switch (index) {
                    case 0: {
                        new EditTaskDialog.add_task (model.root_task);

                        break;
                    }
                    case 1: {
                        // not implemented

                        break;
                    }
                }
            });

            add (new RightHeader ());
            add (welcome);

            show_all ();
        }
    }
}
