%w(
  libcurl4-openssl-dev
  libicu-dev
  libmcrypt-dev
  libpng-dev
  libxml2-dev
  libxslt-dev
  zlib1g-dev
).each do |name|
  package name do
    action :install
  end
end

VERSION = '5.6.31'
FILE_NAME = "php-#{VERSION}"

execute "wget http://jp2.php.net/get/#{FILE_NAME}.tar.gz/from/this/mirror"
execute "tar -zxvf #{FILE_NAME}.tar.gz"

configure_command = <<-EOF
  ./configure --prefix=/usr/loca/stow/#{FILE_NAME} \
    --enable-mbstring \
    --with-mysql \
    --with-pdo-mysql \
    --with-mysqli \
    --enable-fpm \
    --with-fpm-user=nginx \
    --with-fpm-group=nginx \
    --with-openssl
EOF

[configure_command, 'make', 'make install'].each do |cmd|
  execute cmd do
    cwd FILE_NAME
  end
end

execute "stow -Rv #{FILE_NAME}" do
  cwd '/usr/local/stow'
end

execute "rm -rf #{FILE_NAME}"
