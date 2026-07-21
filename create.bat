@echo off

set BASE=develop

git checkout %BASE%

for %%B in (a b c d e f g h i j) do (
    git checkout -b dev-%%B
    git push -u origin dev-%%B
    git checkout %BASE%
)

echo Concluido!
pause


echo teste