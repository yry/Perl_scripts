#guess adaptor
#uses the adaptor removal function
#good for datasets where only a small proportion of reads can be retrieved with the standard adaptor

sub trim($);
# Perl trim function to remove whitespace from the start and end of the string
sub trim($)
{
	my $string = shift;
	$string =~ s/^\s+//;
	$string =~ s/\s+$//;
	return $string;
}

use Bio::SeqIO;
use Algorithm::Loops 'NestedLoops';

$usage = "perl remAdp.pl nrNt input out";
$len = shift or die $usage;
#the input is the datset to be tested
$inp = shift or die $usage;
$out = shift or die $usage;

@chars  = ('A','C','T','G');
$get_combo = NestedLoops([ (\@chars) x $len ]);

#create "adaptor sequences"
@combo;
while ( @combo = $get_combo->() ) {
    #print "@combo\n";
	$adaptor = "";
	for($j = 0; $j <= $#combo; $j++)
	{
		$adaptor = $adaptor.trim($combo[$j]);
	}
#	print "ad: $adaptor\n";
#	sleep(1);
	push @ad, [($adaptor)];
}

$totalCount = 0;
$seqs = Bio::SeqIO->new(-format => 'fasta', -file => "$inp");
while (my $seq = $seqs->next_seq ) 
{
	$totalCount++;
	my $sequence = $seq->seq();
	push @sequences, [($sequence)];
}
print "sequences read: $#sequences \n";

#read the file and apply the adaptor removal tool
for($a = 0; $a <= $#ad; $a++)
{
	$accept[$a] = 0;
	print "working with adaptor: $ad[$a][0]\n";
	for($i = 0; $i <= $#sequences; $i++)
	{
		if ($sequences[$i][0] =~m/^(\w+)($ad[$a][0]\w+)$/)
		{
			my $processed_seq = $1;
			my $adaptor = $2;
			if (length($processed_seq) > 16)
			{
				#print ">$id\n$processed_seq\n";
				$accept[$a]++;
			}
		}
	}
	print "accepted: $accept[$a]\n";
}

open out, ">".$out
	or die "cannot open output file";
	
for($a = 0; $a <= $#ad; $a++)
{
#	print "$ad[$a][0], $totalCount, $accept[$a]\n";
	print out "$ad[$a][0], $totalCount, $accept[$a]\n";
}
close(out);

exit;