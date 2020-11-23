proc svg_container {width height imagefile} {
set ::XML "<?xml version='1.0' encoding='UTF-8' standalone='no'?>
<svg
   xmlns:dc='http://purl.org/dc/elements/1.1/'
   xmlns:cc='http://creativecommons.org/ns#'
   xmlns:rdf='http://www.w3.org/1999/02/22-rdf-syntax-ns#'
   xmlns:svg='http://www.w3.org/2000/svg'
   xmlns='http://www.w3.org/2000/svg'
   xmlns:xlink='http://www.w3.org/1999/xlink'
   viewBox='0 0 $width  $height'
   height='$height'
   width='$width'
   id='svg2'
   version='1.1'>
  <metadata
     id='metadata8'>
    <rdf:RDF>
      <cc:Work
         rdf:about=''>
        <dc:format>image/svg+xml</dc:format>
        <dc:type
           rdf:resource='http://purl.org/dc/dcmitype/StillImage' />
        <dc:title></dc:title>
      </cc:Work>
    </rdf:RDF>
  </metadata>
  <defs
     id='defs6' />
  <image
     xlink:href='$imagefile'
     width='$width'
     height='$height'
     preserveAspectRatio='none'
     id='image10'
     x='0'
     y='0' />
</svg>
"
#puts $XML

}
