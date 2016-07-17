# Community Repositories

[![CircleCI](https://circleci.com/gh/Sabayon/community-repositories.svg?style=svg)](https://circleci.com/gh/Sabayon/community-repositories)[![Join the chat at https://gitter.im/Sabayon/community-repositories](https://badges.gitter.im/Sabayon/community-repositories.svg)](https://gitter.im/Sabayon/community-repositories?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Here are defined the repositories specfile that are being built by the builder machine.

## Structure of a repository

Each repository has the following structure:

`

    my-testing-repo/local_overlay/ #OPTIONAL
    my-testing-repo/specs/ # OPTIONAL
    my-testing-repo/build.yaml #REQUIRED
`

* **build.yaml** -- It's the Build spec that defines what to compile and how. Probably this is the only file you will need. ([example build.yaml](https://github.com/Sabayon/community-repositories/blob/master/build-example.yaml))
* **local_overlay/** -- This folder is the local overlay (if necessary, otherwise if you already have a gentoo overlay, you can specify [the git url](https://github.com/Sabayon/community-repositories/blob/master/build-example.yaml#L82)
* **specs/** -- Create this folder to customize the building process. It can contain custom files for make.conf, uses, envs, masks, unmasks and keywords for package compilation options

the `specs` folder is structured like this and it's merely optional.

as long as you create those files they are used:

- **custom.unmask**: that's the place for custom unmasks
- **custom.mask**:  contain your custom masks
- **custom.use**:  contain your custom use flags
- **custom.env**:  contain your custom env specifications
- **custom.keywords**: contain your custom keywords
- **make.conf**:  it will replace the make.conf on the container with the provided one.


## Package requests or Repository requests

This machine is meant for building packages for Sabayon Linux distribution. The server is supported by the University of Brescia and is available to all Trusted Users and Developers on request.

It runs Sabayon Linux and packages are built in clean environments using sabayon-devkit.

If you want to have compiled a package that you can find on [layman](https://gpo.zugaina.org/) or you have all the needed ebuilds, open a pull request or raise an issue, as resources allows, we will build and host it.
