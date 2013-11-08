include_recipe "applications::default"

package "emacs" do
  options "--cocoa --use-git-head"
  action [:install, :upgrade]
end
