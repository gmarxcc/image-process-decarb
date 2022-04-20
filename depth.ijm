doWand(742, 702);
//-=-=-=-=-=-=-=-=-=
//Setting configuration:
run("Clear Results"); 
run("Set Measurements...", "  bounding stack limit display redirect=None decimal=3"); 
// Warning: Set Scale command must be adjusted considering:
// distance is the value in pixels of the know distance, 
// here 171.5px are equivalent to 100um at 5X zoom.
run("Set Scale...", "distance=171.5 known=100 pixel=1 unit=um"); 
// uncomment next line to show the scale bar: 
//run("Scale Bar...", "width=50 height=5 font=50 color=White background=Black location=[Lower Right] bold serif overlay label");
run("To Bounding Box"); 
run("Reslice [/]...", "output=1.000 start=Left avoid");  //use start=Top for Horizontal slices, and start=Left(vertical measurements)
run("Analyze Particles...", "circularity=0.0-1.00 show=Nothing display clear include stack in_situ"); 
//-=-=-=-=-=-=-=-=-=
//Measuring:
// Check slice number 
getDimensions(x,y,c,z,t); 
theWidth = newArray(z); 
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