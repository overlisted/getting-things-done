project('com.github.overlisted.getting-things-done', 'vala', 'c')

gnome = import('gnome')
i18n = import('i18n')
add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format (meson.project_name()), language:'c')

resources = gnome.compile_resources(
    'gresource',
    join_paths('data', 'gresource.xml'),
    source_dir: 'data'
)

sources = [
    'src/main.vala',
    'src/Application.vala',
    'src/model/Task.vala',
    'src/model/TasksModel.vala',
    'src/view/Window.vala',
    'src/view/MainLayout.vala',
    'src/view/TaskDetails.vala',
    'src/view/CellRendererTask.vala',
    'src/view/NewTaskDialog.vala',
    'src/view/PlaceholderPage.vala',
    'src/view/RightHeader.vala',
]

executable(
    meson.project_name(),
    resources + sources,
    dependencies: [
        dependency('gtk+-3.0'),
        dependency('granite', version: '>=0.5'),
        dependency('libhandy-1', version: '>=0.90.0'),
        dependency('gee-0.8', version: '>=0.8'),
    ],
    install: true
)

i18n.merge_file(
    input: join_paths('data', 'getting-things-done.desktop.in'),
    output: meson.project_name() + '.desktop',
    po_dir: join_paths(meson.source_root(), 'po'),
    type: 'desktop',
    install: true,
    install_dir: join_paths(get_option('datadir'), 'applications')
)

i18n.merge_file(
    input: join_paths('data', 'getting-things-done.appdata.xml.in'),
    output: meson.project_name() + '.appdata.xml',
    po_dir: join_paths(meson.source_root(), 'po'),
    install: true,
    install_dir: join_paths(get_option('datadir'), 'metainfo')
)

subdir('po')

meson.add_install_script('meson/post_install.py')
subdir('data')
