# Generic_robotics_structure
Testing the architecture designed for robotics systems, where catkin workspaces are used for each independent sub-system.
This work is aimed to design and prove an effective way of building catkin workspaces that can inherit messages from each other, without having to define custom messages in each required workspace.
Instead, we would have an inheritance principle taking effect, where the parent workspace holds all shared information, and the child workspaces hold their own definitions.

In this example, UI and DM are the children.

