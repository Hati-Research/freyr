# Running ROS2 in Distrobox

ROS2 currently supports a limited set of operating systems.
This makes sense from the maintenance standpoint, but greatly complicates things
when upgrading to new ROS/OS version or when you simply don't want to use Ubuntu,
but stick to your fine-tuned Arch installation.

It is possible to run ROS2 in Docker, but setting it up is quite cumbersome.
This is where Distrobox come into play.
Distrobox is a thin wrapper around docker, that provides seamless integration
with the host filesystem, display manager and other hardware.

Let's get started by installing distrobox.

```shell
sudo pacman -S distrobox
```

Now, you can create your first distrobox container.

> We recommend using a different home directory for the container to avoid clashing between tool versionsand their configs.
You can then symlink only parts of your dotfiles to the container.

```shell
distrobox create \
    --name ros2-humble \
    --init \
    --image osrf/ros:humble-desktop 
    --additional-packages "systemd libpam-systemd pipewire-audio-client-libraries" 
    --home $HOME/distrobox/humble
```

This command creates a new container based on the `osrf/ros:humble-desktop`,
sets it up with an `init` system (systemd in this case),
installs some recommended packages and configures it
to use a home directory other than your home directory.

Now, you can start the container using:

```shell
distrobox enter ros2-humble --clean-path --no-workdir
```

The `--clean-path` argument is important as it avoids your local software
to leak into the container.

`--no-workdir` makes the container start in its own directory.

The container welcoms us with a pretty bare ZSH shell.

Let's do some quality of life improvements before starting our first nodes.

We can create and modify the `.zshrc` to source ROS and to set domain id.

```shell
source /opt/ros/humble/setup.zsh
export ROS_DOMAIN_ID=1
```

You can also install an editor and terminal multiplexer.

> Beware of TMUX, there are some defaults that are not quite sane for the purposes of ROS development.

After sourcing the file, you can run your first ROS nodes.

In a first terminal:

```shell
ros2 topic pub /hello std_msgs/String '{"data": "world"}'
```

In a second terminal:

```shell
ros2 topic echo /hello
```

You should see messages being sent over the topic.

To check that GUI apps work, let's also try launching RVIZ.

```shell
ros2 run rviz2 rviz2
```

That is all there is to it, you now have a working distrobox container with ROS.
