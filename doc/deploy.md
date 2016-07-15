# Deployment with Capistrano

Deploying Geoblacklight with Capistrano is fairly conventional, but may expect
rbenv in the local development environment (from which you are deploying).

On the server, your user profile (assuming deployment takes place as a regular 
user, not `swadm`, which is already setup) needs the rbenv environment to be 
bootstrapped. See [rbenv-setup.md](rbenv-setup.md) for information on adding the 
appropriate directives into `$HOME/.bash_profile`.

Provided your SSH keys are functional, and SSH agent forwarding is correctly 
configured, the transaction from your development workstation to the deployment 
target to GitHub should be seamless, requiring only:

```shell
$ bundle install
$ bundle exec cap [development|production] deploy
```
