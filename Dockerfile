FROM tomcat:8.5

MAINTAINER Mee-Nam.lee mnlee30@gmail.com

RUN apt-get -qq update

# set shell variables for java installation
ENV java_version 1.8.0_11
ENV filename jdk-8u11-linux-x64.tar.gz
ENV downloadlink http://download.oracle.com/otn-pub/java/jdk/8u11-b12/$filename

# download java, accepting the license agreement
RUN wget --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" -O /tmp/$filename $downloadlink 

# unpack java
RUN mkdir /opt/java-oracle && tar -zxf /tmp/$filename -C /opt/java-oracle/
ENV JAVA_HOME /opt/java-oracle/jdk$java_version
ENV PATH $JAVA_HOME/bin:$PATH

# configure symbolic links for the java and javac executables
RUN update-alternatives --install /usr/bin/java java $JAVA_HOME/bin/java 20000 && update-alternatives --install /usr/bin/javac javac $JAVA_HOME/bin/javac 20000

#install maven and git to build project
RUN apt-get install -y wget git-core maven

# Pull project
RUN git clone https://github.com/mee-nam-lee/spring-petclinic.git

# Build project
RUN cd spring-petclinic && mvn package
RUN mv /spring-petclinic/target/petclinic.war /usr/local/tomcat/webapps/petclinic.war

# Add jolokia for exposing JMX over http: (http://localhost:8080/jolokia/version)

EXPOSE 8080
CMD ["catalina.sh", "run"]
