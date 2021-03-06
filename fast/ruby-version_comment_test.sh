source "$rvm_path/scripts/rvm"

: prepare
true TMPDIR:${TMPDIR:=/tmp}:
d=$TMPDIR/test-ruby-version
f=$d/.ruby-version
g=$d/.ruby-gemset
e=$d/.ruby-env
mkdir -p $d
cd $d
rvm use --install 2.1.2
rvm use --install 2.1.1
rvm use --install 2.1.0

## simple
: short version
echo "2.1.1" > $f           # env[GEM_HOME]=/2.1.0/
rvm use .                   # env[GEM_HOME]=/2.1.1/

: ruby version
rvm use 2.1.0
echo "ruby-2.1.1" > $f      # env[GEM_HOME]=/2.1.0/
rvm use .                   # env[GEM_HOME]=/2.1.1/

: patch version
rvm use 2.1.0
echo "2.1.2" > $f      # env[GEM_HOME]=/2.1.0/
rvm use .                   # env[GEM_HOME]=/2.1.2/

: full version
rvm use 2.1.0
echo "ruby-2.1.2" > $f # env[GEM_HOME]=/2.1.0/
rvm use .                   # env[GEM_HOME]=/2.1.2/

: gemset
rvm use 2.1.0
echo "veve" > $g            # env[GEM_HOME]=/2.1.0/
rvm use .                   # env[GEM_HOME]=/2.1.2@veve/
rm -f $g

: environment
rvm use 2.1.0
echo "test_me=3" > $e
rvm use .                   # env[GEM_HOME]=/2.1.2/; env[test_me]=/^3$/
rvm use 2.1.0               # env[GEM_HOME]=/2.1.0/; env[test_me]=/^$/

: environment spaces
rvm use 2.1.0
echo 'test_space=test me' > $e
rvm use .                   # env[GEM_HOME]=/2.1.2/; env[test_space]=/^test me$/
rvm use 2.1.0               # env[GEM_HOME]=/2.1.0/; env[test_space]=/^$/

: environment quotes and spaces
rvm use 2.1.0
echo 'test_space="test me"' > $e
rvm use .                   # env[GEM_HOME]=/2.1.2/; env[test_space]=/^test me$/
rvm use 2.1.0               # env[GEM_HOME]=/2.1.0/; env[test_space]=/^$/

: clean
cd ..
rm -rf $d
