sources = [
    'main.vala',
    'Application.vala',
    'date_utils.vala',
    'model/Task.vala',
    'model/TasksModel.vala',
    'view/Window.vala',
    'view/MainLayout.vala',
    'view/TaskDetails.vala',
    'view/CellRendererTask.vala',
    'view/EditTaskDialog.vala',
    'view/PlaceholderPage.vala',
    'view/RightHeader.vala',
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
