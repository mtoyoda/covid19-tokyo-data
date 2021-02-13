use strict;
use warnings;
use utf8;
use Encode;
use POSIX;
use JSON::XS;

binmode STDOUT, "encoding(utf8)";

sub read_file {
    my ($file) = @_;
    open my $f, "<", $file or die;
    my @lines = <$f>;
    my $lines_str = "@lines";
    close $f;

    my $json = undef;
    eval {
	$json = decode_json($lines_str);
    };
    if ($@) {
	print STDERR "JSONERR: $@\n";
	return undef;
    }

    my @data = @{$json->{data}};

    for my $d (@data) {
	my $date  = $d->{diagnosed_date};
	$date =~ s#-#/#g;
	my $count = $d->{count};
	print "$date,$count\n";
    }
}

read_file(shift @ARGV);
