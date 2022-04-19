run("8-bit");
run("Median...", "radius=3");
run("Statistical Region Merging", "q=4 showaverages");
setKeyDown("shift");
//main zones selection
doWand(161, 721, 10.0, "8-connected");
doWand(269, 712, 10.0, "8-connected");
doWand(313, 750, 10.0, "8-connected");
doWand(505, 713, 10.0, "8-connected");
doWand(709, 716, 10.0, "8-connected");
doWand(752, 694, 10.0, "8-connected");
doWand(2400, 738, 10.0, "8-connected");
//upper limit zones selection
doWand(2464, 694, 10.0, "8-connected");
doWand(1493, 712, 10.0, "8-connected");
doWand(848, 692, 10.0, "8-connected");
doWand(1244, 692, 10.0, "8-connected");
doWand(1760, 702, 10.0, "8-connected");
doWand(2082, 702, 10.0, "8-connected");
doWand(2365, 698, 10.0, "8-connected");
doWand(1856, 698, 10.0, "8-connected");
setKeyDown("none");
run("Create Mask");