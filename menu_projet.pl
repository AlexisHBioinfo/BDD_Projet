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
    print "Quel est son synonyme ?\n";
    my $synonyme=<STDIN>;
    chomp($synonyme);
    print "Quel est son ontologie ?\n";
    my $ontology=<STDIN>;
    chomp($ontology);
    $dbh -> do ("INSERT INTO Protein(Entry, Protein_name, Length, EnsemblPlants, Sequence) VALUES ('$uniprot', '$protein_name', '$length', '$ensemblPlants', '$sequence')");
    $dbh -> do ("INSERT INTO Genes(Gene_names, Genename_synonym, Gene_ontology) VALUES ('$gene_name', '$synonyme', '$ontology')");
  }
  if ($choix==1){
    print "Quelle protéine voulez vous en modifier la séquence ?\n";
    my $requete_proteine=<STDIN>;
    chomp($requete_proteine);
    print "Veuillez entrer la nouvelle séquence !\n";
    my $newSequence=<STDIN>;
    chomp($newSequence);
    $dbh -> do ("UPDATE Protein SET Sequence='$newSequence' WHERE Entry='$requete_proteine';");
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
    my $req = $dbh->prepare("SELECT Gene_names FROM Genes A JOIN Reaction B on A.Gene_names=B.Gene_stable_ID");
    $req->execute() or die $req->errstr();
    while (my @t = $req->fetchrow_array()) {
      print join(" ",@t),"\n";
    }
    $req->finish;
  }
  if ($choix==4){
    print ("Quelle longueur minimale ?\n");
    my $input=<STDIN>;
    my $req = $dbh->prepare("SELECT Entry FROM Protein WHERE Length>'$input'");
    $req->execute() or die $req->errstr();
    while (my @t = $req->fetchrow_array()) {
      print join(" ",@t),"\n";
    }
    $req->finish;
  }
  if ($choix==5){
    print "Quel est l'EC number de la protéine recherchée.\n";
    my $prot_input=<STDIN>;
    chomp($prot_input);
    open(prot_input,">EC_$prot_input.html");
    print prot_input "<!DOCTYPE html>\n<html lang=\"fr\">\n<head>\n<TABLE BORDER=\"1\">\n";
    $prot_input='(EC '.$prot_input.')';
    my $req = $dbh->prepare("SELECT * FROM Protein WHERE protein_name ~ '$prot_input'");
    $req->execute() or die $req->errstr();
    while (my @t = $req->fetchrow_array()) {
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
  }
}
$dbh->disconnect();
