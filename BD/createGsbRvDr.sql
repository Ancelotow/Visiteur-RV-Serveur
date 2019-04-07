DROP DATABASE IF EXISTS gsbrv ;

CREATE DATABASE IF NOT EXISTS gsbrv DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci ;
USE gsbrv ;

create table activitecompl
(
  ac_num   int default '0' not null
    primary key,
  ac_date  date            null,
  ac_lieu  varchar(50)     null,
  ac_theme varchar(20)     null
)
  engine = InnoDB;

create table composant
(
  cmp_code    varchar(8) default '' not null
    primary key,
  cmp_libelle varchar(50)           null
)
  engine = InnoDB;

create table dosage
(
  dos_code     varchar(20) default '' not null
    primary key,
  dos_quantite varchar(20)            null,
  dos_unite    varchar(20)            null
)
  engine = InnoDB;

create table famille
(
  fam_code    varchar(6) default '' not null
    primary key,
  fam_libelle varchar(160)          null
)
  engine = InnoDB;

create table laboratoire
(
  lab_code      varchar(4) default '' not null
    primary key,
  lab_nom       varchar(20)           null,
  lab_chefvente varchar(40)           null
)
  engine = InnoDB;

create table medicament
(
  med_depotlegal      varchar(20) default '' not null
    primary key,
  med_nomcommercial   varchar(50)            null,
  fam_code            varchar(6)             null,
  med_composition     varchar(510)           null,
  med_effets          varchar(510)           null,
  med_contreindic     varchar(510)           null,
  med_prixechantillon float                  null,
  constraint FK_MEDICAMENT_FAMILLE
  foreign key (fam_code) references famille (fam_code)
)
  engine = InnoDB;

create table constituer
(
  med_depotlegal varchar(20) default '' not null,
  cmp_code       varchar(8) default ''  not null,
  cst_qte        float                  null,
  primary key (med_depotlegal, cmp_code),
  constraint FK_CONSTITUER_MEDICAMENT
  foreign key (med_depotlegal) references medicament (med_depotlegal),
  constraint FK_CONSTITUER_COMPOSANT
  foreign key (cmp_code) references composant (cmp_code)
)
  engine = InnoDB;

create index FK_CONSTITUER_COMPOSANT
  on constituer (cmp_code);

create table interagir
(
  med_perturbateur varchar(20) default '' not null,
  med_perturbe     varchar(20) default '' not null,
  primary key (med_perturbateur, med_perturbe),
  constraint FK_INTERAGIR_PERTURBATEUR_MEDICAMENT
  foreign key (med_perturbateur) references medicament (med_depotlegal),
  constraint FK_INTERAGIR_PERTURBE_MEDICAMENT
  foreign key (med_perturbe) references medicament (med_depotlegal)
)
  engine = InnoDB;

create index FK_INTERAGIR_PERTURBE_MEDICAMENT
  on interagir (med_perturbe);

create index FK_MEDICAMENT_FAMILLE
  on medicament (fam_code);

create table motif
(
  mo_code    int          not null
    primary key,
  mo_libelle varchar(100) null
)
  engine = InnoDB;

create table offrir
(
  vis_matricule  varchar(20) default '' not null,
  rap_num        int default '0'        not null,
  med_depotlegal varchar(20) default '' not null,
  off_quantite   int(2) default '0'     not null,
  primary key (vis_matricule, rap_num, med_depotlegal),
  constraint FK_OFFRIR_MEDICAMENT
  foreign key (med_depotlegal) references medicament (med_depotlegal)
)
  engine = InnoDB;

create index FK_OFFRIR_MEDICAMENT
  on offrir (med_depotlegal);

create table presentation
(
  pre_code    varchar(4) default '' not null
    primary key,
  pre_libelle varchar(40)           null
)
  engine = InnoDB;

create table formuler
(
  med_depotlegaL varchar(20) default '' not null,
  pre_code       varchar(4) default ''  not null,
  primary key (med_depotlegaL, pre_code),
  constraint FK_FORMULER_MEDICAMENT
  foreign key (med_depotlegaL) references medicament (med_depotlegal),
  constraint FK_FORMULER_PRESENTATION
  foreign key (pre_code) references presentation (pre_code)
)
  engine = InnoDB;

create index FK_FORMULER_PRESENTATION
  on formuler (pre_code);

create table secteur
(
  sec_code    varchar(2) default '' not null
    primary key,
  sec_libelle varchar(30)           null
)
  engine = InnoDB;

create table region
(
  reg_code varchar(4) default '' not null
    primary key,
  sec_code varchar(2)            null,
  reg_nom  varchar(100)          null,
  constraint FK_REGION_SECTEUR
  foreign key (sec_code) references secteur (sec_code)
)
  engine = InnoDB;

create index FK_REGION_SECTEUR
  on region (sec_code);

create table specialite
(
  spe_code    varchar(10) default '' not null
    primary key,
  spe_libelle varchar(300)           null
)
  engine = InnoDB;

create table typeindividu
(
  tin_code    varchar(10) default '' not null
    primary key,
  tin_libelle varchar(100)           null
)
  engine = InnoDB;

