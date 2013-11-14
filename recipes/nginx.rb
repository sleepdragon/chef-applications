include_recipe "applications::default"

package "nginx" do
  action [:install]
end
