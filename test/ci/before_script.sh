#!/bin/sh

echo "=== pwd"
pwd

echo "=== TEMPORARY HACK: downgrade gems due to Gem.source_index"
gem update --system 1.8.25

# Prepare ChiliProject
if [ "x$MAIN_ARCHIVE" != "x" ]; then
  echo "=== Downloading main project as tarball"
  wget $MAIN_ARCHIVE
  mkdir -p $TARGET_DIR
  tar -xf *.tar.gz --strip 1 -C $TARGET_DIR
else
  echo "=== Downloading main project as shallow clone"
  git clone --depth=100 $MAIN_REPO $TARGET_DIR
  #git submodule update --init --recursive
fi
cd $TARGET_DIR

# Copy over the already downloaded plugin
echo "=== Copying over plugin"
cp -r ~/build/*/$REPO_NAME $TARGET_DIR/vendor/plugins/$PLUGIN_DIR

#export BUNDLE_GEMFILE=$TARGET_DIR/Gemfile

ruby --version

echo "=== Running main project's bundle"
bundle install --without=$BUNDLE_WITHOUT

echo "=== Creating $DB database"
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

echo "=== Migrating main project"
bundle exec rake db:migrate
echo "=== Migrating plugins"
bundle exec rake db:migrate:plugins
