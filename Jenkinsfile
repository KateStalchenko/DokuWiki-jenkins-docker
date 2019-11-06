pipeline {
    agent { 
        label 'master'
    }
    environment {
        registry = 'dockerkatya/project'
    }
    parameters {
        string(name: 'repository_url', defaultValue: 'https://github.com/KateStalchenko/DokuWiki-jenkins-docker.git', description: 'Github repository url')
        booleanParam(name: 'build_and_run_docker', defaultValue: true, description: 'Deploy and run docker')
    	booleanParam(name: 'remove', defaultValue: false, description: 'Remove Dokuwiki')
  }
  stages {
     stage ('Build and run docker for Dokuwiki') {
	    when {
	     expression {params.build_and_run_docker == true}
	    }  
	    stages {
          stage('Clone Git') {
            steps {
              git url: "${params.repository_url}"
            }
          }
          stage('Build image') {
            steps {
              script {
                dockerImage = docker.build registry + ":$BUILD_NUMBER"
              }
            }
          }	          
          stage('Run docker image'){
            steps {
              bat "echo $registry:$BUILD_NUMBER"
              bat "docker run -d  -p 80:80 --name dokuwiki $registry:$BUILD_NUMBER"
            }
          }  
	    }
     }
     stage('Remove Dokuwiki') {
	    when {
	     expression {params.remove == true}
	    }
        stages {
		  stage('Stop and delete docker container') {
		    steps {
                bat "docker container stop dokuwiki"
			    bat "docker container prune -f"
	        }
		  }
          stage('Remove docker image') {
            steps{
              bat "docker system prune -af"
            }
          }
        }
     }		
   }
   post {
    success {
      slackSend (color: '#00FF00', message: "SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
      }
    failure {
      slackSend (color: '#FF0000', message: "FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
      }
    }
}