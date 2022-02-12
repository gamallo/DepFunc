#!/usr/bin/perl

$file = shift(@ARGV);
open (FILE, $file) or die "O ficheiro n o pode ser aberto: $!\n";

$dir= shift(@ARGV);
$rel= shift(@ARGV);

#$th=100;
$rel = $rel . "_" . ${dir} . "_" ;

while (my $line = <FILE>) {
 chomp $line;
 ($head, $dep) = split ("@", $line);
 if ($dir eq "down") {
  $cntx = $rel . $head;
  $Cntx{$cntx}++;
  #$Word{$dep}++;
 # print STDERR "$head - #$cntx#\n" if ($head eq "buy");
 }
 elsif ($dir eq "up") {
  $cntx = $rel . $dep;
  $Cntx{$cntx}++;
  #$Word{$head}++;
 }

# print STDERR "$head - #$cntx#\n" if ($head eq "buy");
}

while (my $line = <STDIN>) {
 chomp $line;
 my ($cntx, $word, $freq) = split (" ", $line); 
 
 if ($Cntx{$cntx} ) {
     print "$line\n" ;
 }
}



 


