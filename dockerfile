FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt update && apt upgrade -y

#INSTALL OPENJDK
RUN apt-get install openjdk-11-jre-headless openjdk-11-jdk-headless -y

#INSTALL UTILITIES
RUN apt-get update && apt-get install wget tar unzip -y

# INSTALL LIBGTK3 FOR ECLIPSE
RUN apt-get install "libgtk-3*" "libgtksourceview-3.0*" -y

# INSTALL SPRING LIBRARIES
RUN mkdir "/usr/local/spring-v5.2.7"
RUN wget "https://repo.spring.io/release/org/springframework/spring/5.2.7.RELEASE/spring-5.2.7.RELEASE-dist.zip" -P "/usr/local/spring-v5.2.7/"
RUN cd "/usr/local/spring-v5.2.7/" && unzip "spring-5.2.7.RELEASE-dist.zip"

#INSTALL TOMCAT
RUN mkdir /usr/local/apache-tomcat-v8.5.57
RUN wget http://www-us.apache.org/dist/tomcat/tomcat-8/v8.5.57/bin/apache-tomcat-8.5.57.tar.gz -O /tmp/apache-tomcat-v8.5.57.tar.gz
RUN cd /tmp && tar xvfz apache-tomcat-v8.5.57.tar.gz
RUN cp -Rv /tmp/apache-tomcat-8.5.57/* /usr/local/apache-tomcat-v8.5.57/
EXPOSE 8080

# INSTALL ECLIPSE
RUN wget http://mirror.tspu.ru/eclipse/technology/epp/downloads/release/2020-06/R/eclipse-jee-2020-06-R-linux-gtk-x86_64.tar.gz -P /opt
RUN cd /opt && tar xvzf eclipse-jee-2020-06-R-linux-gtk-x86_64.tar.gz

#INSTALL WEBKIT AND DBUS
RUN apt-get install -y dbus* webkit*

# CREATE RUN SCRIPT
RUN touch startup.sh
RUN chmod +x startup.sh
RUN echo "if [ -z \$DISPLAY+x ]; then\n\t/usr/local/apache-tomcat-v8.5.57/bin/catalina.sh run;\nelse\n\t/opt/eclipse/eclipse&\n\t/usr/local/apache-tomcat-v8.5.57/bin/catalina.sh run\nfi" | cat > startup.sh

COPY TestRIOJavaStack.zip /usr/local/apache-tomcat-v8.5.57/webapps
RUN cd /usr/local/apache-tomcat-v8.5.57/webapps && unzip TestRIOJavaStack.zip

ENTRYPOINT ./startup.sh
