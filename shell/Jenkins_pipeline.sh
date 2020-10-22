// Docker/K8S技术交流群：

node { 
   // 拉取代码
   stage('Git Checkout') { 
         checkout([$class: 'GitSCM', branches: [[name: '${branch}']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: '8c2f92e3-0cae-4528-8ae9-9ae1e1c8ee69', url: 'git@192.168.31.66:/home/git/tomcat-java-demo.git']]])   }
   // 代码编译
   stage('Maven Build') {
        sh '''
        export JAVA_HOME=/usr/local/jdk
        /usr/local/maven/bin/mvn clean package -Dmaven.test.skip=true
        '''
   }
   // 项目打包到镜像并推送到镜像仓库
   stage('Build and Push Image') {
sh '''
REPOSITORY=192.168.31.66/library/tomcat-java-demo:${branch}
cat > Dockerfile << EOF
FROM 192.168.31.66/library/tomcat:v1 
MAINTAINER www.ctnrs.com
RUN rm -rf /usr/local/tomcat/webapps/*
ADD target/*.war /usr/local/tomcat/webapps/ROOT.war
EOF
docker build -t $REPOSITORY .
docker login 192.168.31.66 -u admin -p Harbor12345
docker push $REPOSITORY
'''
   }
   // 部署到Docker主机
   stage('Deploy to Docker') {
        sh '''
        REPOSITORY=192.168.31.66/library/tomcat-java-demo:${branch}
        docker rm -f tomcat-java-demo |true
        docker pull $REPOSITORY
        docker container run -d --name tomcat-java-demo -p 88:8080 $REPOSITORY
        '''
   }
}