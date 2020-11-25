# Option 1: How to run the server locally

In order to run the server locally, you will need Java installed on your laptop. I have tested it using Java 11 (Released on Sept 2018 and supported until September 2026).

Step 1: Unzip the file `front.zip` using the following command
> unzip front.zip

Step 2: cd into the front directory
> cd front

Stept 3: Build the project. I used gradle (Maven like build tool). The following command builds the code and creates a runnable jar called server.jar (it also runs unit tests)
> ./gradlew clean build shadowJar

Step 4: The runnable jar (shadowJar takes care of packaging the code as well as dependency in an "uber" jar) file is places in `build/libs` directory. Start the server using the following command:
> java -jar build/libs/server.jar

Step 5: After the server is started. Start another terminal window and cd to the same directory as the one in above steps (i.e. front). You can run the end to end (I wrote them using Java) tests using the following command:
> ./gradlew clean e2e

Step 6: You can also run the tests which were provided by Front using the following method:
> cd front-starter-code
> npm install
> npm test

Step 7: Go back t the first terminal and send `Ctrl-C` to the terminate the process.

# Option 2: Running the code using Docker 
I have included a Dockerfile which can be used to create a container which will run the server. 

Step 1: Perform the following command to unzip the contents of the code and change to the directory which was just extracted
> unzip front.zip
> cd front

Step 2: Build the docker image (this may take time). It starts with base image which has jdk installed. Copies the folder and builds the code.
> docker build --tag canvas-server:0.1

Step 3: Run the docker image which we just build in a container. We expose the container's 8124 port
> docker run --publish 8124:8124 canvas-server:1.0

Step 4: From the host run the tests provided by front
> cd front_starter_code
> npm install 
> npm test


# Option 3: How to run the server and tests on cloud instance.

In cases where one does not want to change local machine and prefers to run on a cloud instance. One can follow the following setup. (Note: I used AWS light sail to quickly give me an Ubuntu 20.04 LTS). The following steps assumes the following:

1. You have a cloud instance with Ubuntu 20.04 installed
2. You can ssh into this instance (light sail creates the private/public keys and you can download the keys to your local machine to ssh/scp into this instance)

Step 1: from you local machine ssh into the machine. For example:
> ssh -i ~/.ssh/jatin.pem ubuntu@12.123.12.123

Step 2: On the cloud instance, clone the following git repo (it is my public repo and has a set of scripts which I use to prepare machines). You can do this in your home directory
> git clone https://github.com/jatin146/scripts.git

Step 3: Change to the scripts directory
> cd ~/scripts/shell

Step 3: First step is to install OS updates. This will restart the machine at the end for update to really take effect.
./update.sh

Step 4: Wait for the machine to get restarted. And after the machine has restarted, login again using the same ssh command we used in Step 1:
> ssh -i ~/.ssh/jatin.pem ubuntu@12.123.12.123

Step 5: Lets run a series of scripts which will do the following:
- install apps like unzip, make, curl etc
- install Java (both runtime as well as JDK) v11
- install node and npm (we will install the current LTS)

> cd ~/scripts/shell
> ./install-apps.sh
> ./install-java.sh
> ./install-node.sh
> exit

Step 6: We will now come back to the local machine and scp the zip file containing the code I submitted (which also has the tests which were provided to me by front)
> scp -i ~/.ssh/jatin.pem front.zip ubuntu@12.123.12.123:~

Step 7: We will now open two ssh sessions to the same server and refer to them as term1 and term2. In term1 we will run the server and in term2 we will run end to end tests (both written by me as well as provided by front)

Step 8: In term1 run the server using the following commands:
> ssh -i ~/.ssh/jatin.pem ubuntu@12.123.12.123
> unzip front.zip
> cd front
> ./gradlew clean build shadowJar
> java -jar build/libs/server.jar

Step 9: In term2 run the following command (no need to unzip the file again)
> ssh -i ~/.ssh/jatin.pem ubuntu@12.123.12.123
> cd front
> ./gradlew clean e2e  # run tests written in Java by Jatin
> cd front-starter-code
> npm install
> npm test


