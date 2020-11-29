![sreendhot](banner_shotcanvas.png)

shotcanvas
==========

Puredata plugin
----------------

Create a PNG snapshot of canvas (What you see in your pd patch), creates a svg file that only embed the png image you created, there are no shapes, paths or other vector elements. Automatically loads a png with the same name as the pd file and places it in your patch as a background.

Programming language: Tcl/Tk.

Dependency: Img (a Tk extension library) 
> The plugin is designed to work with decent qualityes images, so the [Tk Img library](http://tkimg.sourceforge.net/) must be in your system.

Plugin features:

- save png (snapshot of your pd patch)
- load png (background image for your pd patch)

save png
--------
> Create a **PNG** screnshot of a focused patchwindow (only the canvas, not the frame) 

A new menu item (**shot**) appear in the main pd menu (it is active only in patchwindows).
Click on that button (create png) to create a screenshot of the focused patch. The screenshot (in **PNG** format) include everything in the patch: objects, wires etc. as you see it (the patch can be in edit mode or not). NB Only the content you see will be saved, if you have resized the patch window and some objects are hidden, they will not be saved in the image.

You will find the screenshot in \<your home dir>/Pd/img/.
>You can change this behavior by editing the value of "img_folder" variable on the top of the main plugin file (shotcanvas-plugin.tcl).

Also a **SVG** file is created, you can find it in the same directory.
>NB, **the SVG file is a simple container** of the png image, it does not contain paths, shapes or other vector elements.

Finally the procedure opens the SVG file with **inkscape** (you must have it already installed).
>you can change program by setting the value of "**edit_program**" variable on top of the main plugin file (shotcanvas-plugin.tcl).

load png
--------

If you have a patch called mypatch.pd and put a png image called mypatch.png in the \<your home dir>/Pd/img/ folder, the png image will become the background of your patch


Install
-------

Copy [shotcanvas-plugin.tcl](shotcanvas-plugin.tcl) and [shotcanvas-svgcontainer.tcl](shotcanvas-svgcontainer.tcl) to \<your home directory>/pd-externals.
> this may change, please, refer to the PD documentation.

basically:
1) shotcanvas-plugin.tcl and shotcanvas-svgcontainer.tcl must be on the same level in a directory where pd looks
2) don't rename the files

Author
-----
Lazzaro Nicolò Ciccolellla

License
-------
*shotcanvas* is *open source software*: [LICENSE](LICENSE)

>Have fun

Reference:
----------
- [puredata](https://puredata.info/)
- [Tcl Tk](https://www.tcl.tk/)
