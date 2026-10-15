package VimHelpGenerator;
use strict;
no warnings;
use Carp;

use Config::IniHash;
use Text::Reform;

my $VERSION = 0.1;

### Constructor ###
sub new {
	my ($proto, $hashref) = @_; # Expects a hashref.
    foreach ( qw/ini_dir help_dir vim/ ) {          # These keys must exist in the hash (mandatory args).
        croak("Missing mandatory argument to new: You must specify a value for $_")
			unless defined $hashref->{$_};
    }
	my $class = ref($proto) || $proto;
    my $self = bless($hashref, $class);
	$self->_init;
	return $self;
}

sub _init {
	my $self = shift;
	foreach my $file ( glob("$self->{ini_dir}/*.ini") ) {
		($self->{output_file} = $file) =~ s#.*/##;
		$self->{output_file} =~ s/\.ini$/.txt/;
		print "Creating vim help file => $self->{output_file}\n";
		$self->_parse_ini_file($file);
		$self->_process_metadata;
		open(FH, "> $self->{help_dir}/$self->{output_file}") or die "Can't write to $self->{help_dir}/$self->{output_file}: $!";
		print FH $self->get_header;
		print FH $self->get_contents;
		print FH $self->get_body;
		close FH;
	}
	$self->update_helptags;
	print "helptags have been updated.\n";
}



### Methods ###

sub get_structure {
	my $self = shift;
	return $self->{structure};
}

sub get_header {
	my $self = shift;
	                                        
	my $output = form '<<<<<<<<<<<<<<<<<<<   ||||||||||||||||||||||||||||||||||           >>>>>>>>>>>',
	"*$self->{output_file}*", @$self{qw/title date/};

	$output .= "\nAuthor: $self->{author}\n\n";
	return $output;
}

sub get_contents {
	my $self = shift;
	my $output;
	foreach (@{$self->{structure}{__SECTIONS__}}) {
		my $i = 1;
		$output .= form '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<', "[ $_ ]\n";
		foreach my $h (@{$self->{structure}{$_}}) {
			(my $first_tag) = split /\s+/, $h->{tags};
			 #$output .= form '<<<<<<<<<<<<<<<<<<<<<<<<<< >>. [[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[',
			 $output .= form '<<<<<<<<<<<<<<<<<<<<<<<<<< >>. [[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[]]',
				"|$first_tag|", $i++, $h->{title};
		}
		$output .=  "=" x 78 . "\n";
	}
	$output .=  "*" x 78 . "\n";
	return $output;
}

sub get_body {
	my $self = shift;
	my $output;
	foreach (@{$self->{structure}{__SECTIONS__}}) {
		my $i = 1;
		$output .= form ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>", "[ $_ ]\n";
		foreach my $h (@{$self->{structure}{$_}}) {
			my @tags = map "*$_*", split /\s+/, $h->{tags};
			$output .= form "$i. <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<      ]]]]]]]]]]]]]]]]]]]]]]]]]]]]", $h->{title}, "@tags";
			$output .= "\n";
			$output .= "$h->{text}\n";
			$output .=  "=" x 78 . "\n";
			$i++;
		}
	}
	return $output;
}

sub update_helptags {
	my $self = shift;
	open(VIM, "|vim -e -s") or die "Couldn't fork and update helptags: $!\n";
	print VIM "helptags $self->{help_dir}\n";
	print VIM "q!\n";
	close(VIM);
};

sub get_metadata {
	my $self = shift;
	return $self->{structure}{__SECTIONS__}
}


### Private Methods ###

# _parse_ini_file uses the forValue callback function documented in Config::IniHash to
# create a hash in which each section is a key that contains an array of values.
# This structure is stored in the object as $self->{structure}.

sub _parse_ini_file {
	my ($self, $file) = @_;
	undef $self->{structure};
	my %opts = (
		heredoc => 1,
		systemvars => 0,
		sectionorder => 1,
		case => 'preserve',
	);

	my $idx;

	$opts{forValue} =  # Callback Function.
	sub {
		my ($name, $value, $sectionname, $INIhashref) = @_;
		unless (exists $self->{structure}{$sectionname}) {
			$idx = 0;
			push @{$self->{structure}{__SECTIONS__}}, $sectionname;
		}
		$self->{structure}{$sectionname}[$idx]{$name} = $value;
		$idx++ if $name eq 'text';
		return undef;
	};

	ReadINI($file, %opts);

	$self->{date} = _english_date(time);
	return $self;
}

sub _english_date {
	my $time = shift;
	my @months = qw/Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec/;
	my ($day, $month, $year) = (localtime $time)[3, 4, 5];
	return sprintf("%s %s %04d", $day, $months[$month], $year+1900);
}


sub _process_metadata {
	my $self = shift;
	if ($self->{structure}{metadata}[0]) { # autovivifies the metadata hash.
		%$self = (%$self, %{$self->{structure}{metadata}[0]});
		shift @{ $self->{structure}{__SECTIONS__} };
	} else {
		@$self{qw/author title/} = ("Leonard Nimoy", "A Brief History of Famous Haircuts");
	}
	delete $self->{structure}{metadata};
	return $self;
}

1;
