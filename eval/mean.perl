#!/usr/bin/perl

$arq  = shift(@ARGV); #obtem parametro passado por linha de comando
open(FILE, $arq) || die "Can't open search-patterns: $!\n";



while ($line = <STDIN>) {
      chop($line);
      ($w1, $w2, $peso, $sim) = split (" ", $line);
      $Simil{$w1}{$w2} = $sim;
}



while ($line = <FILE>) {
      chop($line);
      ($w1, $w2, $peso, $simil) = split (" ", $line);
      if ($simil > 0 ) {
        $mean = ($Simil{$w1}{$w2} + $simil ) / 2;
	 # $mean = $Simil{$w1}{$w2} * $simil   ;
      }
      else {
	  $mean = $Simil{$w1}{$w2};
      }
#      $mean = Max ($Simil{$w1}{$w2} , $simil ) ;
 
      print "$w1 $w2 $peso $mean\n"; 
}




sub Max {
    local ($x) = $_[0];
    local ($y) = $_[1];

    if ($x >= $y) {
      $result = $x
    }
    else {
      $result = $y
    }

    return $result
}
