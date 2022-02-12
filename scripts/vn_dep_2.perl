#!/usr/bin/perl

$file = shift(@ARGV);
open (FILE1, $file) or die "O ficheiro n o pode ser aberto: $!\n";

$file = shift(@ARGV);
open (FILE2, $file) or die "O ficheiro n o pode ser aberto: $!\n";

$file = shift(@ARGV);
open (FILE3, $file) or die "O ficheiro n o pode ser aberto: $!\n";

$th=500;
$rel = "Dobj_down_" ;

while (my $line = <FILE2>) {
 chomp $line;
 ($head, $dep) = split ("@", $line);
 #$Dep{$dep}++;
 #$Head{$head}++;
 $cntx_head = $rel . $head;
 $Cntx_head{$cntx_head}++;
}

while (my $line = <FILE1>) {
 chomp $line;
 my ($cntx, $word, $freq) = split (" ", $line); 
     $Cntx{$cntx}{$word} = $freq ; #if ($Cntx_head{$cntx});
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
 $cntx_head = $rel . $head;
 #print STDERR "#$head# -- #$dep# -- $cntx_head\n";

  my $freq=1;
  my $count=0;
  my %found;

  foreach my $wordDep (sort {$Cntx{$cntx_head}{$b} <=>
                             $Cntx{$cntx_head}{$a}  }

                            keys %{$Cntx{$cntx_head}}) { ##conjunto de verbos (head) modificados polo nome (dep) en funçom de sujeito Subj_up_noun
      #print STDERR "#$wordDep# $cntx_head\n";
      if ($count <= $th) {
       if ($wordDep eq $dep) {next}
       $count++;
       foreach my $cntxDep (sort keys %{$Dico{$wordDep}}) { ##aqui construimos o conjunto de contextos dos verbos associados ao nome
      # my  ($dimA) = $cntxA =~ /_([^_]+)$/; 
	  if ($Dico{$dep}{$cntxDep}) {
	      $DicoNew{$cntxDep} += $Dico{$dep}{$cntxDep};
             #print STDERR "#$cntxHead# #$head#\n";
	  }
       }
      
  }
 } 

 foreach my $cntxDep (sort keys %{$Dico{$dep}}) { ##percorremos o conjunto de contextos do nome (dep) 
    $freq = $DicoNew{$cntxDep} * $Dico{$dep}{$cntxDep}  ;
      #  $freq += $Dico{$wordA}{$cntxA} + $DimN{$noun}{$cntxN}  ;
         #print STDERR "FREQ:: #$freq#\n";
         #print STDERR "#$noun# -- #$c# -- #$Dico{$noun}{$c}# #$DicoA{$c}#\n";
    print "$cntxDep $new_term $freq\n" if ($freq >0);
     
       #else {print STDERR "--$dimA\n"}
   }     
     
  undef %DicoNew;
  
    
# }
}


 


