# Using ROS2 with Neovim

Developing for ROS2 with Neovim works almost out of the box.
To kickstart working with Neovim as an IDE for ROS2, we recommend either
creating your own config based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim),
or using our basic Neovim config tailored for getting started with ROS2,
which can be found [here](https://github.com/Hati-Research/freyr/tree/main/nvim-ros).

In any case, in your Neovim config, you should have installed and working:

* clangd LSP
* pyright LSP (requires working node and npm, to manage these, we recommend
    using [asdf](http://asdf-vm.com))
* treesitter setup for c++ and python

For installation of LSPs, we recommend using [mason](https://github.com/williamboman/mason.nvim).

LSP integration for python works automatically when you open Neovim from a
terminal with sourced ROS2 environment.
In the case of clangd, colcon needs to instruct CMake to export compile commands.
A useful shell alias for doing this is:

```shell
alias cb="colcon build \
    --symlink-install \
    --cmake-args -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
    && source install/setup.zsh"
```
