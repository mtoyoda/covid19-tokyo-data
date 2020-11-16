use strict;
use warnings;
use utf8;
use Encode;
use POSIX;
use JSON::XS;

binmode STDOUT, "encoding(utf8)";

my @districts = ();
my %date_district_num = ();

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

    for my $data (@{$json}) {
	my $date = $data->{date};
	$date =~ m#(\d+)/(\d+)/(\d+)#;
	$date = sprintf("%04d/%02d/%02d", $1, $2, $3);

	@districts = ();
	my @dists = @{$data->{datasets}};
	for my $d (@dists) {
	    my $label = $d->{label};
	    my $count = $d->{count};
	    push @districts, $label;
	    $date_district_num{$date}->{$label} = $count;
	}
    }
}


read_file(shift @ARGV);

print "Published,Date";
for my $d (@districts) {
    print ",$d";
}
print "\n";

for my $date (sort (keys %date_district_num)) {
    print "$date,$date";
    for my $d (@districts) {
	print ",$date_district_num{$date}->{$d}";
    }
    print "\n";
}
