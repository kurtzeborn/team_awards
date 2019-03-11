## Prerequisites
- [OpenSCAD](http://www.openscad.org/downloads.html)
  - Download the latest development snapshot, not the download links on top (which haven't been updated since 2015)
- [Inkscape](https://inkscape.org/)
- [Inkscape Extention](https://www.thingiverse.com/thing:14221) - for exporting DXF files from InkScape
  - [GitHub repo](https://github.com/brad/Inkscape-OpenSCAD-DXF-Export)
- Alternative: [Inkscape Extention](https://github.com/l0b0/paths2openscad) - paths2openscad

## Steps using OpenSCAD DXF Export
1. Open monochrome svg in InkScape
2. File->Save As... "OpenSCAD DXF Output (*.DXF)"
   - Note: this failed one time because the .svg file didn't have a *hight* attribute specified in the root <svg/> element.  I had to add one myself to get it to work.
3. Open pentagon_interlocking.scad in OpenSCAD and 

## Helpful links/tutorials
- [From PNG all the way to 3D Print](https://cubehero.com/2013/11/11/how-to-generate-extruded-3d-model-from-images-in-openscad/)
- [Older Instructable](https://www.instructables.com/id/Make-a-3D-print-from-a-2D-drawing/)
