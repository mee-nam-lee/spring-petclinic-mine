FROM tomcat:8.5

MAINTAINER Mee-Nam.lee mnlee30@gmail.com

RUN apt-get -qq update

RUN apt-get -y install oracle-java8-installer
RUN apt-get clean
RUN update-alternatives --display java

# add JAVA_HOME to path.
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

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
