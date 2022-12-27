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
        def grp_ID = 'com.example'
        def nex_url = '172.31.28.226:8081'
        def nex_ver = 'nexus3'
        def proto = 'http'
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
                    repository: "${nex_repo}",
                    version: "${mavenpom.version}"
                    echo 'Artifact uploaded to nexus repository'
                }
            }
        }
        stage('Execute Ansible Playbook'){
                steps{
                    withCredentials([usernameColonPassword(credentialsId: 'ansible', variable: 'ansible')]) {
                        sh'''
                        ssh  devops@13.112.68.39 -o StrictHostKeyChecking=no
                        '''
                    }
                }
        }
    }
}

