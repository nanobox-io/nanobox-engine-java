# Java

This is a Java engine used to launch Java apps on [Nanobox](http://nanobox.io).

## Usage
To use the Java engine, specify `java` as your `engine` in your boxfile.yml

```yaml
code.build:
  engine: java
```

## Basic Configuration Options
This engine exposes configuration options through the [boxfile.yml](http://docs.nanobox.io/app-config/boxfile/), a yaml config file used to provision and configure your app's infrastructure when using Nanobox.


#### Overview of Basic Boxfile Configuration Options

```yaml
code.build:
  config:
    # Java Settings
    runtime: openjdk8
```

---

### Java Settings
The following setting allows you to define your Java runtime environment.

---

#### runtime
Specifies which Java runtime and version to use. The following runtimes are available:

- openjdk7
- openjdk8 *(default)*
- oraclejdk8
- sun-jdk6
- sun-jdk7
- sun-jdk8

```yaml
code.build:
  config:
    runtime: openjdk8
```

---

## Help & Support
This is a generic (non-framework-specific) Java engine provided by [Nanobox](http://nanobox.io). If you need help with this engine, you can reach out to us in the [#nanobox IRC channel](http://webchat.freenode.net/?channels=nanobox). If you are running into an issue with the engine, feel free to [create a new issue on this project](https://github.com/nanobox-io/nanobox-engine-java/issues/new).
