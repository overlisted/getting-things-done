namespace GTD {
    public string format_due_date (DateTime date) {
        switch (date.difference (new DateTime.now ()) / TimeSpan.DAY) {
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
            case 7:
            case -7:
            case -6:
            case -5:
            case -4:
            case -3:
            case -2: {
                return date.format ("%A");
            }
            case -1: {
                return date.format (_("Yesterday %R"));
            }
            case 0: {
                return date.format (_("%R"));
            }
            case 1: {
                return date.format (_("Tomorrow %R"));
            }
            default: {
                return date.format ("%x");
            }
        }
    }
}
