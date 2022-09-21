package Tags::HTML::Image::Grid;

use base qw(Tags::HTML);
use strict;
use warnings;

use Class::Utils qw(set_params split_params);
use Error::Pure qw(err);
use List::MoreUtils qw(none);
use Scalar::Util qw(blessed);
use Unicode::UTF8 qw(decode_utf8);

our $VERSION = 0.01;

# Constructor.
sub new {
	my ($class, @params) = @_;

	# Create object.
	my ($object_params_ar, $other_params_ar) = split_params(
		['css_image_grid', 'img_link_cb', 'img_src_cb', 'img_width',
		'title'], @params);
	my $self = $class->SUPER::new(@{$other_params_ar});

	# Form CSS style.
	$self->{'css_image_grid'} = 'image-grid';

	# Image link callback.
	$self->{'img_link_cb'} = undef;

	# Image src callback across data object.
	$self->{'img_src_cb'} = undef;

	# Image width in pixels.
	$self->{'img_width'} = 340;

	# Form title.
	$self->{'title'} = undef;

	# Process params.
	set_params($self, @{$object_params_ar});

	# Check callback code.
	if (defined $self->{'img_src_cb'}
		&& ref $self->{'img_src_cb'} ne 'CODE') {

		err "Parameter 'img_src_cb' must be a code.";
	}

	# Object.
	return $self;
}

sub _check_images {
	my ($self, $images_ar) = @_;

	foreach my $image (@{$images_ar}) {
		if (! blessed($image)
			# XXX Hardcoded object.
			&& ! $image->isa('Data::Commons::Vote::Image')) {

			err 'Bad data image object.';
		}
	}

	return;
}

# Process 'Tags'.
sub _process {
	my ($self, $images_ar) = @_;

	$self->_check_images($images_ar);

	$self->{'tags'}->put(
		['b', 'div'],
		['a', 'class', $self->{'css_image_grid'}],

		['b', 'div'],
		['a', 'class', $self->{'css_image_grid'}.'-inner'],
	);
	if (defined $self->{'title'}) {
		$self->{'tags'}->put(
			['b', 'fieldset'],
			['b', 'legend'],
			['d', $self->{'title'}],
			['e', 'legend'],
		);
	}
	foreach my $image (@{$images_ar}) {
		if (defined $self->{'img_link_cb'}) {
			$self->{'tags'}->put(
				['b', 'a'],
				['a', 'href', $self->{'img_link_cb'}->($image)],
			);
		}
		if ($image->comment) {
			$self->{'tags'}->put(
				['b', 'div'],
				['a', 'class', 'item'],
			);
		}
		my $image_url;
		if (defined $self->{'img_src_cb'}) {
			$image_url = $self->{'img_src_cb'}->($image);
		} else {
			$image_url = $image->image;
		}
		$self->{'tags'}->put(
			['b', 'img'],
			['a', 'src', $image_url],
			['e', 'img'],
		);
		if ($image->comment) {
			$self->{'tags'}->put(
				['b', 'span'],
				['a', 'class', 'caption'],
				['d', $image->comment],
				['e', 'span'],

				['e', 'div'],
			);
		}
		if (defined $self->{'img_link_cb'}) {
			$self->{'tags'}->put(
				['e', 'a'],
			);
		}
	}
	if (defined $self->{'title'}) {
		$self->{'tags'}->put(
			['e', 'fieldset'],
		);
	}
	$self->{'tags'}->put(
		['e', 'div'],
		['e', 'div'],
	);

	return;
}

sub _process_css {
	my $self = shift;

	$self->{'css'}->put(

		# Grid center on page.
		['s', '.'.$self->{'css_image_grid'}],
		['d', 'display', 'flex'],
		['d', 'align-items', 'center'],
		['d', 'justify-content', 'center'],
		['e'],

		# 4 columns in grid.
		['s', '.'.$self->{'css_image_grid'}.'-inner'],
		['d', 'display', 'grid'],
		['d', 'grid-gap', '1px'],
		['d', 'grid-template-columns', 'repeat(4, '.$self->{'img_width'}.'px)'],
		['e'],

		# Create rectangle.
		['s', '.'.$self->{'css_image_grid'}.' img'],
		['d', 'object-fit', 'cover'],
		['d', 'width', $self->{'img_width'}.'px'],
		['d', 'height', $self->{'img_width'}.'px'],
		['e'],

		['s', '.'.$self->{'css_image_grid'}.' .item'],
		['d', 'position', 'relative'],
		['d', 'overflow', 'hidden'],
		['d', 'border', '1px solid white'],
		['e'],

		['s', '.'.$self->{'css_image_grid'}.' .item img'],
		['d', 'vertical-align', 'middle'],
		['e'],

		['s', '.'.$self->{'css_image_grid'}.' .caption'],
		['d', 'margin', 0],
		['d', 'padding', '1em'],
		['d', 'position', 'absolute'],
		['d', 'z-index', 1],
		['d', 'bottom', 0],
		['d', 'left', 0],
		['d', 'width', '100%'],
		['d', 'max-height', '100%'],
		['d', 'overflow', 'auto'],
		['d', 'box-sizing', 'border-box'],
		['d', 'transition', 'transform 0.5s'],
		['d', 'transform', 'translateY(100%)'],
		['d', 'background', 'rgba(0, 0, 0, 0.7)'],
		['d', 'color', 'rgb(255, 255, 255)'],
		['e'],

		['s', '.'.$self->{'css_image_grid'}.' .item:hover .caption'],
		['d', 'transform', 'translateY(0%)'],
		['e'],
	);

	return;
}

1;

__END__

