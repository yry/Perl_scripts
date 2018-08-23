#########################################################
#NORMALIZATION
#########################################################

sub trim($);
# Perl trim function to remove whitespace from the start and end of the string
sub trim($)
{
	my $string = shift;
	$string =~ s/^\s+//;
	$string =~ s/\s+$//;
	return $string;
}

#apply quantiles normalization for a matrix X [m rows x n columns]
#each row is a series of expression
#each column is an experiment
#norm Range = range for which the normalization should be conducted
#0.1 = top 0.1 values
#  1 = whole set

$usage = "perl quantilesNormalization.pl inputMatrix out";
$in = shift or die $usage;
$out = shift or die $usage;

open in, $in
	or die "cannot open input file";
	
while(<in>)
{
	chomp;
	@d = split/,/;
	$timepoints = $#d;
	for($j = 0; $j <= $#d; $j++)
	{
		$d[$j] = trim($d[$j]);
	}
	
	push @data,[@d];
}
close(in);
print "entries : $#data\n";
print "timepoints : $timepoints \n";

#create a copy of the original matrix;
for($i = 0; $i <= $#data; $i++)
{
	for ($j = 0; $j <= $timepoints; $j++)
	{
		$d[$i][$j] = $data[$i][$j];
	}
}

print "copy created with $#data entries\n";

for($j = 1; $j <= $timepoints; $j++)
{
	print "experiment : $j\n";
	
	#step 1: find min / max O(n)
	$min[$j] = $d[0][$j];
	$max[$j] = $d[0][$j];
	
	for($i = 1; $i <= $#data; $i++)
	{
		if($d[$i][$j] > $max[$j])
		{
			$max[$j] = $d[$i][$j];
		}
		if($d[$i][$j] < $min[$j])
		{
			$min[$j] = $d[$i][$j];
		}
	}
	
	print "**experim $j min : $min[$j] max : $max[$j] \n";
	
	for($i = 0; $i <= $#data; $i++)
	{
		$defCnt = 0;
		$defCnt = 1 if defined $count[$d[$i][$j]][$j];
		
#		print "i:$i, j:$j, val: $d[$i][$j], defined:$defCnt\n";
#		sleep(2);
		
		if($defCnt == 0)
		{
			$count[$d[$i][$j]][$j] = 1;
			$sorted[$d[$i][$j]][$j][$count[$d[$i][$j]][$j]] = $i;
		}
		else
		{
			$count[$d[$i][$j]][$j] ++;
			$sorted[$d[$i][$j]][$j][$count[$d[$i][$j]][$j]] = $i;
		}
	}
	print "end of sorting \n\n\n";
}

#print "count / sorted matrixes \n";
#for($j = 1; $j <= $timepoints; $j++)
#{
#	print "experiment : $j\n";
#	for($i = $max[$j]; $i >= $min[$j]; $i--)
#	{
#		$def = 0;
#		$def = 1 if defined $count[$i][$j];
#		if($def == 1)
#		{
#			print "value : $i \n";
#			print "count : $count[$i][$j]\n";
#			print "init poz : $sorted[$i][$j][1]\n";
#			print "\n";
#		}
#	}
#	
#	sleep(10);
#}

#create matrix poz[i][j]
#for experiment j gives the index i of the element 
#such that the elements will come in descending order

print "create poz matrix\n";

for($j = 1; $j <= $timepoints; $j++)
{
	$orderedIndex = 0;
	$countDefined = 0;
	for($i = $max[$j]; $i >= $min[$j]; $i--)
	{
		$def = 0;
		$def = 1 if defined $count[$i][$j];
		if($def == 1)
		{
			$countDefined ++;
			for($k = 1; $k <= $count[$i][$j]; $k++)
			{
				$poz[$sorted[$i][$j][$k]][$j] = $orderedIndex;
				$orderedIndex ++;
			}
		}
		
	}
#	print "for $j are defined : $countDefined \n";
}


#for($j = 1; $j <= $timepoints; $j++)
#{
#	for($i = 0; $i <= $#data; $i++)
#	{
#		print "i : $i, j : $j : $poz[$i][$j] \n";
#	}
#	sleep(10);
#	print "\n\n\n\n\n";
#}

for($j = 1; $j <= $timepoints; $j++)
{
	for($i = 0; $i <= $#data; $i++)
	{
		$poz1[$poz[$i][$j]][$j] = $i;
	}
}

print "quantile normalization \n";
for($i = 0; $i <= $#data; $i++)
{
	for ($j = 1; $j <= $timepoints; $j++)
	{
		$avg[$poz[$i][$j]][$j] = $d[$i][$j];
	}
}

for($i = 0; $i <= $#data; $i++)
{
	$mean[$i] = 0;
	for ($j = 1; $j <= $timepoints; $j++)
	{
		$mean[$i] += $avg[$i][$j];
	}
	$mean[$i] /= $timepoints;
	for ($j = 1; $j <= $timepoints; $j++)
	{
		$avg[$i][$j] = $mean[$i];
	}
}

for($i = 0; $i <= $#data; $i++)
{
	for ($j = 1; $j <= $timepoints; $j++)
	{
		$d[$i][$j] = $avg[$poz[$i][$j]][$j];
	}
}


open out, ">".$out
	or die "cannot open output";

for($i = 0; $i <= $#data; $i++)
{
	for ($j = 0; $j <= $timepoints-1; $j++)
	{
		print out "$d[$i][$j], ";
	}
	print out "$d[$i][$j] \n";
}
close(out);

exit;