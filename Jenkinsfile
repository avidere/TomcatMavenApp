/* groovylint-disable LineLength */
/* groovylint-disable-next-line LineLength */
/* groovylint-disable CompileStatic, DuplicateStringLiteral, NestedBlockDepth, UnusedVariable, VariableName, VariableTypeRequired */
pipeline {
    agent any
    environment {
        def git_branch = 'master'
        def git_url = 'https://github.com/avidere/TomcatMavenApp.git'

        def mvntest = 'mvn test '
        def mvnpackage = 'mvn clean install'

        def sonar_cred = 'sonar'
        def code_analysis = 'mvn clean install sonar:sonar'
        def utest_url = 'target/surefire-reports/**/*.xml'

        def nex_cred = 'nexus'
        def grp_ID = 'example.demo'
        def nex_url = '172.31.20.5:8081'
        def nex_ver = 'nexus3'
        def proto = 'http'

        def remote_name = 'ubuntu'
        def remote_host = '172.31.22.228'
        def remote_user = 'devops'
        def remote_password = 'devops'
        
    }
    stages {
        stage('Git Checkout') {
            steps {
                script {
                    git branch: "${git_branch}", url: "${git_url}"
                    echo 'Git Checkout Completed'
                }
            }
        } 
        /* groovylint-disable-next-line SpaceAfterClosingBrace */
        stage('Maven Build') {
            steps {
                sh "${env.mvnpackage}"
                echo 'Maven Build Completed'
            }
        }/*
        stage('Unit Testing and publishing reports') {
            steps {
                script {
                    sh "${env.mvntest}"
                    echo 'Unit Testing Completed'
                }
            }
            post {
                success {
                        junit "$utest_url"
                        jacoco()
                }
            }
        }
        stage('Static code analysis and Quality Gate Status') {
            steps {
                script {
                    withSonarQubeEnv(credentialsId: "${sonar_cred}") {
                        sh "${code_analysis}"
                    }
                    waitForQualityGate abortPipeline: true, credentialsId: "${sonar_cred}"
                }
            }
        } */ 
        stage('Upload Artifact to nexus repository') {
            steps {
                script {

                   def mavenpom = readMavenPom file: 'pom.xml'
                   def nex_repo = mavenpom.version.endsWith('SNAPSHOT') ? 'tomcat-SNAPSHOT' : 'tomact-Release'
                    nexusArtifactUploader artifacts: [
                    [
                        artifactId: 'helloworld',
                        classifier: '',
                        file: "target/helloworld.war",
                        type: 'war'
                    ]
                ],
                    credentialsId: "${env.nex_cred}",
                    groupId: "${env.grp_ID}",
                    nexusUrl: "${env.nex_url}",
                    nexusVersion: "${env.nex_ver}",
                    protocol: "${env.proto}",
                    repository: "tomcat-Release",
                    version: "${mavenpom.version}"
                    echo 'Artifact uploaded to nexus repository'
                }
            }
        }
		stage('Build Docker image and push To Docker hub'){
            steps{
                withCredentials([usernamePassword(credentialsId: 'Docker_hub', passwordVariable: 'docker_pass', usernameVariable: 'docker_user')]) {
                script{
                    sshagent(['Docker-Server']) {
                          sh "ssh -o StrictHostKeyChecking=no -l dockeradmin 172.31.2.23 sudo rm -rf TomcatMavenApp"
                          sh "ssh -o StrictHostKeyChecking=no -l dockeradmin 172.31.22.228 git clone ${git_url} "

       
                          sh "ssh -o StrictHostKeyChecking=no -l dockeradmin 172.31.22.228 sudo sed -i 's/tag/${env.BUILD_NUMBER}/g' /home/dockeradmin/TomcatMavenApp/helm-chart/values.yaml"
                         
                          sh "ssh -o StrictHostKeyChecking=no -l dockeradmin 172.31.22.228 docker build -t avinashdere99/tomcat:${env.BUILD_NUMBER} /home/dockeradmin/TomcatMavenApp/."
                          sh "ssh -o StrictHostKeyChecking=no -l dockeradmin 172.31.22.228 docker login -u $docker_user -p $docker_pass"
                       //   sh "ssh -o StrictHostKeyChecking=no -l dockeradmin 172.31.2.23 sudo rm -r Pythonapp-deployment "
                          sh "ssh -o StrictHostKeyChecking=no -l dockeradmin 172.31.22.228 docker push avinashdere99/tomcat:${env.BUILD_NUMBER}"
                          sh "ssh -o StrictHostKeyChecking=no -l dockeradmin 172.31.22.228 docker rmi avinashdere99/tomcat:${env.BUILD_NUMBER}"
                    }
                  }
                }
            }
        } 

    }
}

