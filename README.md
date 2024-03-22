# gitea-mirror

Shell script for mirroring Gitea repositories to GitHub while preserving commit history.

### Usage 
1. Set up your settings: **config.conf**

```

GITEA_USERNAME="your_gitea_username"
GITEA_ACCESS_TOKEN="your-gitea-token"
GITEA_SERVICE_PROVIDER="your_provider" #https://mygiteaserver.me 
```
[GITHUB_ACCESS_TOKEN](https://github.com/settings/tokens)   
**Note**: Ensure that GITEA_SERVICE_PROVIDER does not end with a "/".



2. Execute one of the two 
#### Usage 'git-merger.sh'
* The script clones Gitea repositories and mirrors them to GitHub.  
```
    :~$ bash git-merger.sh
```
#### Usage 'singular-merge.sh'
*  This script clones and mirrors a singular repoistory, this could be merged with the first script, but I am currently too lazy for that.
```
    :~$ bash singular-merge.sh https://mygiteaserver.me/user/project-repository
```

#### Additional Notes
* Preserve your project's commit history by using this script

## Disclaimer

This script is provided as-is, without any warranty or guarantee of its effectiveness or suitability for any specific purpose. The author and contributors of this script shall not be liable for any damages or issues arising from the use of this script.

Please ensure that you review and understand the script's functionality and settings before running it, as it may have unintended consequences if not used correctly. Always backup your data and repositories before executing the script, especially when dealing with sensitive or critical information.

Use this script at your own risk. The author and contributors do not provide any support or assistance beyond what is documented in this readme. If you encounter any issues or have questions about the script, you are encouraged to seek assistance from relevant forums, communities, or technical experts.

By using this script, you agree to the terms outlined in this disclaimer.
###

#### Author [kasepuu](https://github.com/kasepuu)