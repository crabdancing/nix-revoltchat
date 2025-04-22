Dumping hundreds of megabytes of garbage from the JS ecosystem into your repo is as easy as 1, 2, 3!

1) Cloning the upstream repo:

```
git clone https://github.com/revoltchat/desktop revolt-desktop
cd revolt-desktop
```

2) Yarn shits in the `.yarn/cache` directory:

```
YARN_ENABLE_IMMUTABLE_INSTALLS=true nix-shell -p yarn --run 'yarn install --immutable'
```

💩

3) We harvest its ecosystem feces, and petrify it. Note that you must define `$DST_DIR` as your destination, i.e., _this_ repo. (which has a `/.yarn/cache` where `/` is our repo root.)

```
rip $DST_DIR/.yarn/cache
rsync -Pas .yarn/cache/ $DST_DIR/
```

Then you simply `cd` to your vendor target (i.e., this repo), `git add .`, commit, and you're done! It's that easy. :D