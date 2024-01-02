node{
    
    stage("code checkout"){
        git 'https://github.com/rutwikdadgal/banking-finance-me-project.git'
        
    }
    
    stage("code build"){
        sh 'mvn clean package'
    }
    
    stage("contenarization"){
        sh 'docker build -t rutwikd/finance-me:1.0 .'
    }
    
    stage("push to dockerhub"){
        withCredentials([string(credentialsId: 'dockerhub-creds', variable: 'dockerhub_pwd')]) {
        sh "docker login -u rutwikd -p ${dockerhub_pwd}"
        sh 'docker push rutwikd/finance-me:1.0'
        }
    }
    
    stage("creating infrastucture"){
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY', credentialsId: 'aws-creds' , region: 'ap-south-1']]) {
        def currentDir = pwd()
        sh 'echo "Current working directory: ${currentDir}" '
        tool name: 'terraform', type: 'terraform'
        sh 'terraform init'
        sh 'terraform plan'
        sh 'terraform apply -auto-approve'
        sh 'terraform show'
        }
    }
    
  stage("configure ansible hosts") {
    sh 'echo "[test-server]" >> /etc/ansible/hosts'
    sh 'echo "$(terraform output test_server_public_ip)" >> /etc/ansible/hosts'
    sh 'echo "" >> /etc/ansible/hosts'
    sh 'echo "[prod-server]" >> /etc/ansible/hosts'
    sh 'echo "$(terraform output prod_server_public_ip)" >> /etc/ansible/hosts'
    sh 'cat /etc/ansible/hosts'
    //sh 'sudo cp ansible_hosts /etc/ansible/hosts'
}



    stage("deploy"){
        ansiblePlaybook become: true, credentialsId: 'ssh-key', disableHostKeyChecking: true, installation: 'ansible', inventory: '/etc/ansible/hosts', playbook: 'test-server.yml', vaultTmpPath: ''
    }
}