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

# Porting commit from one repo to another
Generate a patch file per commit, using relative path, in case your destination have different folder structure
```
git format-patch --relative -o /path/to/patches/ 234f94fdfed7e9..HEAD
```
Apply the commits:
```
git am --directory <relative folder> /path/to/patches/*
```

In case last commit is a merge commit, more manual patching is required:
```
git log -p --reverse --pretty=email --stat -m --first-parent -1 HEAD > /dev/shm/last.patch
git am --directory modelreproduce --reject /dev/shm/last.patch  # This will apply the best it can and leave a bunch of reject.
git add <file that been patched>
git am --continue
```
Because merge commit also include other commit that already been applied, it will failed to apply those changes, which you can safely ignore and continue.


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


# git size diagnostic
List all files (blob) :
```
git rev-list --objects --all |
  git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' |
  sed -n 's/^blob //p' |
  sort --numeric-sort --key=2 |
  cut -c 1-12,41- |
  $(command -v gnumfmt || echo numfmt) --field=2 --to=iec-i --suffix=B --padding=7 --round=nearest
```

# Reducing git size by removing big files and rewriting history
```
git filter-repo --replace-refs delete-no-add --force --invert-paths --path path/to/folder --path path/to/file --path another/path
git gc --prune=now --aggressive
```
This will rewrite history, trimming each commit from those files. `--replace-refs delete-no-add` is nice to have when your git repo been migrated from svn, it will transform remote refs to normal branch.


