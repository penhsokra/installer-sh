# installer-sh
What you want is basically a one-command installer from Git — very common in DevOps. The clean way is to store your script in a repo, then run it remotely via SSH.


```bash
curl -s https://github.com/penhsokra/installer-sh/main/install-java.sh | bash
```
