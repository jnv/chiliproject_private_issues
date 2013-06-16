#!/bin/sh

pwd

# Prepare ChiliProject
if [ "x$MAIN_ARCHIVE" != "x" ]; then
  wget $MAIN_ARCHIVE
  mkdir -p $TARGET_DIR
  tar -xf *.tar.gz --strip 1 -C $TARGET_DIR
else
  git clone --depth=100 $MAIN_REPO $TARGET_DIR
  #git submodule update --init --recursive
fi
cd $TARGET_DIR

# Copy over the already downloaded plugin
cp -r ~/build/*/$REPO_NAME $TARGET_DIR/vendor/plugins/$PLUGIN_DIR

#export BUNDLE_GEMFILE=$TARGET_DIR/Gemfile

ruby --version

bundle install --without=$BUNDLE_WITHOUT

echo "creating $DB database"
case $DB in
  "mysql" )
    mysql -e 'create database chiliproject_test;'
    cat > config/database.yml << EOF
test:
  adapter: mysql
  database: chiliproject_test
  username: postgres
EOF
    ;;
  "mysql2" )
    mysql -e 'create database chiliproject_test;'
    cat > config/database.yml << EOF
test:
  adapter: mysql2
  username: root
  encoding: utf8
  database: chiliproject_test
EOF
    ;;
  "postgres" )
    psql -c 'create database chiliproject_test;' -U postgres
    cat > config/database.yml << EOF
test:
  adapter: postgresql
  database: chiliproject_test
  username: postgres
EOF
    ;;
esac

bundle exec rake db:migrate
bundle exec rake db:migrate:plugins
