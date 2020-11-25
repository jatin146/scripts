# How to run the server locally

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


# How to run the server and tests on cloud instance.

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
