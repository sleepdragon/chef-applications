include_recipe "applications::default"
# include_recipe "applications::apache"
# include_recipe "applications::postgresql"

if platform?('mac_os_x')

    applications_tap "josegonzalez/php"
    applications_tap "homebrew/dupes"

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

end
