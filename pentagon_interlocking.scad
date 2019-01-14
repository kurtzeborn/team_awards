$fn = 50;

//========================================VARIABLES=========================================
//------------------------------------THINGS TO CHANGE--------------------------------------
//things to change!! -- engraving
margin = 3; //margin between the edge of the shape and the engraving
engrave = 1; //height of engraving

//things to change!! -- main shape
s = 5; //number of sides of the main shape
lgside = 40; //2*sr*sin(internal/2); //sidelength of encapsulating shape
smside = 1.0*lgside; //now it's just how much sidelength teeth should span
lr = 4; //radius of rounding lumps and thus thickness of the whole shape!
rimw = 7; //rim width of face (there's a hole)

//things to change!! -- interconnecting teeth
xspace = 0.3; //extra space between teeth so they mesh--0.3 is tight but doable on TAZ
lxspace = 0.0; //extra space between lump and fitting
teethn = 4; //teeth per side. caaan be changed, but linkining lumps only work with 4 
tlrad = 0.5; //teeth lump radius (use xspace for more space)
tlength = 6; //length of teeth from center of two curves 6
lumpscale = [2, 2, 1]; //scale set for connecting bumps

//---------------------------------MORE OR LESS CONSTANTS-----------------------------------
//more or less constants for main shape
theta = (s-2)*180/s;
internal = 360/s; //internal angle
sr = lgside/(2*sin(internal/2)); //20 //radius of the connecting shape
t = sr - cos(theta/2)*2*lr; //how much to translate the rounding lump with certain rads
t2 = sr*sin(theta/2) - lr + 0.1; //for moving faces
small = 0.01; //small number!
oldsmside = 2*t*sin(internal/2);  //sidelength of shape that fits inside
dodec = 116.56; //dihedral angle of dodecahedron
apothem = tan(theta/2)*lgside/2;//(sr - lr)*cos(internal/2); //apothem of n-gon
bighole = 30; //a big hole dimension. for making a big hole. 
holeapothem = apothem - rimw; //apothem of hole 
holerad = holeapothem/sin(theta/2); //radius of hole in faced

//interconnecting teeth time yay
tthick = smside/((teethn + xspace)*2); //tooth thickness
twidth = (smside - (teethn*2-1)*xspace)/(teethn*2); //tooth width (updated tthick)


//=======================================MODULES============================================
//------------------------------------SINGLE TEETH------------------------------------------
module cornertooth() { //round part is quarter circle, flat on bottom
  linear_extrude (height = twidth) {  //used to be tthick
    translate ([tlength/2, 0])
      square ([tlength, lr], center = true);
    translate ([tlength, 0])
      circle (lr/2);
    translate ([tlength, 0])
      square (lr/2, center = false);
  }//l_e
}//cornertooth


//-------------------------------------LINKING POINTS---------------------------------------
module holelumps() { //will only work for "four teeth" - eight interlocking total
  translate ([tlength, 0, twidth]) //can add +xspace/2 for actual centering. 
    scale (lumpscale)  
      sphere (tlrad);
  translate ([tlength, 0, twidth*3 + xspace*2]) //here and later on too. 
    scale (lumpscale)
      sphere (tlrad);
  translate ([tlength, 0, twidth*6 + xspace*6]) //here and later on too. 
    scale (lumpscale)
      sphere (tlrad);
}//holelumps

module holedents() {
  translate ([tlength, 0, twidth*2 + xspace*2])
    scale (lumpscale)
      sphere (tlrad + lxspace);
  translate ([tlength, 0, twidth*5 + xspace*4])
    scale (lumpscale)
      sphere (tlrad + lxspace);
  translate ([tlength, 0, twidth*7 + xspace*6])
    scale (lumpscale)
      sphere (tlrad + lxspace);
}//holedents


//-------------------------------------LINE OF TEETH----------------------------------------
module cornerteeth() {
  for (i = [0 : teethn - 1]) {
    translate ([0, 0, i*2*(twidth + xspace)])
//    color ([1, 0, i*1/teethn, 0.5])
      cornertooth();
  }//for
}//cornerteeth2

module cornerteethlinked() {
  difference() {
    cornerteeth();
    holedents();
  }//difference
  holelumps();
}//cornerteethlinked


//----------------------------------TEETH COVERED SIDES-------------------------------------
module cornerlinkjaws() {
  for (i = [0 : s - 1]) {
    rotate ([0, 0, internal*i + internal/2])
      translate ([apothem - small, -smside/2, lr/2])
        rotate ([-90, 0, 0])
          cornerteethlinked();
  }//for
}//cornerlinkjaws


//----------------------------------MIDDLES OF SHAPES--------------------------------------- 
module simpleface() {
  linear_extrude (height = lr) {
    circle (sr, $fn = s);
  }//l_e
}//face

module fancyface1() {
  difference () {
    simpleface();
    translate ([0, 0, -bighole/2])
      linear_extrude (height = bighole) {
        circle (holerad, $fn = s);
      }//l_e
  }//diff
}//fancyface1

module showbadge(image, datetext) {
  rotate ([0, 0, internal + internal/2])
    translate ([apothem - margin, -smside/2, lr/2])
      rotate ([0, 0, 90])
        translate ([twidth*8/2, 0, 0]){
          translate ([-twidth*12/4, twidth*12/4, 0])
            resize ([twidth*12/2, twidth*12/2, lr/2+engrave])
              linear_extrude (height=lr/2+engrave)
                import (image);
          linear_extrude (height = lr/2+engrave)
            text (datetext, font = "Liberation Sans", size = 5, halign="center");
        }//translate
}//showbadge

//---------------------------------UNITS OF FACE AND TEETH----------------------------------

module cornerunit1() {
  fancyface1();
  cornerlinkjaws();
}//cornerunit1

module award() {
  simpleface();
  cornerlinkjaws();
  showbadge("images\\Azure_Service_Bus.dxf", "01/2019");
}//award

//========================================DISPLAY===========================================


award();


/*========================================NOTES=============================================

 - make the unit() a module that you hand a number of sides: unit(sides). 
   might be weird bc of layers of nested modules. 
 - round the teeth all the way around
 - round the hole taken out of the shape
   my fingers hurt from popping together these sharp-edged creatures. 
 - make a thing that lets user choose how many teeth and lumps it appropriately
 - make something for the corners? an insert would look good, but won't be as fun. 
*/
