#!/usr/bin/perl

#$arq  = shift(@ARGV); #obtem parametro passado por linha de comando
#open(GOLD, $arq) || die "Can't open search-patterns: $!\n";


$th=200;
while ($line = <STDIN>) {
      chop($line);
      ($cntx, $w, $peso) = split (" ", $line);
      #$sim = $sim - 0.1;
      $Peso{$w}{$cntx} = $peso;
}




#$count=1;
foreach $w (sort keys %Peso) {
   $count=1;
   foreach $cntx  (sort {$Peso{$w}{$b} <=> 
                  $Peso{$w}{$a} } 
                  keys %{$Peso{$w}} ) {
      
      if ($count <= $th) {
        print "$cntx $w $Peso{$w}{$cntx}\n";
      }
      $count++
   }   
   
} 
 
 
