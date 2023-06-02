#!/bin/bash
VERSION_SONARQUBE=9.9.0.65466
RUSSIAN_PACK=9.0
BRANCH_PLUGIN_VERSION=1.14.0
BSL_PLUGIN_VERSION=1.11.0

wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-${VERSION_SONARQUBE}.zip
unzip sonarqube-${VERSION_SONARQUBE}.zip
mv sonarqube-${VERSION_SONARQUBE}/ /opt/sonarqube
rm sonarqube-${VERSION_SONARQUBE}.zip

cp ./sonarqube.service /etc/systemd/system/sonarqube.service
mkdir /opt/sonarqube/extensions/plugins
cd /opt/sonarqube/extensions/plugins
wget https://github.com/1c-syntax/sonar-l10n-ru/releases/download/v${RUSSIAN_PACK}/sonar-l10n-ru-plugin-${RUSSIAN_PACK}.jar
wget https://github.com/1c-syntax/sonar-bsl-plugin-community/releases/download/v${BSL_PLUGIN_VERSION}/sonar-communitybsl-plugin-${BSL_PLUGIN_VERSION}.jar
wget https://github.com/mc1arke/sonarqube-community-branch-plugin/releases/download/${BRANCH_PLUGIN_VERSION}/sonarqube-community-branch-plugin-${BRANCH_PLUGIN_VERSION}.jar

useradd -M -d /opt/sonarqube/ -r -s /bin/bash sonarqube
chown -R sonarqube: /opt/sonarqube

echo "sonar.jdbc.username=sonarqube" >> /opt/sonarqube/conf/sonar.properties
echo "sonar.jdbc.password=sonar" >> /opt/sonarqube/conf/sonar.properties
echo "sonar.jdbc.url=jdbc:postgresql://localhost:5432/sonarqube" >> /opt/sonarqube/conf/sonar.properties
echo "sonar.web.javaAdditionalOpts=-javaagent:./extensions/plugins/sonarqube-community-branch-plugin-${BRANCH_PLUGIN_VERSION}.jar=web" >> /opt/sonarqube/conf/sonar.properties
echo "sonar.ce.javaAdditionalOpts=-javaagent:./extensions/plugins/sonarqube-community-branch-plugin-${BRANCH_PLUGIN_VERSION}.jar=ce" >> /opt/sonarqube/conf/sonar.properties

ufw allow 9000
firewall-cmd --permanent --add-port=9000/tcp 
firewall-cmd --reload

systemctl daemon-reload
systemctl enable sonarqube
systemctl start sonarqube

