# Godot GraphNode manager

# WAIT!!
### This is still a SUPER EARLY project, so expect tons of bugs, missing or incomplete stuff and WAY MORE!

## How to install?
It's pretty easy **if you have [git](https://git-scm.com/) installed**.

If you project is already a [git repo](https://git-scm.com/docs/git-init), type:
```bash
# Be sure to be working in your project's "res://" folder
$ git submodule add https://github.com/wikd-gs/godot-graph-nodes-manager.git addons/graph-manager
```

or if your project is not a git repo ***(HOW DARE YOU)***, type:
```bash
# Still be sure to be working in your project's "res://" folder
$ git clone https://github.com/wikd-gs/godot-graph-nodes-manager.git addons/graph-manager
```

## A complete redesign
So, one day I wanted to make some graph based system, but the nodes that Godot provides looked ugly and really hard to use. So I thought ***Why not to redesign the WHOLE system?***.
Yes, it wasn't a clever decision, **BUT** now I *(sort of)* have a better, more powerful GraphNode editor!

## A smol look at the nodes
- `NewGraphEdit` it's like the old `GraphEdit`, but better. It has *(nearly)* all the stuff you need.

- `NewGraphNode` also like it's older version `GraphNode`, but more configurable.

And that's mostly all the nodes we have and that you'll need.
