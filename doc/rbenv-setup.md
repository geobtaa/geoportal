# Rbenv setup for swadm shared usage

Install rbenv and the ruby-build plugin from Git:
```
git clone https://github.com/rbenv/rbenv.git /swadm/usr/local/rbenv

# Ruby-build subsystem
git clone https://github.com/rbenv/ruby-build.git /swadm/usr/local/rbenv/plugins/ruby-build

# Add to path and bootstrap command in (for swadm shell usage)
# rbenv may act strangely in particular using ruby-build if it isn't in the homedir
ln -s /swadm/usr/local/rbenv /home/swadm/.rbenv
echo 'export PATH="/swadm/usr/local/rbenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile

# Source the profile file to load this environment in the current shell.

# Install ruby, set it as default
rbenv install 2.3.0
rbenv global 2.3.0
```

