# nvim-ros

A basic neovim configuration suitable for ROS development based on kickstart.nvim.
See kickstart.nvim docs for basic setup.

For CPP LSP support, build colcon with the following alias

```shell
alias cb="colcon build --symlink-install --cmake-args -DCMAKE_EXPORT_COMPILE_COMMANDS=ON && source install/setup.zsh"
```
