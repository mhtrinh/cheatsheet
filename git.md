# Archive a branch
Source: https://stackoverflow.com/questions/1307114/how-can-i-archive-git-branches

To archive a branch, you actually just tag it and delete that branch
```bash
# Local: Tag 
git tag archive/<branch> <branch>

# Alternatively, you can add a message for why with
git tag -a archive/<branch> <branch> -m "branch merged so I archive it"

# Local: delete the branch. -d check first if the branch been merged, while -D just force deletion
git branch -d <branch>

# Remote: push the tag
git push origin --tags

# Remote: delete branch
git push origin --delete <branch>
```

# .gitignore

## Ignore all and include only some
```
*
!*/
!SOURCES
```

# Use a non-default key when cloning
```
GIT_SSH_COMMAND='ssh -i private_key_file -o IdentitiesOnly=yes' git clone user@host:repo.git
```

# ssh key with multi account
Source: https://blog.gitguardian.com/8-easy-steps-to-set-up-multiple-git-accounts/

- Create a new key call `githubPerso` with `ssh-keygen`
- Append to `~/.gitconfig` :
```
  [includeIf "gitdir:/path/to/folder/personal/"]  # Trailing '/' is very important
        path = ~/.gitconfig-perso
  ```
- Edit `~/.gitconfig-perso`:
```
[user]
email = perso@email
name = mhtrinh
 
[core]
sshCommand = "ssh -i ~/.ssh/githubPerso"
  ```

It is possible to switch profile based on the remote url as :
```
[includeIf "hasconfig:remote.*.url:git@github.com:mhtrinh/**"]
    path = ~/.gitconfig-perso
```
But this require fairly recent git version: 2.36 or above