# Gotchas

While doing the exercise, I found two places where the spec and the provided tests differ. My guiding principal was to not modify the tests and hence I decided to write the server on a slightly modified spec. Here are the changes in the spec that I notices:

* when sending render responses, the test client expects that each row is separated by \n instead of \r\n. I tested it by generating the box using /n and /r/n and comparing the hashes. 

* As soon as client connects, it expects the server to send "hello". If the server does not send "hello", client does not send commands. After client gets "hello" from server, it sends all the commands. There is a line in ClientHandler which if commented breaks all the tests. 

# Notes on using Java and gradle.
I decided to use Java as it is the language I am most comfortable in. I also decided to use gradle which provides a convention based tooling to package app into a runnable jar, ability to define and run tests.

Gradle also manages dependencies. The server code does not use any external dependencies other than what is provided by the Java JDK. However, the tests pulls in two dependencies:
* JUnit: unit test framework for Java
* common-codec: I used hex sha1 function to validate server responses the same way the front provided tests were doing.

I decided to use a gradle plugin called shadowJar which conveniently creates a jar file with all the dependencies packages into it (makes the jar file size bigger .. but makes dependency management to run the code easier). Steps to build and tun server are: build server into a runnable jar file and run the jar file.

The server uses default configuration like following:
- server listens on port 8124
- all canvases are of size 30x30 and cursor starts at (15,15)
I thought about using command line flags to override these defaults. However decided against it in order to save time as well as control some amount of complexity.

# Code organization
All the server code resides in folder src/main/java

The following section tries to describe what each file is responsible in the structure:

```
app
  |---> App.java (the entry point to the server i.e. main method)
  |---> Server.java (Server class creates the server socket and listens on a port. When a new client connects, creates a thread for the handling the connection and lets ClientHandler take care of the connection)
  |---> ClientHandler.java (client handler contains code which takes commands from the client, maintains the state of the canvas and updates it based on the commands, responds to client with data when asked by render or coord command)
Config
  |---> Config.java (default app configurations are here. Provides methods to override the config. Can be overridden by either command line arguments or property file (not implemented)
Model
  |---> Canvas.java (Each client creates an object of this class. Canvas object contain the actual buffer which store the state. Provide the methods which understand how to change the state by providing methods like clear, right, left, steps which are used by ClientHandler)
  |---> Direction.java (Enum used to define various directions that cursor can move to. Use of enum makes for more readable code)
  |---> Mode.java (enum which defines various modes)
Util
  |---> RenderUtil.java (A utility class which knows how to draw boxes and is used by canvas in rendering itself enclosed in box)
```

General idea is as follows:
We start the server at 8124 port. Whenever a client connects to it, we create a new thread which handles communication with that client while the main thread goes back to listening for further connections. 

Each thread creates the canvas object. The canvas object maintains state of the canvas (what squares are filled and what are not filled, current co-ordinates, current mode). Clienthandler accepts commands from the client and uses those commands to instruct the canvas object to make changes to its state. Whenever the client asks for some response (e.g. coords or render), the Clienthandler asks canvas to provide those answers and passes along to the client. When client sends "quit", the client handler closes the connection. 

Please feel free to read comments in all the above files.

# Unit tests and end to end tests
The tests can be found in src/test/java.

The following folders / packages contain unit tests:
info/jatinshah/front/model
Info/jatinshah/front/util

And the following folders contain end to end tests:
Info/jatinshah/front/e2e

In order to run unit tests, execute the following command:
> ./gradlew clean test

In order to run end to end tests, execute the following command:
> ./gradlew clean e2e

Notes:
- Unit tests are run every time there is a build, to ensure that new changes do not break any tests
- End to end tests expect a server running and listening on port 8124. This can be accomplished by running the command `java -jar build/libs/server.jar` in a different terminal window on the same machine. And then running the end to end tests in another terminal.

I do understand that I have not provided complete coverage. However I wanted to submit the working code before I go on Thanksgiving break. If I have more time, I would love to add mode tests.


	
