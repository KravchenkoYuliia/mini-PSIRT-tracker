## CVE
**Common Vulnerabilities and Exposures**

It is a free, publicly available catalog and standardized naming system that tracks known cybersecurity flaws in software, hardware, and firmware.

## CVSS
**Common Vulnerability Scoring System**

It is an open, standardized framework used to measure and rate the severity of security vulnerabilities in software and computer systems.

## SpringBoot

It is a framework that simplifies backend Java development: API creation, webserver configuration and database connectivity.  
StringBoot launchs HTTP-server, receives requests and returns a response.

## Maven

It is a tool that manages dependencies (install the libraries) and build the project.  
Apache Maven is a software project management and comprehension tool. Based on the concept of a project object model (POM), Maven can manage a project's build, reporting and documentation from a central piece of information.  

## POM

It is a file from which `Maven` reads the project settings and the list of dependencies (libraries to install).  
A Project Object Model or POM is the fundamental unit of work in Maven. It is an XML file that contains information about the project and configuration details used by Maven to build the project. It contains default values for most projects. Examples for this is the build directory, which is target; the source directory, which is src/main/java; the test source directory, which is src/test/java; and so on. When executing a task or goal, Maven looks for the POM in the current directory. It reads the POM, gets the needed configuration information, then executes the goal.

Some of the configuration that can be specified in the POM are the project dependencies, the plugins or goals that can be executed, the build profiles, and so on. Other information such as the project version, description, developers, mailing lists and such can also be specified.

### Commands

delete volume:  
```docker compose down -v```  
or  
```docker volume rm```  