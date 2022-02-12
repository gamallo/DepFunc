#!/usr/bin/perl

$file = shift(@ARGV);
open (FILE1, $file) or die "O ficheiro n o pode ser aberto: $!\n";

$file = shift(@ARGV);
open (FILE2, $file) or die "O ficheiro n o pode ser aberto: $!\n";

$file = shift(@ARGV);
open (FILE3, $file) or die "O ficheiro n o pode ser aberto: $!\n";

$th=500;
$rel="Dobj_down_";


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


while (my $line = <FILE3>) {
 chomp $line;
 my ($cntx, $word, $freq) = split (" ", $line); 
 $DicoNV{$word}{$cntx} = $freq;
 $CntxNV{$cntx}{$word} = $freq;
 # print STDERR " #$word#\n";
}



$k=0;
while (my $line = <FILE2>) {
 chomp $line;
 ($subj, $verb, $dep) = split ("@", $line);
# print STDERR "#$line# -- #$k#\n";
 $k++;
 $new_term = $subj . "@" . $verb . "@" . $dep ;
 $nv = $subj . "@" . $verb ;



  #print STDERR "#$cntxNV# -- #$nv#\n";
  my $freq=1;
  my $count=0;
  my %found;
  $cntx_dep = $rel . $verb;
  foreach my $wordDep (sort {$Cntx{$cntx_dep}{$b} <=>
                           $Cntx{$cntx_dep}{$a}  }

                            keys %{$Cntx{$cntx_dep}}) { ##wordDep: conjunto de verbos dependentes dos nomes que aparecem na dep: Dobj_up_noun
      #print STDERR "#$wordDep# #$cntx_dep#\n";
      if ($count <= $th) {
       if ($wordDep eq $nv) {next} #??? nosense
       $count++;
       foreach my $cntxDep (keys %{$Dico{$wordDep}}) { ##aqui construimos o conjunto de contextos dos verbos associados ao nome
      # my  ($dimA) = $cntxA =~ /_([^_]+)$/; 
	  if ($DicoNV{$nv}{$cntxDep}) {
	      $DicoNew{$cntxDep} += $DicoNV{$nv}{$cntxDep};
               #print STDERR "#$nv# #$cntxDep#\n";
	  }
       }
      }
  }
   
 foreach my $cntxNV (keys %{$DicoNV{$nv}}) { ##percorremos o conjunto de contextos do subj_verb  
       $freq = $DicoNew{$cntxNV} * $DicoNV{$nv}{$cntxNV}  ;
      #  $freq += $Dico{$wordA}{$cntxA} + $DimN{$noun}{$cntxN}  ;
         #print STDERR "FREQ:: #$freq#\n";
      #   print STDERR "#$cntxNV# -- #$freq# -- #$DicoNV{$nv}{$cntxNV}# #$DicoNew{$cntxNV}#\n";
         print "$cntxNV $new_term $freq \n" if ($freq >0);
  
       
       #else {print STDERR "--$dimA\n"}
        
 }
  undef %DicoNew;
  
    
 #}
}


 


