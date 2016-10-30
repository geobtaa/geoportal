# Deployment with Capistrano

Deploying Geoblacklight with Capistrano is fairly conventional, but may expect
rbenv in the local development environment (from which you are deploying).

On the target server, your SSH key must be added to swadm's
`/home/swadm/.ssh/authorized_keys` for a successful deployment as `swadm`.
Although it is possible to deploy as a regular non-swadm user because
permissions and ownership are appropriately modified during the deploy, it
results in the user's crontab being setup for nightly tasks rather than swadm's
crontab. See [rbenv-setup.md](rbenv-setup.md) for information on adding the
appropriate directives into `$HOME/.bash_profile` for the swadm user.

Provided your SSH keys are functional, and SSH agent forwarding is correctly
configured, the transaction from your development workstation to the deployment
target to GitHub should be seamless, requiring only:

```shell
$ bundle install
$ bundle exec cap [development|production] deploy
```

Capistrano will prompt you to select a release tag for deployment. The default
choice is the last listed tag (which should be the latest version according to
semantic versioning schemes). Enter a tag to continue deployment.

```
Please enter release tag or branch:
 1.0.0
 1.0.1
  (1.0.1):
```

Note: Instead of a tag, you may specify a Git _branch_ such as `master` or
`develop`.

This prompt can be circumvented by providing the `GEOBLACKLIGHT_RELEASE`
environment variable:

```shell
$ GEOBLACKLIGHT_RELEASE=1.0.1 bundle exec cap development deploy
```

