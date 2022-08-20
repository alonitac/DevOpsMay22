# Git Exercise
Due date: 29/08/2022 23:59

## Preliminaries

1. Open [our shared git repo](https://github.com/alonitac/DevOpsMay22) in PyCharm and pull the repository in branch **main** to get an up-to-date version.
2. Checkout **new** branch `git_ex1/<alias>` where `<alias>` is replaced by your name.
3. In your local machine, initialize a new local Git repository (`git init...`). 
4. Copy `07_git_exercise/init.sh` into your empty Git repo. This file will automatically create branches 
and commit changes in ycd our repo, so you can be ready for the exercise.  
5. Execute `init.sh` by `bash init.sh` or if you use Pycharm terminal, you can run `sh init.sh`. Make sure it's finished without errors. 
If in any step you want to initialize the repo again in order to get a clean version, don't run `init.sh` again, 
but delete the old repo and create a new one by `git init`.
```
# A1. Re-creating git directory: 
rm -rf .git
git init
./init.sh (or `sh init.sh`)
```

From now on, unless otherwise specified, **execute all commands from the Terminal (either Ubuntu or Pycharm terminal)**. 
Answer the questions below in the `README` file. 
Include the commands you executed in each step, as well as a free text explanation if needed.

### Git Basics (commit, diff, branches)

1. In branch `main`, create a file called `abc.txt` containing the text `1` in it.
**echo "1" > abc.txt**

2. What is the color of file `abc.txt` in Git status view? 'RED'

3. Add the file to the index. What is the color now? 
commit the changes (it's recommended to use `git status` in between steps). - GREEN
**git add abc.txt** 

4. Append the line `2` to the end of `abc.txt` to change the state of this file in the working tree.
**echo "2" >> abc.txt**

5. Is the color of `abc.txt` different from the observed color in step 2? 
What are the differences between the two outputs of `git status` command?
**The second part is not different from the step 2.**
**The difference is between GREEN and RED.**

6. What is the command to show changes between the working tree to branch `main`?
**git diff** (git diff main - eq last commit; HEAD - last commit of the current branch)

7. Why does `git diff --staged` print nothing? ??? ??
diff --git a/abc.txt b/abc.txt
new file mode 100644
index 0000000..d00491f
--- /dev/null
+++ b/abc.txt
@@ -0,0 +1 @@
+1

8. Why does `git diff stage2` prints fatal error? 
What is the error?
**There is no such branch.**  
The error: "ambiguous argument 'stage2': unknown revision or path not in the working tree."

9. Add `abc.txt` to the index.
**git add abc.txt**

10. What does `git diff` print? why?
**Nothing. All the changes are staged.**  

11. What is the command to show changes between the index and branch `main`?
**git diff --staged**
(index == stage)

12. Append the line `3` to the end of `abc.txt` to change the state of this file in the working tree.
**echo "3" >> abc.txt** 

13. Would `git diff --staged` and `git diff main` commands print the same output? why?
**No. 1st - shows staged changes (after git add command). 2nd - shows difference between main and working tree.** 

14. Why does `abc.txt` appear twice in the output of `git status`?
**Changes to be committed and Changes not staged for commit.**

15. **Unstage** the changes in your index and working tree (don't commit the changes)

### Resolve conflicts

Your manager decided that you'll lead the development of a feature called "[Lambda](https://aws.amazon.com/lambda/) migration" .
You are told that John Doe and Narayan Nadella, your team colleagues, have already been worked on that area of the project in the past.
You decide to create a new branch called `feature/lambda_migration` and merge the previous work of John and Narayan to your branch.

1. List all existed branches of this repo (print them).
**git branch**

2. Create a new branch called `feature/lambda_migration` and switch (checkout) to this branch.
**git checkout -b feature/lambda_migration**
or with two commands
**git branch feature/lambda_migration**
**git checkout feature/lambda_migration**

3. Merge branch `feature/version1` into `feature/lambda_migration`, observe the merged changes.
**git checkout feature/lambda_migration** (checkout to the destination branch, if you still not there)
**git merge feature/version1** (merge the branch to the current branch)

4. **Using PyCharm UI** - merge branch `feature/version2` into `feature/lambda_migration`.
   ![MergePyCharm](img/merge.png)

error: Merging is not possible because you have unmerged files.
hint: Fix them up in the work tree, and then use 'git add/rm <file>'
hint: as appropriate to mark resolution and make a commit.
fatal: Exiting because of an unresolved conflict.

6. Resolve the conflict as following:
   1. On the opened conflict tool, choose the conflicted file and click **Merge**.  
      ![Conflict](img/conflict.png)
   2. First click **All** to merge all changes for which there is no conflicts.  
      ![All](img/conflict-all.png)
   3. Right click on right and left pages and choose **Annotate with Git Blame**.
   4. Accept John Doe's port number (8081), deny Narayan's port (8082).
   5. Accept the function name of Narayan Nadella (get_profile_picture), Block John's name.

7. After all merges were completed, are there any added commits for `feature/lambda_migration`? 
what are those commits?
**07_git_exercise/app.py - need to be committed**

### Cherry picking

`git cherry-pick` is a powerful command that enables arbitrary Git commits to be picked by reference and appended to the current working HEAD.
Continuing our story from above, let's say you've messed up your branch `feature/lambda_migration`, and you want to start over again, but picking only some valuable commits from your previous branch.

1. Create a clean fresh branch `feature/lambda_migration2`, **versioned from `main`**.
2. In **Pycharm Git** tab (bottom left), navigate to tab **Log**, filter **Branch** so only commit of `feature/lambda_migration` would be shown.
3. **In PyCharm UI**, use the cherry-pick icon to pick those commits in the following order:
    1. "use correct lock type in reconnect()"
    2. "Restrict the extensions that can be disabled"
       ![Cherry pick](img/cherry-pick.png)
4. Which files have been added to your branch as a result of the commits cherry-picking?
5. Should you care about the order in which commits are picked? why?


### Changes in working tree and switch branches

A very common issue for Git beginners is switching branches while there are uncommitted changes in the working tree. We will now simulate this scenario and discuss common practices.

1. Make sure you are in branch different from `dev` (you should be in `feature/lambda_migration2` if you follow the exercise in the order it's written).
2. Create a new file called `take.txt`, write some lines in it and add it to the index (don't commit, only add). Now you have uncommitted changes in the working tree.
3. Checkout to `dev`, which error do you get? What are the two approaches suggested by git? Read about `git stash` command from the [Official Git Docs](https://git-scm.com/docs/git-stash).
4. **Using PyCharm UI** try to checkout `dev` again. On the prompted dialog click **Force Checkout**.
5. Does `take.txt` contain your changes when you're now in `dev`?
6. Checkout back to the branch you've come from, do you have your `take.txt` there? So what does **Force Checkout** do?

### Reset

1. Checkout `reset_question` branch.
2. Run the following commands line by line, after each command, observe what happened to your working tree and explain why.
   1. `git reset --soft HEAD~1`
   2. `git reset --mixed HEAD~1`
   3. `git reset --hard HEAD~1`
   4. `git revert HEAD~1`
3. Explain the notation `HEAD~1` in git reset command.

### Working with GitHub 

1. In your GitHub account, create a new repository. 
2. Add this repo as a remote (origin) to the local repo you've worked on along this exercise.
3. Push branches `main` and `dev`.
4. Copy and paste the link to your GitHub repo in the `README` answers file. 

# Good Luck

Don't hesitate to ask any questions