# mirador-download-plugin

[![Travis][build-badge]][build]
[![npm package][npm-badge]][npm]
[![Coveralls][coveralls-badge]][coveralls]

Describe mirador-download-plugin here.

[build-badge]: https://img.shields.io/travis/user/repo/master.png?style=flat-square
[build]: https://travis-ci.org/user/repo

[npm-badge]: https://img.shields.io/npm/v/npm-package.png?style=flat-square
[npm]: https://www.npmjs.org/package/npm-package

[coveralls-badge]: https://img.shields.io/coveralls/user/repo/master.png?style=flat-square
[coveralls]: https://coveralls.io/github/user/repo

## Configuration

Configurations for this plugin are injected when Mirador is initialized under the `miradorDownloadPlugin` key.

```js
...
  id: 'mirador',
  miradorDownloadPlugin: {
    ...
  }
...
```

| Config Key | Type | Description |
| --- | --- | --- |
| `restrictDownloadOnSizeDefinition` | boolean (default: false) | If set to true the `Zoomed region` link will not be rendered if the image API returns a single size in the `sizes` section and the single size height/width is the same size or smaller than the reported height/width. |
