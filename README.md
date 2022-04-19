# Readme #

The present repository includes images, scripts and steps to process digital metallographs using the depth-measurements script for ImageJ. To run the scripts for each stage Image2 ver or Fiji ver are required. 

The next sections explain the general procedure to prepare images for measurements and a basic statistical analysis by using ImageJ commands and scripts.

# General procedure #
The procedure consists of three main stages: preprocess, segmentation and measurement; details are given in next section. The general aim is to prepare the metallographs to apply segmentation by the median filter and the statistical region merging ImageJ's tools. Finally, a basic script is run to measure the vertical depth measure over the resulting segmented zones. 

Thus, to follow this guide, the repository includes four metallographs from a AISI-1045 decarburized specimen. The images are:

  * `1a_1_5x_D.png`
  * `1a_2_5x_D.png`
  * `1a_3_5x_D.png`
  * `1a_4_5x_D.png`

  Below is shown the `1a_4_5x_D.png` image; *images include at the right-bottom side, the scale calibration rule*.

![Original image](1a_3_5x_D.png)

  # Preprocess stage #
  Open one of the included metallographs by pressing `Ctr-O` or click on `File -> Open` and select the file image. Then, in order to make reproducible steps follow the next series of small ImageJ scripts (macros) to follow and obtain the same results. First, open the preprocess macro by click on `Plugins -> Macros -> Run` and select the `preprocess.ijm` file. 

The contents if this macro is shown below: 

``` javascript
setTool("polyline");
run("Line Width...", "line=1500");
makeLine(4,440,324,388,572,360,756,342,1012,334,1268,340,1522,338,1734,354,1952,380,2150,402,2350,422,2556,450);
run("Straighten...");
```
the script enables the **segmented line** and define its line width at 1500 to cover a large region for the segmentation stage. The `makeLine` command, creates a segmented line with coordinates `(x1, y1, x2, y2, x3, y3, ..., xn, yn)`; each pair of coordinates will be connected to created a *n* segments line. Next,the `run("Straighten...");` command will apply the straighten process to create an horizontal image to apply the segmentation stage.

**Notice that this stage is not required if image is already prepared**. The resulting image is shown below:

![Result of preprocess stage](str.png)

# Segmentation stage # 
The segmentation applies the median filter and SRM process over the previous resulting image. In this example, the segmented zones are similar to the total decarburized zones.

**Notice that segmented zones selectivity depends on the values of r and Q; median filter and SRM.**

The contents of `segmentation.ijm` is listed below:

``` javascript
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
```

The `run("8-bit")` command converts the original image to gray-scale. Next, the `run("Median...", "radius=3")` applies the median filter with a window radius of 3 pixels. Then, the SRM is instructed by `run("Statistical Region Merging", "q=4 showaverages")` command; in this case a *Q* value of 4 is used. To learn about the selectivity of both, *r* and *Q* values, please refer to [^1]. The `showaverages` option allows to create statistically similar zones that enhance the selection in next steps.

Finally, the `Wand` tool is used to pick the regions of interest to measure. This can be done by manual pick (using the mouse), or as in this case, to make reproducible measurements by using code. The `doWand(161, 721, 10.0, "8-connected")` command is equivalent to click  with the mouse pointer at coordinates *(161, 721)*, with tolerance of 10 (about the picked intensity value), and the option `8-connected` considers the 8 neighbor pixels. 

Additionally, the `setKeyDown("shift")` and `run("Create Mask")` commands allow to pick multiple zones and add them to the final selection; similar to hold the `shift` key in ImageJ.

The resulting segmented zone (left, before apply the `Create Mask` command) and its comparison with the original image (right, straightened image) is shown next:

![srm comparison](srm.png)

The final mask is shown next:

![Resulting mask](Mask.png)

# Measurement stage #

``` javascript
doWand(742, 702);
//Setting configuration:
run("Clear Results"); 
run("Set Measurements...", "  bounding stack limit display redirect=None decimal=3"); 
//Warning: Set Scale comman must be ajusted considering:
// distance is the value in pixels of the know distance, 
// here 172.5px are equivalen to 100um at 5X zoom
run("Set Scale...", "distance=171.5 known=100 pixel=1 unit=um"); 
//run("Scale Bar...", "width=50 height=5 font=50 color=White background=Black location=[Lower Right] bold serif overlay label");
run("To Bounding Box"); 
run("Reslice [/]...", "output=1.000 start=Left avoid");  //start=Top (Horizontal slices), start=Left(vertical measurements)
run("Analyze Particles...", "circularity=0.0-1.00 show=Nothing display clear stack include in_situ"); 
//Measuring:

// Check slice number 
getDimensions(x,y,c,z,t); 
theWidth = newArray(z); 
//print("Number of Slides:", z);
name=getTitle(); 
//Width of each particle on slide
for (i=0;i<nResults;i++) { 
        tmpW = getResult("Width", i); 
        slice =  getResult("Slice", i); 
        theWidth[slice-1]+=tmpW*(1); 
} 
//Results:
Pos=newArray(z);
Thick=newArray(z);
run("Clear Results"); 
for (i=0;i<z;i++) { 
        setResult("Label", i, name); 
        setResult("Position", i, i+1); 
        Pos[i]=i+1;
        Thick[i]=theWidth[i];
        setResult("Thickness", i, theWidth[i]); 
}
//Plotting results:
run("Summarize");
meanThick=newArray(z);
//Distribution:
run("Distribution...","parameter=Thickness");
//xPos=newArray(1);
//xPos=1;
meanTemp=getResult("Thickness",(nResults-4));
for (i = 0; i < z; i++) {
  meanThick[i]=meanTemp;}
Plot.create("Fancier Plot", "Position", "Thickness[um]");
//Plot.setLimits(0, 5, 0, 3);
Plot.setLineWidth(1.4);
Plot.setColor("Black");
Plot.add("Circles", Pos, Thick);
Plot.setColor("red");
Plot.setLineWidth(1.7);
//Plot.add("line",meanThick)
Plot.show();
```



- Insert a segmented line (line width 1,000 - 1,500 spline fit activated)
- Straighten process
- Save Straightened image
- Apply 8-bit conversion
- Apply the median filter with radius (`r`)
- Apply statistical region merging segmentation (SRMS) with `Q` value
- Use the wand tool to select the resulting zones; tolerance 5-10
- Create mask
- Create selection
- Revert straighten image to original
- Mix images to compare (Shift -E)
- Run `depth-measurement.ijm` macro (version of this branch measures vertical thickness) to obtain measurements 


   

## Straightening  ##
The resulting images after straightened images are stores in:
  * `1a1str.png`
  * `1a2str.png`
  * `1a3str.png`
  * `1a4str.png`


# Methodology #
The methodology is to vary the `Q` and `r` values to observe improvements in selectivity next to the total decarburizated zone and the histograms.


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
