# Mix Reorganize

A mix task to reorganise the generated files from phoenix `gen` tasks into domain-style folders.

Instead of having:

- `lib/my_app_web/controllers/user_controller.ex`
- `lib/my_app_web/views/user_view.ex`

It moves them to:

- `lib/my_app_web/user/controller.ex`
- `lib/my_app_web/user/view.ex`

## Status

It works but it is super basic. Lots of room for improvement.

## Support

Developement of this project is supported by [Contact Stack](https://www.contact-stack.com).

