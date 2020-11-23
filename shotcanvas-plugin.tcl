# META NAME canvasIE
# META DESCRIPTION canvas import export:  load a png as patch background, export patch as png, save an svg file embedding that image 
# META AUTHOR <Lazzaro Ciccolella> lazzarocicco@gmail.com

package require Tcl 8.5
package require Tk
package require pdwindow 0.1
package require Img
source $::current_plugin_loadpath/shotcanvas-svgcontainer.tcl


## per user editable vars

## folder where the plugin/user load/save images (images for use with this plugin)
set img_folder "$env(HOME)/Pd/img"

##if you have gimp or inkscape installed it should open when the image creation is complete
##set edit_program gimp
set edit_program inkscape

## END per user editable vars


##list of patchwindows active
set caricati {}

## when a patchwindow is focused test if it is an already loaded window or a new window
proc test_file {object name_patch} {
	if {[file extension $name_patch] == ".pd"} {
		set root_name [file root $name_patch]
		set path_file_img "$::img_folder/$root_name.png"
		if {[file exists $path_file_img]} {
		##load  the image as background if a png file with the same name as the patch is found in the "img_folder" folder
		##example if pd file is: mypd_patch.pd 
		##the image must be img_folder/mypd_patch.png
			$object.c create image 0 0 -anchor nw -image [image create photo ddd -file $path_file_img]
			puts "loaded $path_file_img as background (canvas)"
		}
	}
}

##add a patchwindow id to list "caricati" if it is not already in.
proc collect {mytop} {
	set pos_list [lsearch -all $::caricati $mytop]
	if {$pos_list >= 0} {
	#	puts "esiste"
	} else {
	#	puts "non esiste"
		lappend ::caricati $mytop
		#puts "lista: $::caricati"
		# qui carichi l'immagine
		set name_patch $::windowname($mytop)
		::test_file $mytop $name_patch
	}
}


##exclude from the list "caricati" if if the patchwindow has been closed (bind PatchWindow <Destroy>)
proc espungi {mytop} {
	set idx [lsearch $::caricati $mytop]
	set ::caricati [lreplace $::caricati $idx $idx]
	#puts "lista: $::caricati"
}


# NOT used by now
## another procedure to verify the existence of a patchwindow (testing the variable into array "::loaded")
proc controlla {} {
	foreach var $::caricati {
		if {[info exists ::loaded($var)]} {
    		#	puts "ancora in carica $var"
		} else {
		#	puts "zoombie $var"
			set idx [lsearch $::caricati $var]
                        set ::caricati [lreplace $::caricati $idx $idx]
			puts "lista: $::caricati"
		#	puts "TOT finestre viventi: [llength $::caricati]"
		}
	}
}
#not used end

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

bind PatchWindow <FocusIn>  {+::collect %W; .menubar entryconfigure last -state normal -command "scatta %W"}
bind PatchWindow <Destroy>  {::espungi %W}
bind PdWindow    <FocusIn>  {.menubar entryconfigure last -state disabled}
## if you run pd from command line: closing the PDwindow first of the Patchwindows the other bindings keeps the terminal open, this (bind PatchWindow <Destroy> break) prevents
bind PdWindow    <Destroy>  {bind PatchWindow <Destroy> break}

## add the menu item (if there are no other plugins manipulating the main menu this should be the last item, and in the above ".menubar entryconfigure" we use last 
.menubar add command -label "shotcanvas" -state disabled
