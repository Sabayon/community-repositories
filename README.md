# Community Repositories

[![Join the chat at https://gitter.im/Sabayon/community-repositories](https://badges.gitter.im/Sabayon/community-repositories.svg)](https://gitter.im/Sabayon/community-repositories?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Here are defined the repositories specfile that are being built by the builder machine.

## Folder structure of a repository

The directory structure represent the building specfile required to compile the repository.

`

    my-testing-repo/local_overlay/
    my-testing-repo/specs/
    my-testing-repo/build.sh
    my-testing-repo/clean.sh
`

* my-testing-repo/build.sh -- It's the Build spec that defines what to compile and how. Probably this is the only file you will need
* my-testing-repo/local_overlay/ -- is the location of your the local overlay (if necessary)
* my-testing-repo/specs -- Create it to customize the building process. It can contain custom files for make.conf, uses, envs, masks, unmasks and keywords for package compilation options
* my-testing-repo/clean.sh -- Cleanup cruft that is scheduled, you can stick with defaults.

the `specs` folder is structured like this and it's merely optional.

as long as you create those files they are used:

- custom.unmask: that's the place for custom unmasks
- custom.mask:  contain your custom masks
- custom.use:  contain your custom use flags
- custom.env:  contain your custom env specifications
- custom.keywords: contain your custom keywords
- make.conf:  it will replace the make.conf on the container with the provided one.


## Package requests or Repository requests

This machine is meant for building packages for Sabayon Linux distribution. The server is supported by the University of Brescia and is available to all Trusted Users and Developers on request.

It runs Sabayon Linux and packages are built in clean environments using sabayon-devkit.

If you want to have compiled a package that you can find on [layman](https://gpo.zugaina.org/) or you have all the needed ebuilds, open a pull request or raise an issue, as resources allows, we will build and host it.
