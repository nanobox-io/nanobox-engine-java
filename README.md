# Java

This is a Java engine used to launch Java apps on [Nanobox](http://nanobox.io).

## Usage
To use the Java engine, specify `java` as your `engine` in your boxfile.yml.

```yaml
code.build:
  engine: java
```

## Build Process
When [running a build](https://docs.nanboox.io/cli/build/), this engine compiles code by doing the following:

- `mvn -B -DskipTests=true clean install`

## Basic Configuration Options
This engine exposes configuration options through the [boxfile.yml](http://docs.nanobox.io/app-config/boxfile/), a yaml config file used to provision and configure your app's infrastructure when using Nanobox.


#### Overview of Basic Boxfile Configuration Options

```yaml
code.build:
  config:
    # Java Settings
    runtime: openjdk8

    # Maven Settings
    maven_version: 3.3

    # Node.js Settings
    nodejs_runtime: nodejs-4.4
```

##### Quick Links
[Java Settings](#java-settings)  
[Maven Settings](#maven-settings)  
[Node.js Settings](#node-js-settings)

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

### Maven Settings
The following setting allows you to configure Maven to your specific needs.

---

#### maven_version
Defines which version of Maven to use. Available versions depend on which version of Java you're using.

##### Java 6
- 3.0
- 3.1
- 3.2

##### Java 7
- 3.0
- 3.1
- 3.2
- 3.3

#### Java 8
- 3.0
- 3.1
- 3.2
- 3.3

```yaml
code.build:
  config:
    maven_version: 3.3
```

---

### Node.js Settings
Many applications utilize Javascript tools in some way. This engine allows you to specify which Node.js runtime you'd like to use.

---

#### nodejs_runtime
Specifies which Node.js runtime and version to use. You can view the available Node.js runtimes in the [Node.js engine documentation](https://github.com/nanobox-io/nanobox-engine-nodejs#runtime).

```yaml
code.build:
  config:
    nodejs_runtime: nodejs-4.4
```

---

## Help & Support
This is a Java engine provided by [Nanobox](http://nanobox.io). If you need help with this engine, you can reach out to us in the [#nanobox IRC channel](http://webchat.freenode.net/?channels=nanobox). If you are running into an issue with the engine, feel free to [create a new issue on this project](https://github.com/nanobox-io/nanobox-engine-java/issues/new).
