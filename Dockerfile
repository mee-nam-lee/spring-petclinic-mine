FROM mnlee30/tomcat-docker:latest

MAINTAINER Mee-Nam.lee mnlee30@gmail.com

# Pull project
RUN git clone https://github.com/mee-nam-lee/spring-petclinic.git

# Build project
RUN cd spring-petclinic && mvn package
RUN mv /spring-petclinic/target/petclinic.war /usr/local/tomcat/webapps/petclinic.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
