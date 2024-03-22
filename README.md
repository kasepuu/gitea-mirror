# gitea-mirror

Shell script for mirroring Gitea repositories to GitHub while preserving commit history.

### Usage

1. **Set up your settings:**
```
GITHUB_USERNAME="your_github_username"
GITHUB_ACCESS_TOKEN="your_personal_access_token"
GITEA_USERNAME="your_gitea_username"
GITEA_ACCESS_TOKEN="your-gitea-token"
GITEA_SERVICE_PROVIDER="your_provider" #https://mygiteaserver.me 
```
Note: Ensure that GITEA_SERVICE_PROVIDER does not end with a "/".

[GITHUB_ACCESS_TOKEN](https://github.com/settings/tokens)


2. Execute the script:
```
    :~$ bash git-merger.sh
```
#### Additional Notes
* The script clones Gitea repositories and mirrors them to GitHub
* Preserve your project's commit history by using this script

## Disclaimer

This script is provided as-is, without any warranty or guarantee of its effectiveness or suitability for any specific purpose. The author and contributors of this script shall not be liable for any damages or issues arising from the use of this script.

Please ensure that you review and understand the script's functionality and settings before running it, as it may have unintended consequences if not used correctly. Always backup your data and repositories before executing the script, especially when dealing with sensitive or critical information.

Use this script at your own risk. The author and contributors do not provide any support or assistance beyond what is documented in this readme. If you encounter any issues or have questions about the script, you are encouraged to seek assistance from relevant forums, communities, or technical experts.

By using this script, you agree to the terms outlined in this disclaimer.
###

#### Author [kasepuu](https://github.com/kasepuu)