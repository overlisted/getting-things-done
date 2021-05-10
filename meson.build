project('com.github.overlisted.getting-things-done', 'vala', 'c')

gnome = import('gnome')
i18n = import('i18n')

add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name()), language: 'c')

subdir('data')
subdir('src')
subdir('po')

meson.add_install_script('meson/post_install.py')
