# Rbenv setup for swadm shared usage

Install rbenv and the ruby-build plugin from Git:
```
git clone https://github.com/rbenv/rbenv.git /swadm/usr/local/rbenv

# Ruby-build subsystem
git clone https://github.com/rbenv/ruby-build.git /swadm/usr/local/rbenv/plugins/ruby-build

# Add to path and bootstrap command in (for swadm shell usage)

ln -s /swadm/usr/local/rbenv /home/swadm/.rbenv
echo 'export RBENV_ROOT=/swadm/usr/local/rbenv' >> ~/.bash_profile
echo 'export PATH="$RBENV_ROOT/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile

# Source the profile file to load this environment in the current shell.

# Install ruby, set it as default
rbenv install 2.3.1
rbenv global 2.3.1
gem install bundler
```

