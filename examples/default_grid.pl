#!/usr/bin/env perl

use strict;
use warnings;

use CSS::Struct::Output::Indent;
use Data::Image;
use Tags::HTML::Image::Grid;
use Tags::Output::Indent;

# Object.
my $css = CSS::Struct::Output::Indent->new;
my $tags = Tags::Output::Indent->new;
my $obj = Tags::HTML::Image::Grid->new(
        'css' => $css,
        'tags' => $tags,
);

# Images.
my $image1 = Data::Image->new(
        'comment' => 'Michal from Czechia',
        'url' => 'https://upload.wikimedia.org/wikipedia/commons/a/a4/Michal_from_Czechia.jpg',
);
my $image2 = Data::Image->new(
        'comment' => 'Self photo',
        'url' => 'https://upload.wikimedia.org/wikipedia/commons/7/76/Michal_Josef_%C5%A0pa%C4%8Dek_-_self_photo_3.jpg',
);

# Process image grid.
$obj->process([$image1, $image2]);
$obj->process_css;

# Print out.
print $tags->flush;
print "\n\n";
print $css->flush;

# Output:
# <div class="image-grid">
#   <div class="image-grid-inner">
#     <figure>
#       <img src=
#         "https://upload.wikimedia.org/wikipedia/commons/a/a4/Michal_from_Czechia.jpg"
#         >
#       </img>
#       <figcaption>
#         Michal from Czechia
#       </figcaption>
#     </figure>
#     <figure>
#       <img src=
#         "https://upload.wikimedia.org/wikipedia/commons/7/76/Michal_Josef_%C5%A0pa%C4%8Dek_-_self_photo_3.jpg"
#         >
#       </img>
#       <figcaption>
#         Self photo
#       </figcaption>
#     </figure>
#   </div>
# </div>
# 
# .image-grid {
# 	display: flex;
# 	align-items: center;
# 	justify-content: center;
# }
# .image-grid-inner {
# 	display: grid;
# 	grid-gap: 1px;
# 	grid-template-columns: repeat(4, 340px);
# }
# .image-grid figure {
# 	object-fit: cover;
# 	width: 340px;
# 	height: 340px;
# 	position: relative;
# 	overflow: hidden;
# 	border: 1px solid white;
# 	margin: 0;
# 	padding: 0;
# }
# .image-grid img {
# 	object-fit: cover;
# 	width: 100%;
# 	height: 100%;
# 	vertical-align: middle;
# }
# .image-grid figcaption {
# 	margin: 0;
# 	padding: 1em;
# 	position: absolute;
# 	z-index: 1;
# 	bottom: 0;
# 	left: 0;
# 	width: 100%;
# 	max-height: 100%;
# 	overflow: auto;
# 	box-sizing: border-box;
# 	transition: transform 0.5s;
# 	transform: translateY(100%);
# 	background: rgba(0, 0, 0, 0.7);
# 	color: rgb(255, 255, 255);
# }
# .image-grid figure:hover figcaption {
# 	transform: translateY(0%);
# }
# .image-grid .selected {
# 	border: 1px solid black;
# 	border-radius: 0.5em;
# 	color: black;
# 	padding: 0.5em;
# 	position: absolute;
# 	right: 10px;
# 	top: 10px;
# }