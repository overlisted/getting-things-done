namespace GTD {
    public class TasksView : Gtk.TreeView {
        construct {
            var store = new Gtk.TreeStore (1, typeof (string));

            var title_renderer = new Gtk.CellRendererText ();
            var title_column = new Gtk.TreeViewColumn.with_attributes ("Title", title_renderer, "text", 0);

            append_column(title_column);

            model = store;
            
            Gtk.TreeIter top;
            store.append (out top, null);
            store.@set (top, 0, "A huge task");

            Gtk.TreeIter iter;
            store.append (out iter, top);
            store.@set (iter, 0, "A little step");

            store.append (out iter, top);
            store.@set (iter, 0, "Another little step and we're done");
        }
    }
}
