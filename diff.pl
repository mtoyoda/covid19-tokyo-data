use strict;
use warnings;

my $line = <STDIN>;
print "$line";

my @previtems = ();
while (my $line = <STDIN>) {
    my @items = split /,/, $line;
    my $pub = shift @items;
    my $date = shift @items;
    if (@previtems > 0) {
	print "$pub,$date";
	for (my $i = 0; $i < @items; ++$i) {
	    my $d = $items[$i] - $previtems[$i];
	    print ",$d";
	}
	print "\n";
    }
    @previtems = @items;
}
