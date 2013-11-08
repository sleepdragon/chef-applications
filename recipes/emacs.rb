include_recipe "applications::default"

package "emacs" do
  action [:install, :upgrade]
end
