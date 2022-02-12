#!/usr/bin/perl

$file = shift(@ARGV);
open (FILE1, $file) or die "O ficheiro n o pode ser aberto: $!\n";

$file = shift(@ARGV);
open (FILE2, $file) or die "O ficheiro n o pode ser aberto: $!\n";

$file = shift(@ARGV);
open (FILE3, $file) or die "O ficheiro n o pode ser aberto: $!\n";

$th=500;
$rel = "Dobj_up_" ;


while (my $line = <FILE2>) {
 chomp $line;
 ($head, $dep) = split ("@", $line);
 $cntx_dep = $rel . $dep;
 $Cntx_dep{$cntx_dep}++;
}

while (my $line = <FILE1>) {
 chomp $line;
 my ($cntx, $word, $freq) = split (" ", $line); 
     $Cntx{$cntx}{$word} = $freq ;# if ($Cntx_dep{$cntx});
     $Word{$word}++;   
}

while (my $line = <STDIN>) {
 chomp $line;
 my ($cntx, $word, $freq) = split (" ", $line); 
 if ($Word{$word}) {   
     #print STDERR "##$word##\n";
   $Dico{$word}{$cntx} = $freq
 }
}
print STDERR "load freq\n";

$k=0;
while (my $line = <FILE3>) {
 chomp $line;
 ($head, $dep) = split ("@", $line);
 $k++;
 $new_term = $head . "@" . $dep;
 $cntx_dep = $rel . $dep;
 #print STDERR "$cntx_dep: #$dep# -- #$head#\n";

  my $freq=1;
  my $count=0;
  my %found;

  foreach my $wordHead (sort {$Cntx{$cntx_dep}{$b} <=>
                             $Cntx{$cntx_dep}{$a}  }

                            keys %{$Cntx{$cntx_dep}}) { ##conjunto de verbos (head) modificados polo nome (dep) en funçom de sujeito Subj_up_noun
     # print STDERR "#$wordHead# $cntx_dep\n";
      if ($count <= $th) {
       if ($wordHead eq $head) {next}
       $count++;
       foreach my $cntxHead (keys %{$Dico{$wordHead}}) { ##aqui construimos o conjunto de contextos dos verbos associados ao nome
      # my  ($dimA) = $cntxA =~ /_([^_]+)$/; 
	  if ($Dico{$head}{$cntxHead}) {
	      $DicoNew{$cntxHead} += $Dico{$head}{$cntxHead};
             #print STDERR "#$cntxHead# #$head#\n";
	  }
       }
      
  }
 } 

 foreach my $cntxHead (keys %{$Dico{$head}}) { ##percorremos o conjunto de contextos do verbo (head) 
    $freq = $DicoNew{$cntxHead} * $Dico{$head}{$cntxHead}  ;
      #  $freq += $Dico{$wordA}{$cntxA} + $DimN{$noun}{$cntxN}  ;
         #print STDERR "FREQ:: #$freq#\n";
         #print STDERR "#$noun# -- #$c# -- #$Dico{$noun}{$c}# #$DicoA{$c}#\n";
    print "$cntxHead $new_term $freq\n" if ($freq >0);
     
       #else {print STDERR "--$dimA\n"}
   }     
     
  undef %DicoNew;
  
    
# }
}


 


