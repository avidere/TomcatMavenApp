FROM tomcat:latest
RUN mv /usr/local/tomcat/webapps.dist/* /usr/local/tomcat/webapps/
ARG host_name
ARG artifact_id
ARG version
ARG build_no
RUN wget http://$host_name/repository/tomcat-Release/example/demo/$artifact_id/$version/$artifact_id-$version.war
RUN mv *.war /usr/local/tomcat/webapps/
