use strict;
use warnings;

my @commit_ids = ();

open my $commits_file, "<", shift @ARGV;
while (my $line = <$commits_file>) {
    chomp $line;
    my ($dummy, $commitid) = split qq{ }, $line;
    push @commit_ids, $commitid;
}
close $commits_file;

@commit_ids = reverse @commit_ids;

# skip to the third commit of "data/patient.json"
while ($commit_ids[0] ne "8ad9650f08b582b0a755d7f7e92115d37f22a6a9") {
    shift @commit_ids;
}

my $idx = 1;
my $idxstr = "";
for my $cid (@commit_ids) {
    system("git checkout $cid data/patient.json");
    if (-e "data/patient.json") {
	if ($idxstr ne "") {
	    my $diff = `diff data/patient.json ../district-wise-patients/json/patient.json$idxstr`;
	    if ($diff eq "") {
		#print STDERR "skip $cid\n";
		next;
	    }
	}
	$idxstr = sprintf(".%04d.$cid", $idx);
	system("cp -p data/patient.json ../district-wise-patients/json/patient.json$idxstr");
	++$idx;
    }
}
