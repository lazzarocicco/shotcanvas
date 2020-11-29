# META NAME shotcanvas
# META DESCRIPTION export patch as png, save an svg file embedding that image 
# META AUTHOR <Lazzaro Ciccolella> lazzarocicco@gmail.com

package require Tcl 8.5
package require Tk
package require pdwindow 0.1
package require Img

## shotcanvas-svgcontainer.tcl contain a proc that pus the SVG skeleton inside this script 
source $::current_plugin_loadpath/shotcanvas-svgcontainer.tcl

## per user editable vars

## folder where the plugin/user load/save images (images for use with this plugin)
set img_folder "$env(HOME)/Pd/img"

##if you have gimp or inkscape installed it should open when the image creation is complete
##set edit_program gimp
set edit_program inkscape

## END per user editable vars

puts "----------shotcanvas-plugin---------"
puts "shotcanvas-plugin is a pure data (pd) plugin."
puts "lazzaro Ciccolella 2020 marrongiallo.github.io"
puts "README file for instructions:  https://github.com/marrongiallo/shotcanvas"
puts "----------shotcanvas-plugin---------"

## Dialog: if the image already exists, asks to overwrite yes/no
proc scatta {mytop} {
	set base [file root $::windowname($mytop)]
	set file_to_save_png $::img_folder/$base.png
	set file_to_save_svg $::img_folder/$base.svg
	#sovrascrivere?
	if {[file exists $file_to_save_png]} {
		set answer [tk_messageBox -message "the image $file_to_save_png already exists" -icon question -type yesno -detail "do you want to overwrite it?"]
		switch -- $answer {
			yes {crea_png $mytop $file_to_save_png;crea_svg $mytop $file_to_save_png $file_to_save_svg}
			no {tk_messageBox -message "so, please, save the patch with another name and try again" -type ok}
		}
	} else {
		crea_png $mytop $file_to_save_png
		crea_svg $mytop $file_to_save_png $file_to_save_svg
	}
}

## save the png image
proc crea_png {mytop file_to_save_png} {
	image create photo theCanvas -format window -data $mytop.c
	theCanvas write $file_to_save_png -format png
	puts "hai creato l'immagine: $file_to_save_png"
}

## save the svg file NB: the svg file is a simple container of the png image, it does not contain paths, shape or other vector elements.
## It use a svg skeleton that you can find in shotcanvas-svgcontainer.tcl
proc crea_svg {mytop image_to_contain file_to_save_svg} {
	set height [winfo height $mytop.c]
	set width [winfo width  $mytop.c]
	set outputFile [open $file_to_save_svg w]
	## find out (in the same direcotry) the procedure "svg_container" in svg_container.tcl   
	svg_container $width $height $image_to_contain
	## NON CANCELLARE "puts $outputFile $::XML" (la riga seguente) il puts non serve a scrivere sulla console ma a riempire il file
	puts $outputFile $::XML
	## NON CANCELLARE
	close $outputFile
	puts "hai creato il file svg: $file_to_save_svg"
	exec $::edit_program $file_to_save_svg  &
}
bind PatchWindow <FocusIn>  {.menubar entryconfigure last -state normal -command "scatta %W"}
bind PdWindow    <FocusIn>  {.menubar entryconfigure last -state disabled}

## add the menu item (if there are no other plugins manipulating the main menu this should be the last item, and in the above ".menubar entryconfigure" we use last 
.menubar add command -label "shotcanvas" -state disabled
