#!/usr/bin/perl

$arq  = shift(@ARGV); #obtem parametro passado por linha de comando
open(GOLD, $arq) || die "Can't open search-patterns: $!\n";



while ($line = <STDIN>) {
      chop($line);
      ($w1, $w2, $sim) = split (" ", $line);
      #$sim = $sim - 0.1;
      $Simil{$w1}{$w2} = $sim;
}



while ($line = <GOLD>) {
      chop($line);
      ($w1, $w2, $peso) = split (" ", $line);
      $w1 =~ s/-[nv]//g;
      $w2 =~ s/-[nv]//g;
      $w1 =~ s/_/@/g;
      $w2 =~ s/_/@/g;
      $Peso{$w1,$w2} += $peso;
      $Count{$w1}{$w2}++;
}

foreach $pair (sort {$Peso{$b} <=> 
                  $Peso{$a} } 
                  keys %Peso ) {
      ($w1, $w2) = split (/$;/o, $pair);
      $w1 =~ s/-[nv]//g;
      $w2 =~ s/-[nv]//g;
      $w1 =~ s/_/@/g;
      $w2 =~ s/_/@/g;
#      print STDERR "$w1 - $w2\n";
      $mean = $Peso{$w1,$w2} / $Count{$w1}{$w2} if ( $Count{$w1}{$w2});
      if ($Simil{$w1}{$w2}) {
	  print "$w1 $w2 $mean $Simil{$w1}{$w2}\n";
      }
      else {
           print "$w1 $w2 $mean 0.0\n";
      }
   
} 
 
 
