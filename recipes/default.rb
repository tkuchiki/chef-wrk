package "make"
package "gcc"
package "gcc-c++"
package "openssl"
package "openssl-devel"

_action  = node[:wrk][:action]
tmp_repo = "#{Chef::Config[:file_cache_path]}/wrk"

git tmp_repo do
  repository node[:wrk][:repository]
  revision   node[:wrk][:revision]
  action     _action.to_sym
end

bash "make wrk" do
  cwd tmp_repo
  code <<EOH
    make
    cp -f wrk #{node[:wrk][:install_dir]}/
EOH

  not_if { File.exists?("#{node[:wrk][:install_dir]}/wrk") }
end

directory tmp_repo do
  recursive true
  action    :delete
end
