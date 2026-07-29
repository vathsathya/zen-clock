#include "my_application.h"
#include <glib.h>
#include <unistd.h>
#include <fcntl.h>

int main(int argc, char** argv) {
  g_setenv("XCURSOR_THEME", "Adwaita", TRUE);
  g_setenv("XCURSOR_PATH", "/usr/share/icons", TRUE);
  g_setenv("AYATANA_APPINDICATOR_NO_WARN", "1", TRUE);

  // Suppress C-library GTK/GDK stderr warning noise when running executable
  int dev_null = open("/dev/null", O_WRONLY);
  if (dev_null != -1) {
    dup2(dev_null, STDERR_FILENO);
    close(dev_null);
  }

  g_autoptr(MyApplication) app = my_application_new();
  return g_application_run(G_APPLICATION(app), argc, argv);
}
