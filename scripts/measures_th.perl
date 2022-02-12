#!/usr/bin/perl -w

#
#  25 de Março de 2008 - 
# toma dois ficheiros: um de pares (pipe) e um outro de frequencias (arg1) e compara palavra por palavra. 
# um parametro (arg2): numero de contextos comuns.
## devolve um ficheiro com pares de palavras e 9 medidas de similaridade:
# baseline, dice-bin, dice-min, jaccard, cosine, cosine-bin, cityblock, cosine, js
#
#


$arq = shift(@ARGV);
open(PFILE, $arq) || die "Can't open search-patterns: $!\n";

$th= shift(@ARGV);
$mycount=0;

while ($line = <PFILE>) {
  chop $line;
  ($atributo, $objecto, $freq) = split (" ", $line);

  $dic{$objecto}{$atributo} = $freq;
  $freqObj{$objecto} += $freq;
  $Obj{$objecto}++;
 # $freqAtr{$atributo} += $freq;
  $nrels++;


  $mycount++;
  if ($mycount % 1000 == 0) {
 #    printf STDERR "leu freqs: %10d\r",$mycount;
   }
}

$mycount = 0;
#printf STDERR "\nCarregou frequencias, calcula peso global...\n";



printf STDERR "Infos calculadas ... nrels = %d\n",$nrels;

$mycount=0;

while (<>) {
  chop $_;
  ($obj1, $obj2) = split (" ", $_);

  
  $mycount++;
  if ($mycount % 1000 == 0) {
     printf STDERR "count: %10d\r",$mycount;
  }


  $diceBin = 0;
  $diceMin = 0;
  $cosine=0;
  $cosineBin=0;

 # $rels = "";
  $min = 0;
  $max = 0;
  $o1 = 0;
  $o2= 0 ;
  $sum_intersection = 0;
  $intersection = 0;
  $baseline = 0; 

  foreach $atr (keys %{ $dic{$obj1} }) {
 
    $assoc1 = 0;
    $assoc2 = 0;
    ##buscar atributos comuns
    if (defined $dic{$obj2}{$atr}) {
          $baseline++ ;

  #       $rels = $rels . "|" . $atr ;
         $assoc1 = $dic{$obj1}{$atr} ;
         $assoc2 = $dic{$obj2}{$atr} ;

         $min += Min ($assoc1, $assoc2) ;
         $max += Max ($assoc1, $assoc2) ;


          $o1 += $dic{$obj1}{$atr} **2;
	  $o2 +=  $dic{$obj2}{$atr} **2 ;
         $intersection += $assoc1 *  $assoc2 ;
         $sum_intersection += $assoc1 + $assoc2 ;
     }

    elsif (defined $dic{$obj1}{$atr}) {
	$max += $dic{$obj1}{$atr} ;
        $o1 += $dic{$obj1}{$atr} **2 ;

    }

  }

  foreach $atr2 (keys %{ $dic{$obj2} }) {
     if (!defined $dic{$obj1}{$atr2} ) {
         $max += $dic{$obj2}{$atr2} ;
         $o2 +=  $dic{$obj2}{$atr2} **2 ;
     }
  }


   ##computar formulas finais:

  ##diceBin diceMin:


  if ($baseline <= $th) {$baseline = 0 ; $min=0}
 
  ##diceBin, cosineBin, $jaccard
  if ( (defined $Obj{$obj1}) && (defined $Obj{$obj2}) )  {
    $diceBin = (2*$baseline) / ($Obj{$obj1} + $Obj{$obj2}) ;
    $cosineBin = $baseline / sqrt ($Obj{$obj1} * $Obj{$obj2} )
  }
  
  if ( ($o1 > 0) && ($o2 > 0) )  {
    $cosine = $intersection / (sqrt ($o1 * $o2) ) ;
  }

  
  ##diceMin, cosine, lin:
  if ( (defined $freqObj{$obj1}) && (defined $freqObj{$obj2}) )  {
    $diceMin = (2*$min) / ($freqObj{$obj1} + $freqObj{$obj2}) ;
  }
  #if ($obj1 eq "study\@provide\@evidence" && $obj2 eq "study\@supply\@evidence") {
  #    print STDERR "#$cosine#\n";
  #    }
#  $measure = ($cosine + $cosineBin) / 2;
   $measure = ($cosine + $cosineBin + $diceMin + $diceBin) / 4;
  #  $measure = ($diceMin + $diceBin) / 2;
  printf "%s %s %f\n", $obj1, $obj2, $cosineBin;
  

}

printf STDERR "Total: %10d\n\n",$mycount;



 sub Min {
    local ($x) = $_[0];
    local ($y) = $_[1];

    if ($x <= $y) {
      $result = $x
    }
    else {
      $result = $y
    }

    return $result
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