create table prescrire
(
  med_depotlegal varchar(20) default '' not null,
  tin_code       varchar(10) default '' not null,
  dos_code       varchar(20) default '' not null,
  pre_posologie  varchar(80)            null,
  primary key (med_depotlegal, tin_code, dos_code),
  constraint FK_PRESCRIRE_MEDICAMENT
  foreign key (med_depotlegal) references medicament (med_depotlegal),
  constraint FK_PRESCRIRE_TYPE_INDIVIDU
  foreign key (tin_code) references typeindividu (tin_code),
  constraint FK_PRESCRIRE_DOSAGE
  foreign key (dos_code) references dosage (dos_code)
)
  engine = InnoDB;

create index FK_PRESCRIRE_DOSAGE
  on prescrire (dos_code);

create index FK_PRESCRIRE_TYPE_INDIVIDU
  on prescrire (tin_code);

create table typepraticien
(
  typ_code    varchar(6) default '' not null
    primary key,
  typ_libelle varchar(50)           null,
  typ_lieu    varchar(70)           null
)
  engine = InnoDB;

create table praticien
(
  pra_num           int default '0' not null
    primary key,
  pra_nom           varchar(50)     null,
  pra_prenom        varchar(60)     null,
  pra_adresse       varchar(100)    null,
  pra_cp            varchar(10)     null,
  pra_ville         varchar(50)     null,
  pra_coefnotoriete float           null,
  typ_code          varchar(6)      null,
  constraint FK_PRATICIEN_TYPE_PRATICIEN
  foreign key (typ_code) references typepraticien (typ_code)
)
  engine = InnoDB;

create table inviter
(
  ac_num         int default '0' not null,
  pra_num        int default '0' not null,
  specialisation char            null,
  primary key (ac_num, pra_num),
  constraint FK_INVITER_ACTIVITE_COMPL
  foreign key (ac_num) references activitecompl (ac_num),
  constraint FK_INVITER_PRATICIEN
  foreign key (pra_num) references praticien (pra_num)
)
  engine = InnoDB;

create index FK_INVITER_PRATICIEN
  on inviter (pra_num);

create table posseder
(
  pra_num              int default '0'        not null,
  spe_code             varchar(10) default '' not null,
  pos_diplome          varchar(20)            null,
  pos_coefprescription float                  null,
  primary key (pra_num, spe_code),
  constraint FK_POSSEDER_PRATICIEN
  foreign key (pra_num) references praticien (pra_num),
  constraint FK_POSSEDER_SPECIALITE
  foreign key (spe_code) references specialite (spe_code)
)
  engine = InnoDB;

create index FK_POSSEDER_SPECIALITE
  on posseder (spe_code);

create index FK_PRATICIEN_TYPE_PRATICIEN
  on praticien (typ_code);

create table visiteur
(
  vis_matricule    varchar(20) default '' not null
    primary key,
  vis_nom          varchar(50)            null,
  vis_prenom       varchar(100)           null,
  vis_adresse      varchar(100)           null,
  vis_cp           varchar(10)            null,
  vis_ville        varchar(60)            null,
  vis_dateembauche date                   null,
  sec_code         varchar(2)             null,
  lab_code         varchar(4)             null,
  vis_mdp          varchar(500)           null,
  constraint FK_VISITEUR_SECTEUR
  foreign key (sec_code) references secteur (sec_code),
  constraint FK_VISITEUR_LABORATOIRE
  foreign key (lab_code) references laboratoire (lab_code)
)
  engine = InnoDB;

create table rapportvisite
(
  vis_matricule      varchar(20) default ''  not null,
  rap_num            int default '0'         not null,
  rap_date_visite    date                    not null,
  rap_bilan          varchar(510) default '' null,
  rap_date_redaction date                    null,
  rap_confiance      int                     null,
  mo_code            int                     not null,
  pra_num            int                     null,
  rap_lu             tinyint(1)              null,
  primary key (vis_matricule, rap_num),
  constraint FK_RAPPORT_VISITE_VISITEUR
  foreign key (vis_matricule) references visiteur (vis_matricule),
  constraint FK_RAPPORT_VISITE_MOTIF
  foreign key (mo_code) references motif (mo_code),
  constraint FK_RAPPORT_VISITE_PRATICIEN
  foreign key (pra_num) references praticien (pra_num)
)
  engine = InnoDB;

create index FK_RAPPORT_VISITE_MOTIF
  on rapportvisite (mo_code);

create index FK_RAPPORT_VISITE_PRATICIEN
  on rapportvisite (pra_num);

create table realiser
(
  ac_num        int default '0'        not null,
  vis_matricule varchar(20) default '' not null,
  primary key (ac_num, vis_matricule),
  constraint FK_REALISER_ACTIVITE_COMPL
  foreign key (ac_num) references activitecompl (ac_num),
  constraint FK_REALISER_VISITEUR
  foreign key (vis_matricule) references visiteur (vis_matricule)
)
  engine = InnoDB;

create index FK_REALISER_VISITEUR
  on realiser (vis_matricule);

create table travailler
(
  vis_matricule varchar(20) default '' not null,
  jjmmaa        date                   not null,
  reg_code      varchar(4) default ''  not null,
  tra_role      varchar(22)            null,
  primary key (vis_matricule, jjmmaa, reg_code),
  constraint FK_TRAVAILLER_VISITEUR
  foreign key (vis_matricule) references visiteur (vis_matricule),
  constraint FK_TRAVAILLER_REGION
  foreign key (reg_code) references region (reg_code)
)
  engine = InnoDB;

create index FK_TRAVAILLER_REGION
  on travailler (reg_code);

create index FK_VISITEUR_LABORATOIRE
  on visiteur (lab_code);

create index FK_VISITEUR_SECTEUR
  on visiteur (sec_code);
