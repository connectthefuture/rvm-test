source "$rvm_path/scripts/rvm"

: prepare
d=${TMPDIR:=/tmp}/test-rvm-shell/ # status=0
mkdir -p $d                       # status=0
echo "rvm current" > $d/rvm-shell-rvm-current-script.sh # status=0
chmod +x $d/rvm-shell-rvm-current-script.sh
rvm use 1.9.3-p484 --install
rvm use system

: Test1
echo "rvm use 1.9.3-p484@acme --create" > $d/.rvmrc     # status=0
ls -ld $d/.rvmrc
rvm rvmrc trust $d/.rvmrc                               # status=0
rvm $d do rvm current                                   # match=/ruby-1.9.3-p484@acme/
rvm-shell --path $d -c "rvm current"                    # match=/ruby-1.9.3-p484@acme/
rvm $d do $d/rvm-shell-rvm-current-script.sh            # match=/ruby-1.9.3-p484@acme/
rvm-shell --path $d $d/rvm-shell-rvm-current-script.sh  # match=/ruby-1.9.3-p484@acme/
rvm use $d                                              # env[GEM_HOME]=/ruby-1.9.3-p484@acme$/
rvm use system

: Test2
echo "rvm 1.9.3-p484@acme --create" > $d/.rvmrc         # status=0
ls -ld $d/.rvmrc
rvm rvmrc trust $d/.rvmrc                               # status=0
rvm $d do rvm current                                   # match=/ruby-1.9.3-p484@acme/
rvm-shell --path $d -c "rvm current"                    # match=/ruby-1.9.3-p484@acme/
rvm $d do $d/rvm-shell-rvm-current-script.sh            # match=/ruby-1.9.3-p484@acme/
rvm-shell --path $d $d/rvm-shell-rvm-current-script.sh  # match=/ruby-1.9.3-p484@acme/
rvm $d                                                  # env[GEM_HOME]=/ruby-1.9.3-p484@acme$/

: Cleaning
rm -rf $d # status=0
