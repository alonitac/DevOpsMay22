# Git Basics (commit, diff, branches)

1. echo "1" > abc.txt
2. git status . Color is red
3. git add abc.txt . git status . Color is green . git commit -m "adding abc.txt"
4. echo "2" >> abc.txt
5. Color is red . The git status of the file is now in "modified" state.
6. git diff
7. git diff --staged shows nothing because the "abc.txt" file is in the working tree and not staged.
8. git diff stage2 shows an error because there isn't a file called stage2, if we want to use an option in the diff command, then we need to add '--' before the option... The error is - fatal: ambiguous argument 'stage2': unknown revision or path not in the working tree.
Use '--' to separate paths from revisions, like this:
'git <command> [<revision>...] -- [<file>...]'
9. git add abc.txt . git status
10. git diff shows nothing because there are no changes between working tree to staging
11. git diff --staged
12. echo "3" >> abc.txt
13. No, the 'git diff main' command shows the differences between the wroking tree and stage, and 'git diff --staged' will only show changes to files in the "staged" area
14. Because we first added the file to the 'staged' area, and then we made another change to the file... So now, the file exists in both areas.
15. git reset --hard

# Resolve conflicts

1. 'git branch'
2. 'git checkout -b feature/lambda_migration' . Then, 'checkout feature/lambda_migration' (Should be automatically).
3. 'git merge feature/version1' (After commiting all files in the working tree).
4. Step is done.
5.
   1. Clicked on merge button ->
   2. -> Then, clicked on the 'all' button ->
   3. -> Then, clicked on right & left annotate with 'git blame'
   4. -> Clicked on the 'accept' button.
   5. Accept and then ignore.
6. 'git log' command will show the commits:
   1) Merge branch 'feature/version1' into feature/lambda_migration
   2) Merge branch 'feature/version2' into feature/lambda_migration

# Cherry picking

1. 'git checkout main' ,'git checkout -b feature/lambda_migration2'
2. 'git log feature/lambda_migration'
3. 'git cherry-pick' commitSHA
    1. git cherry-pick 241d9671acb63ccc173491aa43ccad945b64cdd8 (commit sha of: use correct lock type in reconnect())
    2. git cherry-pick ae1b321a9cecd637f6432f6cabc9264529a9fcfc (commit sha of: Restrict the extensions that can be disabled)
4. '.env' & 'config.json'
5. Yes, we want to pick the most updated state of the branch, which means we should prefer to pick the last commit of the user in the end.


# Changes in working tree and switch branches

1. already in 'feature/lambda_migration2'
2. touch take.txt, echo "bla bla bla" >> , echo "bla2 bla2 bla2", echo "bla3 bla3 bla3", take.txt ,git add take.txt
3. 'git checkout dev'
   error: Your local changes to the following files would be overwritten by checkout:
         take.txt
   Please commit your changes or stash them before you switch branches.
   Aborting

First approach- commit the changes and then check out
Second approach- use git stash. It will preserve the current working tree.
4. 'git checkout --force dev'
5. No.
6. No, the file isn't exists anymore, the 'git checkout --force dev' commend removes indexed changes.

# Reset

1. 'git checkout reset_question'
2.
   1. The commit of '10.txt' file was reverted.
   'git reset --soft HEAD~1' -> Reverts commited changes and moves them back to the working tree.
   2. '9.txt' & '10.txt' were changed to untracked.
   'git reset --mixed HEAD~1' -> Moves all the files that were added to the index to the working tree.
   3. '8.txt' got deleted.
   'git reset --hard HEAD~1' -> Resets index and working tree areas.
   4. '6.txt' got deleted.
   'git revert HEAD~1' -> Reverts last commit.
3. 'HEAD~1' -> Return one commit back from head.


# Working with GitHub

1. Created new repo under my GitHub user (twolf789). (repo name: ex1_git)
2. git remote add origin https://github.com/twolf789/ex1_git.git
3. First I pushed the 'feature/lambda_migration2' branch, because I wanted it to be the default branch. Later, I pushed the following branches: 'feature/version1', 'feature/version2', 'dev', 'main', 'feature/lambda_migration'. I pushed all branches using the following command: 'git push -u origin `BRANCH_NAME`'
4. https://github.com/twolf789/ex1_git
