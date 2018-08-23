#GTTCAGAGTTCTACAGTCCGACGATC
#remove the 4N + 4N on either side
#applied on NR files

use Bio::SeqIO;

$usage = "perl removeN.pl input output";
$input = shift or die $usage;
$out   = shift or die $usage;

my $seqs = Bio::SeqIO->new(-format => 'fasta', -file => "$input");

open out, ">".$out
	or die "cannot open output file";

$accept_R = 0;
#$accept_NR= 0;
while (my $seq = $seqs->next_seq ) 
{
	my $sequence = $seq->seq();
	my $id = $seq->id();
	$seq1 = substr($sequence, 4, length($sequence) - 4);
	$seq2 = substr($seq1, 0, length($seq1) - 4);
	if(length($seq2) > 16)
	{
	print out ">$id\n";
	print out "$seq2\n";
#	@ss = split(/\-/,$id);
#	$accept_NR++;
#	$accept_R += $ss[1];
	$accept_R++;
	}
}
close(out);

print "accepted redundant: $accept_R \n";
#print "accepted redundant: $accept_NR \n";

exit;