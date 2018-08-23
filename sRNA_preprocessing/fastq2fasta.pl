my $input = shift;
	if (!$input){
	print STDERR "No input file given - exiting\n";
	exit();
	}
open (INPUT, "$input") or die "Can't open input file $input\n";
my $id;
my $nextseq = 0;

$total = 0;
$accept= 0;
$reject= 0;

while (<INPUT>){
	if ($_=~m/^\@(\S+)/){
	$id = $1;
	chomp $id;
	$nextseq=1;
	}
	elsif ($nextseq == 1){
	my $sequence = $_;
	
	$total ++;
	chomp $sequence;
	if(index($sequence,"N") == -1)
	{
		#$sequence1 = substr($sequence,0,50);
		print ">$id\n$sequence\n";
		$accept ++;
	}
	else
	{
#		print STDERR "reject";
		$reject ++;
	}
	$nextseq=0;
	}
}

print STDERR "total : $total \n";
print STDERR "accepted: $accept \n";
print STDERR "rejected: $reject \n";

exit;
