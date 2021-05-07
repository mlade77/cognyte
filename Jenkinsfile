pipeline {
    agent any 
    stages {
        stage('Launch') { 
            steps {
                sh '''#!/bin/bash
                    echo "Launch CentOS 7 Virtual machines"
                    vagrant up
                    echo "Launch NGINX docker container"
                    docker run -v $(pwd)/default.conf:/etc/nginx/conf.d/default.conf:ro --net=host -p 80:80 -d nginx
                '''
            }
        }
        stage('Test') { 
            steps {
                sh '''#!/bin/bash
                ./simple_check.sh
                '''
            }
        }
    }
}
