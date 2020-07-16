## Git

### Every day work with git
```
git status
git add full/file/path
git commit -m "MFD-xxx desc"
git pull -r
git push
```

### Branching
Branches are the core of Git. Branching in Git is very cheap, so you can (and even should use) it a lot.

##### Switching to other branch
You can easily list all local branches and create new ones with the following command:
```
git branch
git branch release10
```
To switch to an existing branch (to check out) use the command:
```
git checkout release10
```
You can also check out to given commit (put commit hash instead of branch name), but take care cause it will cause **HEAD detached**.<br />
You can also switch to non-existing branch and automatically create it:
```
git checkout -b release11
```

##### Adding new branch to remote
Push the new branch to remote (if you want to check your remote connection name use: `git remote`)
```
git push -u origin release11
```
`-u` is a shorthand for `--set-upstream` which makes the branch trackable (`git pull` and `git push` should automatically work)

##### Deleting branches
To delete a local branch you can just use the following command:
```
git branch -D branch-name
```
And to delete remote branch you can use:
```
git push origin --delete branch-name
```

##### Rename local branch
```
git branch -m new_name_of_current_branch
```

### HEAD detached from < hash >
If you see such information when you run `git status` command, it means that you are not on a branch, but on some previous old commit - you have checked out a commit (the hash is the hash of commit to which your local repo is checked out). If you have commited your changes and in this state you want to push them, run the following commands:
```
git log -n 1 #copy commit hash
git checkout master
git branch tmp-branch commit-hash
git pull -r
git cherry-pick commit-hash
git push
```
If you don't care about your changes, just checkout the branch:
```
git checkout master
```

### How to revert single file to given commit
With `git checkout` if you will specify commit hash (from which you want to get the file) and the file path, in your working area you will have the file modified to the version from specified commit:
```
git chekout commit-hash path/to/file
```

### How to revert last NOT pushed commit
```
git reset HEAD~1
```

### Aliases
With aliases you can create some short commands so you can work faster with git. You can add them in global `.gitconfig` file which you can find in `%userprofile%`. Here are little examples, but of course they can be more complex:
```
[alias]
    f =fetch
    s =status
    fs =! git fetch && git status
    p =pull -r
    
    b =branch
    cho =checkout
    
    a =add .
    c =commit
    cm =commit -m
    
    unstage =restore --staged .
    undo =checkout -- .
    untrack =clean -fd
    undoall =! git restore --staged . && git checkout -- . && git clean -fd
    
    chp =cherry-pick
    st =stash
    stp =stash pop
    stl =stash list  
```
Such aliases can be used in the following manner:
```
git s
git p
```
With `!` operator you can run commands from the context of command line (shell), in case of Windows it would be **cmd.exe**, so it allows to combine many git commands into one alias - really useful technic!

### Ignore files
To ignore files which are already added to git repository, you can use `git update-index --skip-worktree file/path`. A nice trick is to add an alias with all the files that you want to ignore so you can easily ignore them anytime needed. You should add the following code in git config file:
```
[alias]
    ignore-cfg =update-index --skip-worktree MyProject/App.Debug.config MyProject/Config.Debug.config 
    unignore-cfg =!git update-index --no-skip-worktree MyProject/App.Debug.config MyProject/Config.Debug.config && git stash save ConfigIgnoredByDefatult
```
You can find local git config (used only for given project) in `.git\config` file or global git config file in `%userprofile%\.gitconfig`.

### Save your changes temporarily - stash
It may happen that you've got some work in progress, changes that are not ready to commit but for some reason you need to get the latest version of the code. But you cannot pull changes from a remote branch if you've got some uncommited changes locally and you don't want your changes to be lost. What to do in such situation? Stash your changes. It is very simple, you just run the following command:
```
git stash
```
It will save your local changes on a stash list as a *temporary* commit and clean your working area so you can pull from a remote branch. You can then list all the stashes (with `git stash list` command) or get the last one, apply it and remove from stash list:
```
git stash pop
```
You can use `git stash apply` to apply the stash without removing from the list.

### error: cannot lock ref
If you encounter an error message like this:
```
error: cannot lock ref 'refs/remotes/origin/some-branch': is at <some-hash> but expected <some-other-hash>
```
You can use the following command:
```
git gc --prune=now
```
