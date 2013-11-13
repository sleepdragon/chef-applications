include_recipe "application::default"

package "nginx" do
  action [:install]
end
