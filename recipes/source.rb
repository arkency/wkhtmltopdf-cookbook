cache_dir = Chef::Config[:file_cache_path]
%w(libqt4-gui libqt4-network libqt4-webkit openssl build-essential xorg git-core git-doc libssl-dev).each do |dep|
  package dep
end

execute "Define build dependencies" do
  command "apt-get -y build-dep libqt4-gui libqt4-network libqt4-webkit"
end

git "#{cache_dir}/wkhtmltopdf-qt" do
  repository 'git://github.com/jbothma/wkhtmltopdf-qt.git'
  reference '6053b687d24956d0a7eac21a015172b29cf0f451'
  action :sync
end

execute "Compile wkhtmltopdf-qt" do
  cwd "#{cache_dir}/wkhtmltopdf-qt"
  command "./configure -nomake tools,examples,demos,docs,translations -opensource -confirm-license -prefix ../wkqt && make -j3 && make install"
  creates "#{cache_dir}/wkqt"
end

git "#{cache_dir}/wkhtmltopdf" do
  repository 'git://github.com/antialize/wkhtmltopdf.git'
  reference 'e2333f5ccb3a0bae56ac9ac02e1ce2200c1bc25d'
  action :sync
end

execute "Compile wkhtmltopdf" do
  cwd "#{cache_dir}/wkhtmltopdf"
  command "../wkqt/bin/qmake && make -j3 && make install"
  creates "/bin/wkhtmltopdf"
end