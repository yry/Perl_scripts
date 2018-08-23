#!/usr/bin/perl

use Bio::SeqIO;
use lib "/usr/local/Bioperl/lib/perl5/site_perl/5.8.3";
print STDERR "Removes adaptors - also removes short seqs (< 16nt) by default\n";
$usage = "perl remove.pl file adapter out";
my $input = shift or die $usage;
my $ad    = shift or die $usage;
my $out   = shift or die $usage;

my $total_count = 0;
my $accept = 0;

open out, ">".$out
	or die "cannot open output";

my $seqs = Bio::SeqIO->new(-format => 'fasta', -file => "$input");
while (my $seq = $seqs->next_seq ) {
$total_count++;
my $sequence = $seq->seq();
my $id = $seq->id();
if ($sequence =~m/^(\w+)($ad\w+)$/){
	my $processed_seq = $1;
	my $adaptor = $2;
	
	if (length($processed_seq) > 16){
		print out ">$id\n$processed_seq\n";
		$size[length($processed_seq)]++;
		$accept++;
		}
	}
}
close(out);

print STDERR "total number of sequences: $total_count \n";
print STDERR "accepted sequence: $accept\n";

exit;