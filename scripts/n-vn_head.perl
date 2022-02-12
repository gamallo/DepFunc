#!/usr/bin/perl

$file = shift(@ARGV);
open (FILE1, $file) or die "O ficheiro n o pode ser aberto: $!\n";

$file = shift(@ARGV);
open (FILE2, $file) or die "O ficheiro n o pode ser aberto: $!\n";

$file = shift(@ARGV);
open (FILE3, $file) or die "O ficheiro n o pode ser aberto: $!\n";

$th=500;
$rel="Subj_up_";


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
 $DicoVN{$word}{$cntx} = $freq;
 $CntxVN{$cntx}{$word} = $freq;
 # print STDERR " #$word#\n";
}



$k=0;
while (my $line = <FILE2>) {
 chomp $line;
 ($subj, $verb, $obj) = split ("@", $line);
# print STDERR "#$line# -- #$k#\n";
 $k++;
 $new_term = $subj . "@" . $verb . "@" . $obj ;
 $vn = $verb . "@" . $obj ;



  #print STDERR "#$cntxNV# -- #$nv#\n";
  my $freq=1;
  my $count=0;
  my %found;
  $cntx_dep = $rel . $subj;
  foreach my $wordHead (sort {$Cntx{$cntx_dep}{$b} <=>
                           $Cntx{$cntx_dep}{$a}  }

                            keys %{$Cntx{$cntx_dep}}) { ##wordHead: conjunto de verbos dependentes dos nomes que aparecem na dep: Dobj_up_noun
     # print STDERR "#$wordHead# $cntx_dep\n";
      if ($count <= $th) {
       if ($wordHead eq $vn) {next} #??? nosense
       $count++;
       foreach my $cntxHead (keys %{$Dico{$wordHead}}) { ##aqui construimos o conjunto de contextos dos verbos associados ao nome
      # my  ($dimA) = $cntxA =~ /_([^_]+)$/; 
          #print STDERR "#$vn# $cntxHead\n";
	  if ($DicoVN{$vn}{$cntxHead}) {
	      $DicoNew{$cntxHead} += $DicoVN{$vn}{$cntxHead};
               #print STDERR "#$vn# #$cntxHead# #$DicoNew{$cntxHead}#\n";
	  }
       }
      }
  }
   
 foreach my $cntxVN (keys %{$DicoVN{$vn}}) { ##percorremos o conjunto de contextos do subj_verb  
       $freq = $DicoNew{$cntxVN} * $DicoVN{$vn}{$cntxVN}  ;
      #  $freq += $Dico{$wordA}{$cntxA} + $DimN{$noun}{$cntxN}  ;
         #print STDERR "FREQ:: #$freq#\n";
         #print STDERR "#$vn# - #$cntxVN# -- #$freq# -- #$DicoVN{$vn}{$cntxVN}# #$DicoNew{$cntxVN}#\n" if ($freq >0) ;
         print "$cntxVN $new_term $freq \n" if ($freq >0);
  
       
       #else {print STDERR "--$dimA\n"}
        
 }
  undef %DicoNew;
  
    
 #}
}


 


