# rancher2-kubedb

[![GitHub stars](https://img.shields.io/github/stars/codejamninja/rancher2-kubedb.svg?style=social&label=Stars)](https://github.com/codejamninja/rancher2-kubedb)

> rancher 2 helm charts for kubernetes kubedb production databases

Please ★ this repo if you found it useful ★ ★ ★


## Features

* supports mysql
* supports mongodb
* supports postgres
* supports redis
* supports elasticsearch


## Installation

1. Run the following from the rancher kubectl shell

```sh
curl -fsSL https://raw.githubusercontent.com/kubedb/cli/0.12.0/hack/deploy/kubedb.sh | bash
```

2. Add the following catalog

| Name   | Catalog URL                                         | Branch |
| ------ | --------------------------------------------------- | ------ |
| kubedb | https://github.com/codejamninja/rancher2-kubedb.git | master |


## Dependencies

* [KubeDB](https://kubedb.com)
* [Kubernetes](https://kubernetes.io)


## Usage

1. Navigate to `YOUR-PROJECT` -> `Apps` -> `Launch`

2. Filter the apps by the `kubedb` catalog

3. Select `View Details` on a database of your choice

4. Fill in the requested information

5. Select `Launch`


## Support

Submit an [issue](https://github.com/codejamninja/rancher2-kubedb/issues/new)


## Screenshots

![FireShot Capture 001 - Rancher - orch siliconhills co](https://user-images.githubusercontent.com/6234038/62327676-d7bae080-b476-11e9-987d-f84461503bdd.png)


## Contributing

Review the [guidelines for contributing](https://github.com/codejamninja/rancher2-kubedb/blob/master/CONTRIBUTING.md)


## License

[MIT License](https://github.com/codejamninja/rancher2-kubedb/blob/master/LICENSE)

[Jam Risser](https://codejam.ninja) © 2019


## Changelog

Review the [changelog](https://github.com/codejamninja/rancher2-kubedb/blob/master/CHANGELOG.md)


## Credits

* [Jam Risser](https://codejam.ninja) - Author


## Support on Liberapay

A ridiculous amount of coffee ☕ ☕ ☕ was consumed in the process of building this project.

[Add some fuel](https://liberapay.com/codejamninja/donate) if you'd like to keep me going!

[![Liberapay receiving](https://img.shields.io/liberapay/receives/codejamninja.svg?style=flat-square)](https://liberapay.com/codejamninja/donate)
[![Liberapay patrons](https://img.shields.io/liberapay/patrons/codejamninja.svg?style=flat-square)](https://liberapay.com/codejamninja/donate)
