include_recipe "applications::default"
# include_recipe "applications::apache"
# include_recipe "applications::postgresql"

if platform?('mac_os_x')

  applications_tap "josegonzalez/php"
  applications_tap "homebrew/dupes"

  # shut down current php-fpm
  ["homebrew-php.josegonzalez.php55.plist"].each do |plist|
    plist_path = File.expand_path(plist, File.join('~', 'Library', 'LaunchAgents'))
    if File.exists?(plist_path)
      log "php55-fpm plist found at #{plist_path}"
      execute "unload plist (shutdown the daemon)" do
        command %'launchctl unload -w #{plist_path}'
        user node['current_user']
      end
    else
      log "Did not find plist at #{plist_path} don't try to unload it"
    end
  end

  # create dir
  [ "/Users/#{node['current_user']}/Library/LaunchAgents" ].each do |dir|
    directory dir do
      owner node['current_user']
      action :create
    end
  end


  package "php55" do |variable|
    options "--with-fpm"
  end

  %w[ php55-xdebug ].each do |pkg|
    package pkg do
      action [:install, :upgrade]
    end
  end

  template "/usr/local/etc/php/5.5/conf.d/99-somni.ini" do
    source "php90somni.erb"
    owner node['current_user']
    mode "0644"
  end
  
  execute "copy over the plist" do
    command %'cp /usr/local/Cellar/php55/5.*/homebrew.josegonzalez.php55.plist ~/Library/LaunchAgents/'
    user node['current_user']
  end

  execute "start the php55-fpm daemon" do
    command %'launchctl load -w ~/Library/LaunchAgents/homebrew.josegonzalez.php55.plist'
    user node['current_user']
  end

end
