package Tags::HTML::Image::Grid;

use base qw(Tags::HTML);
use strict;
use warnings;

use Class::Utils qw(set_params split_params);
use Error::Pure qw(err);
use List::MoreUtils qw(none);
use Unicode::UTF8 qw(decode_utf8);

our $VERSION = 0.01;

# Constructor.
sub new {
	my ($class, @params) = @_;

	# Create object.
	my ($object_params_ar, $other_params_ar) = split_params(
		['css_image_grid', 'title'], @params);
	my $self = $class->SUPER::new(@{$other_params_ar});

	# Form CSS style.
	$self->{'css_image_grid'} = 'image-grid';

	# Form title.
	$self->{'title'} = undef;

	# Process params.
	set_params($self, @{$object_params_ar});

	# Object.
	return $self;
}

# Process 'Tags'.
sub _process {
	my ($self, $images_ar) = @_;

	$self->{'tags'}->put(
		['b', 'div'],
		['a', 'class', $self->{'css_image_grid'}],
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
		if ($image->comment) {
			$self->{'tags'}->put(
				['b', 'div'],
				['a', 'class', 'item'],
			);
		}
		$self->{'tags'}->put(
			['b', 'img'],
			['a', 'src', $image->image],
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
	}
	if (defined $self->{'title'}) {
		$self->{'tags'}->put(
			['e', 'fieldset'],
		);
	}
	$self->{'tags'}->put(
		['e', 'div'],
	);

	return;
}

sub _process_css {
	my $self = shift;

	$self->{'css'}->put(
		['s', '.'.$self->{'css_image_grid'}],
		['d', 'display', 'grid'],
		['d', 'grid-gap', '10px'],
		['d', 'grid-template-columns', 'repeat(auto-fit, minmax(150px, 1fr))'],
		['e'],

		['s', '.'.$self->{'css_image_grid'}.' img'],
		['d', 'width', '100%'],
		['e'],

		['s', '.'.$self->{'css_image_grid'}.' .item'],
		['d', 'position', 'relative'],
		['d', 'overflow', 'hidden'],
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

