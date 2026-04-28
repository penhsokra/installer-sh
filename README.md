# installer-sh
What you want is basically a one-command installer from Git — very common in DevOps. The clean way is to store your script in a repo, then run it remotely via SSH.


## Install java jdk
```bash
curl -s https://raw.githubusercontent.com/penhsokra/installer-sh/main/install-java.sh | bash
```

## Install Tomcat
```bash
wget https://downloads.apache.org/tomcat/tomcat-11/v11.0.21/bin/apache-tomcat-11.0.21.tar.gz
```

```bash
tar -xzf apache-tomcat-11.0.21.tar.gz -C . --strip-components=1
```
### Change port and deployment dir
Search for port and change to the number we want\n
Search for appBase for deployment dir
```bash
vim conf/server.xml
```
### Set up alias in bash profile
```bash
alias tlog='tail -1000f /opt/apache-tomcat-11.0.21/logs/catalina.out'
alias tstart='sh /opt/apache-tomcat-11.0.21/bin/startup.sh'
alias tstop='sh /opt/apache-tomcat-11.0.21/bin/shutdown.sh'
```
### Start Tomcat
```bash
tstart
```
### Verify
```bash
ps -ef | grep tomcat
```