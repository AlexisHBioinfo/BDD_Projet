#!/usr/bin/perl
use strict;
use warnings;
use DBI;
my $dbh = DBI->connect("DBI:Pg:dbname=ahucteau;host=dbserver","ahucteau","",{'RaiseError' => 1});
print "Bienvenue dans le menu d'accès à la base de données\n";
my $choix;
while (1){
  print "Que voulez vous faire ?\n\t0 pour ajouter une protéine,\n\t1 pour modifier ou corriger une séquence, \n\t2 pour afficher le nom des protéines (identiant UniProt) qui sont référencées dans le fichier EnsemblPlant, \n\t3 pour afficher le nom des gènes du fichier UniProt qui sont également référencés dans le fichier EnsemblPlant, \n\t4 pour Afficher les protéines ayant une longueur au moins égale à une valeur donnée par l'utilisateur,\n\t5 pour afficher les caractéristiques de la ou les protéines correspondant à un E.C. number(dans le champs protein name) donné par l'utilisateur\n";
  $choix = <STDIN>;
  if ($choix==0){
    print "Vous avez choisi d'ajouter une protéine !\nEntrez son identifiant Uniprot !\n";
    my $uniprot=<STDIN>;
    chomp($uniprot);
    print "Veuillez rentrer les données que vous avez sur cette protéine. ('None si inconnu')\n \n";
    print "Quel est le nom de la protéine ?\n";
    my $protein_name=<STDIN>;
    chomp($protein_name);
    print "La protéine est-elle reviewed ou unreviewed ?\n";
    my $viewed=<STDIN>;
    chomp($viewed);
    if (($viewed ne 'reviewed') && ($viewed ne 'unreviewed')){
      $viewed='unreviewed';
    }
    print "Quelle est la longueur de cette protéine ?\n";
    my $length=<STDIN>;
    chomp($length);
    if (not $length=~/\d/){
      $length=0;
    }
    print "Quel est son identifiant sur EnsemblPlants ? \n";
    my $ensemblPlants=<STDIN>;
    chomp($ensemblPlants);
    print "Quelle est sa séquence ?\n";
    my $sequence=<STDIN>;
    chomp($sequence);
    print "Quel est le nom de son gène ?\n";
    my $gene_name=<STDIN>;
    chomp($gene_name);
    print "A quel organisme appartient cette protéine ?";
    my $organisme=<STDIN>;
    chomp($organisme);
    $dbh -> do ("INSERT INTO Main(Entry, Status, Organism, Protein_name, Length, EnsemblPlants, Sequence, Gene_names) VALUES ('$uniprot','$viewed', '$organisme', '$protein_name', '$length', '$ensemblPlants', '$sequence', '$gene_name')");
  }
  if ($choix==1){
    print "Quelle protéine voulez vous en modifier la séquence ?\n";
    my $requete_proteine=<STDIN>;
    chomp($requete_proteine);
    print "Veuillez entrer la nouvelle séquence !\n";
    my $newSequence=<STDIN>;
    chomp($newSequence);
    $dbh -> do ("UPDATE Main SET Sequence='$newSequence' WHERE Entry='$requete_proteine';");
  }
  if ($choix==2){
    my $req = $dbh->prepare("SELECT Entry_uniprot FROM Reaction") or die $dbh->errstr();
    $req->execute() or die $req->errstr();
    while (my @t = $req->fetchrow_array()) {
      print join(" ",@t),"\n";
    }
    $req->finish;
  }
  if ($choix==3){
    open(EnsemblPlant_file,">EnsemblPlant_file.html");
    print EnsemblPlant_file "<!DOCTYPE html>\n<html lang=\"fr\">\n<head>\n<TABLE BORDER=\"1\">\n";
    my $req = $dbh->prepare("SELECT Gene_names FROM Genes A JOIN Reaction B on A.Gene_names=B.Gene_stable_ID");
    $req->execute() or die $req->errstr();
    while (my @t = $req->fetchrow_array()) {
      print EnsemblPlant_file "\n<TR>\n";
      print join(" ",@t),"\n";
      for my $x (@t){
        print EnsemblPlant_file "\n<TH>";
        print EnsemblPlant_file $x;
        print EnsemblPlant_file "</TH>\n";
      }
      print EnsemblPlant_file "\n</TR>\n";
    }
    $req->finish;
    close(EnsemblPlant_file);
    print "\nUn fichier HTML : EnsemblPlant_file.html a été créé !\n";
  }
  if ($choix==4){
    print ("Quelle longueur minimale ?\n");
    my $input=<STDIN>;
    chomp($input);
    open(prot_length, ">Prot_length_$input.html");
    print prot_length "<!DOCTYPE html>\n<html lang=\"fr\">\n<head>\n<TABLE BORDER=\"1\">\n";
    my $req = $dbh->prepare("SELECT Entry,Length FROM Main WHERE Length>'$input'");
    $req->execute() or die $req->errstr();
    while (my @t = $req->fetchrow_array()) {
      print join(" ",@t),"\n";
      print prot_length "\n<TR>\n";
      for my $x (@t){
        print prot_length "\n<TH>";
        print prot_length $x;
        print prot_length "</TH>\n";
      }
      print prot_length "\n</TR>\n";
    }
    $req->finish;
    print prot_length "\n</TABLE>\n</html>\n";
    close (prot_length);
    print "\nUn fichier HTML : Prot_length_", $input,".html a été créé !\n";
  }
  if ($choix==5){
    print "Quel est l'EC number de la protéine recherchée ?\n";
    my $prot_input=<STDIN>;
    chomp($prot_input);
    open(prot_input,">EC_$prot_input.html");
    my $name=$prot_input;
    print prot_input "<!DOCTYPE html>\n<html lang=\"fr\">\n<head>\n<TABLE BORDER=\"1\">\n";
    $prot_input='(EC '.$prot_input.')';
    my $req = $dbh->prepare("SELECT * FROM Main WHERE protein_name ~ '$prot_input'");
    $req->execute() or die $req->errstr();
    while (my @t = $req->fetchrow_array()) {
      print join(" ",@t),"\n";
      print prot_input "\n<TR>\n";
      for my $x (@t){
        print prot_input "\n<TH>";
        print prot_input $x;
        print prot_input "</TH>\n";
      }
      print prot_input "\n</TR>\n";
    }
    $req->finish;
    print prot_input "\n</TABLE>\n</html>\n";
    close (prot_input);
    print "\nUn fichier HTML : EC_",$name,".html a été créé !\n";
  }
}
$dbh->disconnect();
