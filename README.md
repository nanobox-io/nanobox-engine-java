# Java

This is a generic Java engine used to launch [Nanobox](http://nanobox.io).

##### NOTE: This Engine is a Work in Progress
If you're interested in helping to complete this engine, answers to the questions in [this issue](https://github.com/nanobox-io/nanobox-engine-java/issues/5) would be great.*

## App Detection
To detect a Java app, this engine checks for the presence of `pom.xml`.


## Basic Configuration Options

This engine exposes configuration options through the [Boxfile](http://docs.nanobox.io/boxfile/), a yaml config file used to provision and configure your app's infrastructure when using Nanobox. 


#### Overview of Basic Boxfile Configuration Options

```yaml
build:
  # Java Settings
  java_runtime: openjdk8
```

---

### Java Settings
The following setting allows you to define your Java runtime environment.

---

#### java_runtime
Specifies which Java runtime and version to use. The following runtimes are available:

- openjdk7
- openjdk8 *default*
- sun-jdk6
- sun-jdk7
- sun-jdk8

```yaml
build:
  java_runtime: openjdk8
```

---

## Help & Support
This is a generic (non-framework-specific) Java engine provided by [Nanobox](http://nanobox.io). If you need help with this engine, you can reach out to us in the [#nanobox IRC channel](http://webchat.freenode.net/?channels=nanobox). If you are running into an issue with the engine, feel free to [create a new issue on this project](https://github.com/nanobox-io/nanobox-engine-java/issues/new).