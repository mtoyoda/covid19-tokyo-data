use strict;
use warnings;
use utf8;
use Encode;
use POSIX;
use JSON::XS;

binmode STDOUT, "encoding(utf8)";

my @cities = ();

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
    my $published = $json->{date};
    my $date = $json->{datasets}->{date};
    $date =~ m#(\d+)/(\d+)/(\d+)#;
    $date = sprintf("%04d/%02d/%02d", $1, $2, $3);

    @cities = ();
    my @data = @{$json->{datasets}->{data}};
    my %hash = ();
    for my $d (@data) {
	my $label = $d->{label};
	push @cities, $label;
	my $count = $d->{count};
	$hash{$label} = $count;
    }
    return ($published, $date, \%hash);
}

my $first = 1;

while (my $line = <STDIN>) {
    chomp $line;
    my ($pub, $date, $href) = read_file($line);
    if ($first == 1) {
	$first = 0;
	print "Published,Date";
	for my $c (@cities) {
	    print ",$c";
	}
	print "\n";
    }

    print "$pub,$date";
    for my $c (@cities) {
	print ",$href->{$c}";
    }
    print "\n";
}
