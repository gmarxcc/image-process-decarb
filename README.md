Repository for image processing on metalographies using the depth-measurements script.
# Readme #

# General procedure #
- Insert a segmented line (line width 1,000 - 1,500 spline fit activated)
- Straighten process
- save image
- 8-bit conversion used
- Median filter and define radius (`r`)
- Statistical region merging segmentation (SRMS); define `Q` value
- Wand tool; tolerance 5-10
- Create mask
- Create selection
- Revert straighten image to original
- Mix images to compare (Shift -E)
- Run `depth-measurement.ijm` macro (version of this branch measures vertical thickness)

# Methodology #
The methodology is to vary the `Q` and `r` values to observe improvements in selectivity next to the total decarburizated zone and the histograms.

## Original files ##
The original files are from the same sample, different zones (four zones).

## Straightening  ##
The straightened images are stores in:
  * `1a1str.png`
  * `1a2str.png`
  * `1a3str.png`
  * `1a4str.png`

## Radius fixed r=9 and Q varies(4,8,16,32 and 64) ##
In this part the median filter radius `r` is fixed to 9 and `Q` is varied by

``` javascript
//run("Straighten...")
run("8-bit");
run("Median...", "radius=9")
run("Statistical Region Merging","q=4 showaverages");
//run("Versatile Wand Tool", " 10, 0, 5 8-connected include")
```

therefore, the `q=4` value has to be changed every time in a the previously selected zone.

The output files are named with the next convention: `XaYrWQZ.png`, here `X` is the number of specimen (zone), `Y` is the zone of the specimen, `W` is the radius value in pixels (eg 9), and `Z` is the value of `q`(in this case 4). An example of nomenclature is the file `1a1r9Q4.png`.

**The same treatment was done for other r values (6 and 3), sweeping the Q value.**

## Manual measurements ##

The general procedure consist of:

  * Set scales based on 100um image
  * Measure 10um line (value aprox is 171-172 pxs; 171 was used)
  * 10 manual measurements along the total decarburizated zone
  * The resulting 11 measurements are stored into CSV file, like `manual-1aX`, where `X` is the zone number

## Automatic measurements ##
The automatic measurements are done with `r=3` and testing values of `Q` at 22 and 25. In this range total decarburizated zones are best selected.
**The final values are `r=3` and `Q=25`**



# Manual measurements #

  * Measure the scale inserted over the original image at the right-bottom area
  * The `set-scale` command was used with 171.5 px as known 100um distance in micrometers as unit of length
  * Obtain at less 10 measurements (representative measurements)
