## Run Project for Local Development

### Bundle
```bash
bundle install
```

### Create Database
```bash
psql postgres
DROP DATABASE geoblacklight_admin_development;
CREATE DATABASE geoblacklight_admin_development;
```

### Run Application
```bash
bundle exec rake geoblacklight:admin:server
```

### Lint App
```bash
standardrb .
standardrb --fix
```

### Test App
```bash
bundle exec rake ci
```

### Build Node Module
Bump the package version in `package.json` and run the following commands to build and publish the node module.

```bash
bundle exec vite build
npm publish
```
