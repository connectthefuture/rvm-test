source "$rvm_path/scripts/rvm"

: prepare
true TMPDIR:${TMPDIR:=/tmp}:
d=$TMPDIR/test-rvmrc
mkdir $d
pushd $d
command rvm install 1.9.3-p484
rvm 1.9.3-p484 do rvm gemset reset_env
rvm use 1.8.7 --install

: .rvmrc generated
rvm rvmrc create 1.9.3-p484
[ -f .rvmrc ]         # status=0
rvm current           # match=/1.8.7/
rvm rvmrc trust .rvmrc
rvm rvmrc load .rvmrc # env[GEM_HOME]=/1.9.3-p484$/ ; env[PATH]=/1.9.3-p484/
rvm current           # match=/1.9.3/

: .rvmrc with use
rvm_current_rvmrc=""
echo "rvm use 1.8.7" > .rvmrc
rvm rvmrc trust .
rvm rvmrc load .
rvm current           # match=/1.8.7/

: .rvmrc without use
rvm_current_rvmrc=""
echo "rvm 1.9.3" > .rvmrc
rvm rvmrc trust
rvm rvmrc load
rvm current           # match=/1.9.3/

rm -f .rvmrc
rvm use 1.8.7

: .versions.conf
rvm rvmrc create 1.9.3 .versions.conf
[ -f .versions.conf ] # status=0
rvm current           # match=/1.8.7/
rvm rvmrc load .
rvm current           # match=/1.9.3/

rm -f .versions.conf
rvm use 1.8.7

: .ruby-version
rvm rvmrc create 1.9.3 .ruby-version
[ -f .ruby-version ]  # status=0
rvm current           # match=/1.8.7/
rvm rvmrc load .
rvm current           # match=/1.9.3/

rm -f .ruby-version
rvm use 1.8.7

: clean
popd
rm -rf $d
