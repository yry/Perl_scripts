#read file

$usage = "perl read.pl in";
$in = shift or die $usage;

open in, $in
	or die "cannot open input";
while(<in>)
{
	chomp;
	$substr = substr($_,0,300);
	print "$substr\n";
	sleep(1);
}
close(in);

exit;