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

    my @data = @{$json->{patients_summary}->{data}};

    for my $d (@data) {
	my $date  = $d->{日付};
	$date =~ m#(\d\d\d\d)-(\d\d)-(\d\d)#;
	$date = sprintf("%04d/%02d/%02d", $1, $2, $3);
	my $count = $d->{小計};
	print "$date,$count\n";
    }
}

read_file(shift @ARGV);
