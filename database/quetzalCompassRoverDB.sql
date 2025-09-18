create database QuetzalCompassRover;

use QuetzalCompassRover;

/*Borrar*/
drop table Transporte;
drop table TipoTransporte;
drop table Perfil;
drop table Usuario;
drop table TipoUsuario;
drop table Parada;
drop table TipoParada;
drop table Ruta;
-- Nuevas tablas (si existen)
drop table if exists HistorialDestino;
drop table if exists FavoritoDestino;

/*Creacion Ruta*/
create table Ruta(
    id_Ruta int primary key auto_increment,
    Nombre_Ruta varchar(50) not null,
    Descripcion_Ruta text not null
);

create table TipoParada(
    id_TipoParada int primary key auto_increment,
    Tipo varchar(25) not null
);

create table Parada(
    id_Parada int primary key auto_increment,
    Tipo_Parada int not null,
    Ruta int not null ,
    Latitud double not null ,
    Longitud double not null ,
    Descripcion text not null ,
    foreign key (Tipo_Parada) references TipoParada(id_TipoParada) on delete cascade ,
    foreign key (Ruta) references Ruta(id_Ruta) on delete cascade
);

/*Creacion Usuario*/
create table TipoUsuario(
    id_TipoUsuario int primary key auto_increment,
    Tipo varchar(15) not null
);

create table Usuario(
    id_usuario int primary key auto_increment,
    Username varchar(20) not null unique ,
    Password varchar(100) not null ,
    Email varchar(100) not null unique ,
    Telefono bigint not null unique,
    Tipo_Usuario int not null ,
    foreign key (Tipo_Usuario) references TipoUsuario(id_TipoUsuario) on delete cascade
);

create table Perfil(
    id_Perfil int primary key auto_increment,
    Nombre text not null,
    Foto text not null ,
    Usuario int not null ,
    foreign key (Usuario) references Usuario(id_usuario) on delete cascade
);

/*Creacion Transporte*/
create table TipoTransporte(
    id_TipoTransporte int primary key auto_increment,
    Tipo varchar(20) not null
) ;

create table Transporte(
    id_Transporte int primary key auto_increment,
    Tipo_Transporte int not null ,
    Ruta int not null unique,
    Piloto int ,
    foreign key (Tipo_Transporte) references TipoTransporte(id_TipoTransporte) on delete cascade ,
    foreign key (Ruta) references Ruta(id_Ruta) on delete cascade ,
    foreign key (Piloto) references Usuario(id_usuario) on delete cascade
);

/* Historial de destinos por usuario */
create table HistorialDestino (
    id_historial int primary key auto_increment,
    usuario int not null,
    nombre varchar(100),
    direccion text,
    latitud double not null,
    longitud double not null,
    creado_en timestamp default current_timestamp,
    foreign key (usuario) references Usuario(id_usuario) on delete cascade
);

/* Destinos favoritos por usuario */
create table FavoritoDestino (
    id_favorito int primary key auto_increment,
    usuario int not null,
    nombre varchar(100),
    direccion text,
    latitud double not null,
    longitud double not null,
    creado_en timestamp default current_timestamp,
    unique key uniq_usuario_destino (usuario, latitud, longitud),
    foreign key (usuario) references Usuario(id_usuario) on delete cascade
);

/*Llenar Datos de Tipo*/
insert into TipoUsuario(Tipo) values('Administrador');
insert into TipoUsuario(Tipo) values('Usuario');
insert into TipoUsuario(Tipo) values('Piloto');

insert into TipoParada(Tipo) values('Inicio');
insert into TipoParada(Tipo) values('Normal');
insert into TipoParada(Tipo) values('Final');

insert into TipoTransporte(Tipo) values('Camioneta');
insert into TipoTransporte(Tipo) values('Transurbano');
insert into TipoTransporte(Tipo) values('Transmetro');
insert into TipoTransporte(Tipo) values('Express');
insert into TipoTransporte(Tipo) values('Tubus');





/*Transmetro*/

-- LÃ­nea 1
insert into Ruta(id_Ruta,Nombre_Ruta,Descripcion_Ruta) values(1,'LÃ­nea 1','San SebastiÃ¡n Z.1/Centro CÃ­vico Z.1');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,1,14.6457451,-90.5131468,'San SebastiÃ¡n');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,1,14.6425645,-90.5114632,'Mercado Central');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,1,14.6371129,-90.5122047,'Correos');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,1,14.6339364,-90.5126455,'Beatas de Belen');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,1,14.6297123,-90.5137232,'Paseo de las Letras');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,1,14.6277588,-90.5148665,'Centro CÃ­vico');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,1,14.63128,-90.516503,'Sur 2');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,1,14.634316,-90.5160349,'GÃ³mez Carillo');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,1,14.6385161,-90.5153216,'San AgustÃ­n');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,1,14.6422271,-90.5148797,'Parque Centenario');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(3,1,14.6457451,-90.5131468,'San SebastiÃ¡n');
insert into Transporte(Tipo_Transporte, Ruta, Piloto) values(3,1,null);

-- LÃ­nea 2
insert into Ruta(id_Ruta,Nombre_Ruta,Descripcion_Ruta) values(2,'LÃ­nea 2','HipÃ³dromo Z.2/San SebastiÃ¡n Z.1');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,2,14.6590814,-90.5099774,'HipÃ³dromo del Norte');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,2,14.653887, -90.511963,'San JosÃ© de la MontaÃ±a');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,2,14.650831,-90.5157085,'Jocotenango');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,2,14.6457451,-90.5131468,'San SebastiÃ¡n');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,2,14.654611, -90.511580,'SimeÃ³n CaÃ±as');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(3,2,14.6590814,-90.5099774,'HipÃ³dromo del Norte');
insert into Transporte(Tipo_Transporte, Ruta, Piloto) values(3,2,null);

-- LÃ­nea 6
insert into Ruta(id_Ruta, Nombre_Ruta,Descripcion_Ruta) values(3,'LÃ­nea 6','Proyectos Z.6/Fegua Z.1');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,3,14.673201,-90.4893014,'Proyectos');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,3,14.6674985,-90.4942507,'Proyectos 4-4');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,3,14.6655402,-90.4936423,'Cipresales');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,3,14.6582632,-90.4965808,'Quintanal');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,3,14.6561286,-90.4972925,'Corpus Christi');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,3,14.6528088,-90.5000039,'Jose MartÃ­');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,3,14.6481245,-90.5049112,'Cerro del Carmen');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,3,14.6442144,-90.5094533,'Santa Teresa');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,3,14.6385546,-90.5098923,'Capuchinas');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,3,14.6305281,-90.5116328,'Fegua');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,3,14.6326444,-90.5093697,'Francos y Monroy');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,3,14.639986,-90.5083689,'ColÃ³n');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,3,14.6481245,-90.5049112,'Cerro del Carmen');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,3,14.6498976,-90.5005107,'Parroquia');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,3,14.6517092,-90.5798591,'IGSS Zona 6');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,3,14.6549879,-90.5784265,'Centro Zona 6');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,3,14.6570966,-90.4894869,'Academia');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,3,14.6655402,-90.4936423,'Cipresales');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,3,14.6674985,-90.4942507,'Proyectos 4-4');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(3,3,14.673201,-90.4893014,'Proyectos');
insert into Transporte(Tipo_Transporte, Ruta, Piloto) values(3,3,null);

-- LÃ­nea 7
insert into Ruta(id_Ruta,Nombre_Ruta,Descripcion_Ruta) values(4,'LÃ­nea 7','USAC Periferico Zona 12 Z.12/La Merced Z.1');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,4,14.5927398,-90.5505368,'USAC Periferico');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,4,14.5997076,-90.5591684,'Granal');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,4,14.6068442,-90.5589287,'Rodolfo Robles');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,4,14.6094422,-90.6388579,'Cejusa');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,4,14.6183779,-90.6381403,'San Jorge');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,4,14.6262843,-90.6406989,'Roosevelt');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,4,14.6304393,-90.6370945,'San Juan');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,4,14.6383379,-90.6329443,'Ciudad de Plata II');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,4,14.6413726,-90.6286794,'Villa Linda');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,4,14.6449135,-90.6221249,'4 de Febrero');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,4,14.6455911,-90.6188323,'Bethania');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,4,14.6486923,-90.6133907,'Incienso');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,4,14.6411843,-90.6014382,'San Juan de Dios');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,4,14.6406252,-90.5954109,'Pasaje Aycinena');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,4,14.6431113,-90.5903584,'La Merced');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,4,14.6441873,-90.593337,'Cruz Roja');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,4,14.6424722,-90.5980482,'Archivo General');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,4,14.6420881,-90.5193033,'Santuario de Guadalupe');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,4,14.6487936,-90.5313982,'Incienso');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,4,14.6458905,-90.5368125,'Bethania');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,4,14.6445073,-90.5408253,'4 de Febrero');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,4,14.6422299,-90.5455028,'Villa Linda');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,4,14.6384895,-90.5507534,'Ciudad de Plata II');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,4,14.6304204,-90.5549736,'San Juan');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,4,14.6260413,-90.5590093,'Roosevelt');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,4,14.6192974,-90.5565562,'San Jorge');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,4,14.6100951,-90.5564313,'Cejusa');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,4,14.6076733,-90.558094,'Rodolfo Robles');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,4,14.5995722,-90.5595305,'Granal');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(3,4,14.5927398,-90.5505368,'USAC Periferico');
insert into Transporte(Tipo_Transporte, Ruta, Piloto) values(3,4,null);

-- LÃ­nea 12
insert into Ruta(id_Ruta,Nombre_Ruta,Descripcion_Ruta) values(5,'LÃ­nea 12','Centra Sur/Plaza Barrios Z.1');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,5,14.5644738,-90.5637593,'Centra Sur');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,5,14.5806311,-90.5679521,'Monte MarÃ­a');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,5,14.5869636,-90.5628031,'Javier');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,5,14.5869636,-90.5628031,'Las Charcas');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,5,14.5963309,-90.555506,'El Carmen');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,5,14.6010262,-90.5496041,'Reformita');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,5,14.6047193,-90.5450986,'Mariscal');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,5,14.61267,-90.535721,'El Trebol');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,5,14.6145729,-90.5331221,'Santa Cecilia');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,5,14.6190615,-90.5278149,'Bolivar');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,5,14.6250611,-90.522144,'Don Bosco');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,5,14.6275976,-90.5158099,'Plaza Municipal');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,5,14.6301613,-90.5122639,'Plaza Barrios');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,5,14.6313317,-90.5168364,'Plaza El Amate');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,5,14.6250611,-90.522144,'Don Bosco');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,5,14.6198422,-90.5272527,'Bolivar');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,5,14.6145729,-90.5331221,'Santa Cecilia');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,5,14.61267,-90.535721,'El Trebol');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,5,14.6057486,-90.5440659,'Mariscal');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,5,14.6023915,-90.5480005,'Reformita');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,5,14.5963309,-90.555506,'El Carmen');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,5,14.5934766,-90.5584882,'Las Charcas');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,5,14.5869636,-90.5628031,'Javier');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,5,14.5806311,-90.5679521,'Monte MarÃ­a');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(3,5,14.5644738,-90.5637593,'Centra Sur');
insert into Transporte(Tipo_Transporte, Ruta, Piloto) values(3,5,null);

-- LÃ­nea 13
insert into Ruta(id_Ruta,Nombre_Ruta,Descripcion_Ruta) values(6,'LÃ­nea 13 - Ida','Plaza Argentina Z.13/Tipografia Z.1');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,6,14.585852,-90.522537,'Plaza Argentina');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,6,14.5920665,-90.520798,'Los Arcos');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,6,14.5997194,-90.5191374,'Plaza EspaÃ±a');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,6,14.6040911,-90.5183364,'IGSS Zona 9');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,6,14.6092,-90.5173721,'Seis 26');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,6,14.6141275,-90.5164141,'Torre del Reformador');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,6,14.6196137,-90.5154943,'Plaza de la Republica');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,6,14.62237,-90.5151466,'Canton ExposiciÃ³n');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,6,14.6261688,-90.514641,'Banco de Guatemala');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,6,14.6308822,-90.5143715,'Tipografia');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,6,14.6301984,-90.5155676,'El Calvario');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,6,14.6243445,-90.5163994,'4 Grados Sur');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,6,14.6192992,-90.5171929,'ExposiciÃ³n');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,6,14.6135586,-90.518269,'Terminal');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,6,14.6093975,-90.5190426,'Industria');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,6,14.6044945,-90.520057,'Tivoli');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,6,14.6005326,-90.5207722,'Montufar');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,6,14.5936001,-90.5217228,'Acueducto');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,6,14.5875859,-90.5233684,'Fuerza Aerea');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,6,14.5800731,-90.5243845,'Hangares');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,6,14.585852,-90.522537,'Plaza Argentina');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,6,14.569946,-90.526851,'Plaza BerlÃ­n');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,6,14.574241,-90.524253,'Juan Pablo II');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(3,6,14.585852,-90.522537,'Plaza Argentina');
insert into Transporte(Tipo_Transporte, Ruta, Piloto) values(3,6,null);

-- LÃ­nea 18
insert into Ruta(id_Ruta,Nombre_Ruta,Descripcion_Ruta) values(7,'LÃ­nea 18','AtlÃ¡ntida Z.18/Fegua Z.1');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,7,14.6510493,-90.4779899,'AtlÃ¡ntida');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,7,14.6484275,-90.4934376,'Victorias');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,7,14.6449348,-90.4964517,'San MartÃ­n');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,7,14.6385546,-90.5098923,'Capuchinas');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,7,14.6305281,-90.5116328,'Fegua');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,7,14.6326444,-90.5093697,'Francos Monroy');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,7,14.639986,-90.5083689,'ColÃ³n');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,7,14.6481245,-90.5049112,'Cerro del Carmen');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,7,14.6452716,-90.4967263,'San MartÃ­n');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,7,14.6484275,-90.4934376,'Victorias');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,7,14.6487306,-90.4819879,'Portales');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,7,14.6510201,-90.4779892,'AtlÃ¡ntida');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,7,14.654982,-90.4520612,'San Rafael');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,7,14.6589799,-90.4466713,'Paraiso');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,7,14.654982,-90.4520612,'San Rafael');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(3,7,14.6510493,-90.4779899,'AtlÃ¡ntida');
insert into Transporte(Tipo_Transporte, Ruta, Piloto) values(3,7,null);

/*Tubus*/

-- Ruta 5
insert into Ruta(id_Ruta,Nombre_Ruta,Descripcion_Ruta) values(8,'Ruta 5','Parque ColÃ³n Z.1/Puente de la Penitenciaria Z.4');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,8,14.639506,-90.507199,'Parque ColÃ³n');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,8,14.635417,-90.493313,'Cipreses Sur');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,8,14.632392,-90.494629,'Jardin de la AsunciÃ³n Sur');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,8,14.626814,-90.495695,'Arrivillaga');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,8,14.624372,-90.499584,'Vivibien');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,8,14.622502,-90.506793,'Mercado La Palmita');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,8,14.622983,-90.512408,'Palacio de los Deportes Sur');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,8,14.624905,-90.51506,'Penitenciaria');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,8,14.622884,-90.512888,'Palacio de los Deportes Norte');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,8,14.621709,-90.505708,'La Palmita');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,8,14.624694,-90.501337,'Parque Navidad');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,8,14.626814,-90.495695,'Arrivillaga');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,8,14.633008,-90.494228,'Jardin de la AsunciÃ³n Norte');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,8,14.636173,-90.493209,'Cipreses Norte');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,8,14.6404609,-90.5037806,'Matamoros');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(3,8,14.639506,-90.507199,'Parque ColÃ³n');
insert into Transporte(Tipo_Transporte, Ruta, Piloto) values(5,8,null);

-- Ruta 104
insert into Ruta(id_Ruta,Nombre_Ruta,Descripcion_Ruta) values(9,'Ruta 104','Barrio San Antonio Z.6/Cementerio La Villa Z.14');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,9,14.658221,-90.486817,'#001 Barrio San Antonio');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,9,14.65527,-90.489158,'#002 Barrio San Antonio');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,9,14.653312,-90.489939,'#003 Barrio San Antonio');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,9,14.651462,-90.490644,'#004 Barrio San Antonio');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,9,14.652241,-90.493353,'#005 8a. Calle');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,9,14.654173,-90.497746,'#006 8a. Calle');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,9,14.653728,-90.500033,'#007 14 Avenida');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,9,14.647558,-90.501714,'#008 Barrio La Parroquia');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,9,14.644703,-90.503346,'#009 Barrio San JosÃ©');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,9,14.642461,-90.504586,'#010 Barrio San JosÃ©');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,9,14.640158,-90.505245,'#011 Barrio San JosÃ©');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,9,14.639829,-90.507202,'#012 Parque ColÃ³n');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,9,14.63637,-90.507651,'#013 Barrio Gerona');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,9,14.633291,-90.508069,'#014 Barrio Gerona');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,9,14.62909,-90.508619,'#015 12 Avenida');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,9,14.623805,-90.509396,'#016 Col. 25 de Junio');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,9,14.619408,-90.50999,'#017 Col. San Pedrito');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,9,14.615398,-90.510546,'#018 Col. San Pedrito');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,9,14.609624,-90.510407,'#019 6a. Avenida');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,9,14.606162,-90.510454,'#020 Ciudad Vieja');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,9,14.601929,-90.509963,'#021 Col. Las Margaritas');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,9,14.599299,-90.508606,'#022 Diagonal 6');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,9,14.596586,-90.507194,'#023 Col. Oakland');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,9,14.594364,-90.50547,'#024 Col. Oakland');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,9,14.589302,-90.50307,'#025 Col. La Villa');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,9,14.583789,-90.504708,'#026 CantÃ³n 21');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,9,14.583845,-90.50833,'#027 CantÃ³n 21');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,9,14.579862,-90.50966,'#028 CantÃ³n Victoria');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,9,14.580986,-90.50868,'#029 Cementerio La Villa');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,9,14.5804505,-90.506172,'#062 9a. Calle');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,9,14.583473,-90.504738,'#030 CantÃ³n 21');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,9,14.581542,-90.50037,'#031 CantÃ³n 21');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,9,14.580317,-90.498559,'#032 CantÃ³n 21');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,9,14.584335,-90.499592,'#033 20 Calle');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,9,14.585863,-90.501028,'#034 20 Calle');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,9,14.589579,-90.503075,'#035 Col. La Villa');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,9,14.59356,-90.504676,'#036 Col. Oakland');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,9,14.597004,-90.507197,'#037 Col. Oakland');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,9,14.598441,-90.50785,'#038 Diagonal 6');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,9,14.60167,-90.50961,'#039 Col. Las Margaritas');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,9,14.604486,-90.513787,'#040 Ciudad Vieja');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,9,14.607666,-90.512912,'#041 Ciudad Vieja');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,9,14.610324,-90.512553,'#042 2a. Avenida');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,9,14.614844,-90.511778,'#043 2a. Avenida');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,9,14.617768,-90.511254,'#044 Col. San Pedrito');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,9,14.622104,-90.511945,'#045 10a. Avenida');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,9,14.624319,-90.511559,'#046 10a. Avenida');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,9,14.629992,-90.509721,'#047 11 Avenida');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,9,14.633141,-90.50929,'#048 11 Avenida');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,9,14.636182,-90.50888,'#049 11 Avenida');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,9,14.641064,-90.508206,'#050 11 Avenida');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,9,14.642325,-90.507075,'#051 5a. Calle');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,9,14.643702,-90.504546,'#052 Barrio San JosÃ©');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,9,14.647551,-90.502681,'#053 Barrio Candelaria');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,9,14.649471,-90.501843,'#054 Barrio La Parroquia');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,9,14.652793,-90.49948,'#062 7a. Calle');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,9,14.651255,-90.497395,'#055 6a. Calle');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,9,14.650809,-90.493767,'#056 6a. Calle');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,9,14.651224,-90.490624,'#057 Barrio San Antonio');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,9,14.653041,-90.489911,'#058 Barrio San Antonio');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,9,14.65613,-90.487587,'#059 Barrio San Antonio');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,9,14.657947,-90.486882,'#060 Barrio San Antonio');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(3,9,14.658221,-90.486817,'#001 Barrio San Antonio');
insert into Transporte(Tipo_Transporte, Ruta, Piloto) values(5,9,null);

-- Ruta 305
insert into Ruta(id_Ruta,Nombre_Ruta,Descripcion_Ruta) values(10,'Ruta 305','Blvr. Vista Hermosa Z.15/Terminal 5a. Avenida y 2a. Calle Z.9');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,10,14.582059,-90.485073,'#133 Blvr. Vista Hermosa');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,10,14.5858262,-90.4879694,'#134 Blvr. Vista Hermosa');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,10,14.589167,-90.490422,'#135 Blvr. Vista Hermosa');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,10,14.592508,-90.4929388,'#136 Blvr. Vista Hermosa');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,10,14.5947288,-90.4945431,'#137 Blvr. Vista Hermosa');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,10,14.600847,-90.498926,'#138 Blvr. Vista Hermosa');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,10,14.605748,-90.501301,'#139 Blvr. Vista Hermosa');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,10,14.614229,-90.504425,'#140 Blvr. de la Tribuna');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,10,14.6140648,-90.5094579,'#141 6a. Avenida A');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,10,14.614004,-90.512886,'#142 JardÃ­n BotÃ¡nico');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,10,14.6144143,-90.5160973,'#143 JardÃ­n BotÃ¡nico');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,10,14.613394,-90.5195768,'#144 Terminal');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,10,14.6126074,-90.514851,'#145 JardÃ­n BotÃ¡nico');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,10,14.612186,-90.512555,'#146 GuardÃ­a de Honor');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,10,14.605907,-90.501636,'#147 Blvr. Vista Hermosa');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,10,14.600528,-90.49952,'#148 Plaza de la Marimba');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,10,14.596695,-90.496657,'#149 Blvr. Vista Hermosa');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,10,14.594285,-90.494762,'#150 Blvr. Vista Hermosa');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,10,14.592397,-90.493358,'#151 Blvr. Vista Hermosa');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,10,14.5889096,-90.4907498,'#152 Blvr. Vista Hermosa');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,10,14.5855751,-90.488259,'#153 Blvr. Vista Hermosa');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(3,10,14.582059,-90.485073,'#133 Blvr. Vista Hermosa');
insert into Transporte(Tipo_Transporte, Ruta, Piloto) values(5,10,null);

-- Ruta 801
insert into Ruta(id_Ruta,Nombre_Ruta,Descripcion_Ruta) values(11,'Ruta 801','Parque Los Pinos Z.7/Terminal 4a. Av. y 4a. Calle Z.9');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,11,14.659797,-90.528477,'#063 Parque Los Pinos');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,11,14.657044,-90.529952,'#064 Col. Sakerty I');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,11,14.654922,-90.531066,'#065 Col. Sakerty II');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,11,14.651214,-90.533102,'#066 Col. Banvi I');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,11,14.649813,-90.534145,'#067 Col. Bethania');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,11,14.647769,-90.535628,'#068 Col. Bethania');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,11,14.646152,-90.536846,'#069 Col. Kjell Laugerud');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,11,14.645051,-90.539993,'#070 Col. NiÃ±o Dormido');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,11,14.643849,-90.542134,'#071 El Incienso');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,11,14.6425,-90.545315,'#072 Cond. Bosques de Linda Villa');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,11,14.640516,-90.54735,'#073 Ciudad de Plata II');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,11,14.637743,-90.546683,'#074 Ciudad de Plata I');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,11,14.634277,-90.547598,'#075 Ciudad de Plata I');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,11,14.628732,-90.545297,'#076 Col. Quinta Samayoa');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,11,14.6259236,-90.543059,'#077 Col. Quinta Samayoa');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,11,14.6219794,-90.5417077,'#078 9a. Avenida');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,11,14.620595,-90.543529,'#079 9a. Avenida');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,11,14.619092,-90.543187,'#080 Calz. San Juan');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,11,14.61647,-90.5403167,'#081 Calz. Roosevelt');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,11,14.61384,-90.535921,'#082 Calz. Roosevelt');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,11,14.612177,-90.534638,'#083 Blvr. LiberaciÃ³n');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,11,14.6086514,-90.5320664,'#084 Blvr. LiberaciÃ³n');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,11,14.606431,-90.527203,'#085 Avenida La Castellana');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,11,14.60854,-90.526215,'#086 Avenida La Castellana');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,11,14.610788,-90.5212,'#087 La Terminal');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,11,14.61083,-90.523074,'#088 CantÃ³n TÃ­voli');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,11,14.609842,-90.525858,'#089 Avenida La Castellana');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,11,14.60591,-90.527709,'#090 Avenida La Castellana');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,11,14.6090215,-90.5317791,'#091 Blvr. LiberaciÃ³n');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,11,14.612242,-90.533961,'#092 Blvr. LiberaciÃ³n');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,11,14.614043,-90.535466,'#093 Calz. Roosevelt');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,11,14.61589,-90.538006,'#094 Calz. Roosevelt');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,11,14.6190266,-90.5426927,'#095 Col. Quinta Samayoa');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,11,14.6222846,-90.5436798,'#096 Col. Quinta Samayoa');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,11,14.623307,-90.542322,'#097 Col. Quinta Samayoa');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,11,14.626064,-90.542945,'#098 Col. Castillo Lara');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,11,14.629781,-90.545939,'#099 Col. Quinta Samayoa');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,11,14.63451,-90.547428,'#100 Col. Kaminal JuyÃº II');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,11,14.637737,-90.546556,'#101 Col. Ciudad de Plata II');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,11,14.640923,-90.54621,'#102 Col. Mario Julio Salazar');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,11,14.643297,-90.542633,'#103 Col. El Incienso');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,11,14.64477,-90.539829,'#104 Col. 4 de Febrero');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,11,14.6473865,-90.5358312,'#105 AlcaldÃ­a Auxiliar Z.7');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,11,14.649547,-90.534113,'#106 Col. Bethania');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,11,14.65149,-90.532673,'#107 Parque TecÃºn UmÃ¡n');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,11,14.6550897,-90.5307587,'#108 Col. Sakerty II');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,11,14.657175,-90.529628,'#109 Col. Sakerty I');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(3,11,14.659797,-90.528477,'#063 Parque Los Pinos');
insert into Transporte(Tipo_Transporte, Ruta, Piloto) values(5,11,null);

-- Ruta 802
insert into Ruta(id_Ruta,Nombre_Ruta,Descripcion_Ruta) values(12,'Ruta 801','Parque Los Pinos Z.7/Terminal 4a. Av. y 4a. Calle Z.9');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,12,14.659797,-90.528477,'#063 Parque Los Pinos');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,12,14.657044,-90.529952,'#064 Col. Sakerty I');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,12,14.654922,-90.531066,'#065 Col. Sakerty II');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,12,14.651214,-90.533102,'#066 Col. Banvi I');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,12,14.649813,-90.534145,'#067 Col. Bethania');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,12,14.647769,-90.535628,'#068 Col. Bethania');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,12,14.645513,-90.536389,'#110 Anillo PerifÃ©rico norte');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,12,14.648802,-90.53079,'#111 Anillo PerifÃ©rico norte');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,12,14.648647,-90.529282,'#112 Anillo PerifÃ©rico norte');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,12,14.64489,-90.525071,'#113 Anillo PerifÃ©rico norte');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,12,14.649127,-90.519209,'#114 Barrio RecolecciÃ³n');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,12,14.648726,-90.516348,'#115 Barrio RecolecciÃ³n');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,12,14.647346,-90.51502,'#116 Barrio RecolecciÃ³n');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,12,14.643776,-90.515504,'#117 Barrio RecolecciÃ³n');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,12,14.64083,-90.515928,'#118 4a. Avenida');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,12,14.638553,-90.516224,'#119 4a. Avenida');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,12,14.634046,-90.516864,'#120 4a. Avenida');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,12,14.630678,-90.517283,'#121 4a. Avenida');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,12,14.630432,-90.518585,'#122 El Pueblito');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,12,14.6334165,-90.518203,'#123 3a. Avenida');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,12,14.6371046,-90.5176494,'#124 3a. Avenida');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,12,14.640794,-90.51715,'#125 3a. Avenida');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,12,14.6428917,-90.516845,'#126 3a. Avenida');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,12,14.645277,-90.51767,'#127 Barrio RecolecciÃ³n');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,12,14.6457363,-90.5206923,'#128 Barrio RecolecciÃ³n');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,12,14.6428625,-90.5216373,'#129 Avenida Elena');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,12,14.64894,-90.529255,'#130 Anillo PerifÃ©rico sur');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,12,14.648999,-90.531015,'#131 Col. Madre Dormida');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,12,14.645743,-90.535319,'#132 Anillo PerifÃ©rico sur');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,12,14.6473865,-90.5358312,'#105 AlcaldÃ­a Auxiliar Z.7');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,12,14.649547,-90.534113,'#106 Col. Bethania');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,12,14.65149,-90.532673,'#107 Parque TecÃºn UmÃ¡n');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,12,14.6550897,-90.5307587,'#108 Col. Sakerty II');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,12,14.657175,-90.529628,'#109 Col. Sakerty I');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(3,12,14.659797,-90.528477,'#063 Parque Los Pinos');
insert into Transporte(Tipo_Transporte, Ruta, Piloto) values(5,12,null);

/*Transurbano*/

-- Ruta 250
insert into Ruta(id_Ruta,Nombre_Ruta,Descripcion_Ruta) values(13,'Ruta 250','NimajuyÃº - Obelisco');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,13,14.596204,-90.521164,'Dennys');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,13,14.598901,-90.524195,'Aurora');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,13,14.599973,-90.529736,'7a Avenida Y 5a Calle');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,13,14.601024,-90.532152,'5a Calle, 612');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,13,14.602381,-90.533169,'5a Calle Y 3a Avenida');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,13,14.604713,-90.535454,'5a Calle Y Calzada Atanasio Tzul');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,13,14.604339,-90.537579,'14a Avenida, 9-55');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,13,14.602917,-90.538877,'Calzada Atanasio Tzul, 11-73');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,13,14.601463,-90.53951,'Calzada Atanasio Tzul, 1502');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,13,14.598743,-90.5401,'17 Calle A, 17-28');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,13,14.595284,-90.540822,'Calzada Atanasio Tzul, 26');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,13,14.592104,-90.541422,'24 Calle, 23-27');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,13,14.588875,-90.542055,'Calzada Atanasio Tzul, 3118');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,13,14.58413,-90.542999,'35 Calle, 25c');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,13,14.57491,-90.542495,'Calzada Atanasio Tzul, 4214');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,13,14.56719,-90.544442,'46 Calle, 2189');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,13,14.561468,-90.54676,'Calzada Atanasio Tzul, 49-25');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,13,14.556382,-90.548252,'5a Calle, 2191');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,13,14.554448,-90.549493,'Bellos Horizontes');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,13,14.55131,-90.550806,'AlcaldÃ­a');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,13,14.54895,-90.549192,'Calle 12 / Avda. 17');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,13,14.54485,-90.548523,'14 Calle, 2815');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,13,14.543517,-90.549677,'14 Calle, 2815');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,13,14.546025,-90.552212,'14 Calle, 1650');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,13,14.548664,-90.551586,'Avda. 16 / Calle 12');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,13,14.552262,-90.550112,'AlcaldÃ­a');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,13,14.554552,-90.549139,'Bellos Horizontes');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,13,14.556575,-90.547673,'5ta Avenida, 576');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,13,14.562419,-90.545985,'Calzada Atanasio Tzul, 49-0');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,13,14.566598,-90.544377,'Calzada Atanasio Tzul, 4515');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,13,14.574494,-90.542109,'Calzada Atanasio Tzul, 42-14');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,13,14.583704,-90.542721,'35 Calle, 23-50');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,13,14.588917,-90.54168,'Calzada Atanasio Tzul, 3118');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,13,14.591523,-90.5411,'Calzada Atanasio Tzul, 24');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,13,14.594744,-90.540446,'Calzada Atanasio Tzul, 27');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,13,14.599013,-90.539596,'Calzada Atanasio Tzul, 1667');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,13,14.601327,-90.53891,'13 Calle, 16-70');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,13,14.601577,-90.537807,'18 Avenida, 12-03');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,13,14.602912,-90.536565,'18 Avenida, 10-17');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,13,14.604166,-90.53542,'18 Avenida, 8-13');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,13,14.602754,-90.533754,'5 Calle, 46');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,13,14.601255,-90.532674,'5a Calle, 475');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,13,14.598619,-90.529829,'Escuela Normal Para Varones');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(3,13,14.599473,-90.525065,'ZoolÃ³gico La Aurora');
insert into Transporte(Tipo_Transporte, Ruta, Piloto) values(2,13,null);

-- Ruta 281
insert into Ruta(id_Ruta,Nombre_Ruta,Descripcion_Ruta) values(14,'Ruta 281','Guajitos Zona 21 - Avenida La Castellana Zona 9 - Termina');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,14,14.61248,-90.519941,'5a Avenida, 2-66');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,14,14.610462,-90.520376,'5a Avenida, 449');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,14,14.61067,-90.52206,'CantÃ³n TÃ­voli');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,14,14.610628,-90.525526,'5a Calle, 856');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,14,14.608936,-90.526373,'15 Avenida, 39-39');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,14,14.60688,-90.527285,'Avenida La Castellana, 41');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,14,14.605095,-90.5281,'Avenida La Castellana, 42');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,14,14.60866,-90.533987,'EstaciÃ³n 127 14 Avenida 3 Calle I');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,14,14.607841,-90.536246,'12a Avenida, 5-76');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,14,14.608723,-90.537244,'Avenida Petapa, 521');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,14,14.60811,-90.537899,'TrÃ©bolito');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,14,14.605485,-90.5392,'10a Avenida, 994a');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,14,14.603846,-90.540007,'Avenida Petapa, 11-80');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,14,14.599749,-90.542284,'14a Avenida, 16-72');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,14,14.598655,-90.543295,'EstaciÃ³n 115 14 Av 18 Calle');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,14,14.597341,-90.544082,'14a Avenida, 20-39');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,14,14.593828,-90.544764,'Avenida Petapa, 2314');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,14,14.589026,-90.545285,'Usac');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,14,14.583501,-90.545952,'Avenida Petapa, 3540');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,14,14.579103,-90.546446,'39 Calle, 1840');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,14,14.569886,-90.548727,'Avenida Petapa, 44');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,14,14.567498,-90.545867,'EstaciÃ³n 82 46 Calle Calz Atanasio Tzul (Dir Sur)');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,14,14.561468,-90.54676,'Calzada Atanasio Tzul, 49-25');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,14,14.558864,-90.546629,'5a Avenida A');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,14,14.55766,-90.544864,'4a Calle A / 0 Avenida');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,14,14.556773,-90.542927,'4a Calle A / 2a Avenida');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,14,14.557412,-90.540979,'3a Calle / 3a Avenida');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,14,14.556887,-90.537874,'3a Calle / 5a Avenida');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,14,14.55556,-90.537991,'5a Avenida / 4a Calle');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,14,14.555223,-90.537122,'4a Calle / 5a Avenida B');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,14,14.555092,-90.536342,'4a Calle / 6a Avenida');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,14,14.555281,-90.536931,'4a Calle / 5a Avenida B');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,14,14.555465,-90.537881,'4a Calle / 5a Avenida');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,14,14.555703,-90.539379,'4a Calle / 4a Avenida');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,14,14.555827,-90.540212,'4a Calle / 8a Avenida B');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,14,14.555971,-90.541029,'4a Calle / 3a Avenida');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,14,14.556236,-90.542558,'4a Calle / 2a Avenida');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,14,14.556936,-90.543115,'4a Calle A / 6a Avenida');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,14,14.557771,-90.54477,'4a Calle A / 0 Avenida');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,14,14.559493,-90.546087,'4a Calle A / 5a Avenida A');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,14,14.562419,-90.545985,'Calzada Atanasio Tzul, 49-0');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,14,14.56742,-90.545476,'46 Calle / Calzada Atanasio Tzul');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,14,14.570067,-90.548317,'Avenida Petapa, 44');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,14,14.575536,-90.546486,'EstaciÃ³n 100 Av. Petapa 42 Calle Z. 12 Irtra (Dir Norte)');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,14,14.577959,-90.546234,'Avenida Petapa, 3932');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,14,14.583188,-90.545697,'Avenida Petapa, 3540');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,14,14.587406,-90.545221,'Usac');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,14,14.594506,-90.544489,'Avenida Petapa, 22-27');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,14,14.599451,-90.541892,'Avenida Petapa, 17');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,14,14.60301,-90.540129,'13a Avenida, 12-62');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,14,14.607608,-90.53789,'TrÃ©bolito');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,14,14.609503,-90.537047,'Avenida Petapa / 5a Calle');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,14,14.610948,-90.536316,'EstaciÃ³n 123 (TrÃ©bol)');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,14,14.608624,-90.532019,'Igss');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,14,14.606375,-90.527187,'La Castellana I');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,14,14.608394,-90.526232,'La Castellana II');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(3,14,14.610992,-90.521105,'Terminal');
insert into Transporte(Tipo_Transporte, Ruta, Piloto) values(2,14,null);

-- Ruta 282
insert into Ruta(id_Ruta,Nombre_Ruta,Descripcion_Ruta) values(15,'Ruta 282','Guajitos Z.21 - Av. Santa Cecilia - Centro Z.1 (Parque Central)');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,15,14.555155,-90.536192,'4a Calle / 6a Avenida');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.555281,-90.536931,'4a Calle / 5a Avenida B');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.555465,-90.537881,'4a Calle / 5a Avenida');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.555703,-90.539379,'4a Calle / 4a Avenida');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.555827,-90.540212,'4a Calle / 8a Avenida B');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.555971,-90.541029,'4a Calle / 3a Avenida');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.556236,-90.542558,'4a Calle / 2a Avenida');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.556936,-90.543115,'4a Calle A / 6a Avenida');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.557771,-90.54477,'4a Calle A / 0 Avenida');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.559493,-90.546087,'4a Calle A / 5a Avenida A');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.562419,-90.545985,'Calzada Atanasio Tzul, 49-0');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.56742,-90.545476,'46 Calle / Calzada Atanasio Tzul');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.570067,-90.548317,'Avenida Petapa, 44');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.575536,-90.546486,'EstaciÃ³n 100 Av. Petapa 42 Calle Z. 12 Irtra (Dir Norte)');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.577959,-90.546234,'Avenida Petapa, 3932');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.583188,-90.545697,'Avenida Petapa, 3540');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.587406,-90.545221,'Usac');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.594506,-90.544489,'Avenida Petapa, 22-27');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.599451,-90.541892,'Avenida Petapa, 17');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.60301,-90.540129,'13a Avenida, 12-62');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.607608,-90.53789,'TrÃ©bolito');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.609503,-90.537047,'Avenida Petapa / 5a Calle');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.610948,-90.536316,'EstaciÃ³n 123 (TrÃ©bol)');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.612074,-90.532844,'Grabados');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.611434,-90.531267,'Divina Providencia');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.613766,-90.529412,'Santa Cecilia');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.615674,-90.527961,'La 34 A');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.619638,-90.524905,'La 30');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.622839,-90.522316,'La 28');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.62381,-90.521558,'Don Bosco');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.626044,-90.520813,'La 24');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.631325,-90.516825,'Plaza El Amate');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.633848,-90.518081,'La 15');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.636368,-90.517725,'3a Avenida, 13-2');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.638422,-90.517436,'3a Avenida, 1147');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.640571,-90.517071,'3a Avenida Y 9a Calle');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.64219,-90.5169,'3a Avenida, 710');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.642564,-90.515698,'4a Avenida, 6-40');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.640867,-90.515956,'4a Avenida');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.638645,-90.516256,'4a Avenida');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.636576,-90.516524,'4a Avenida, 12-78');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.63409,-90.516899,'4a Avenida Y 15 Calle');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.632232,-90.517135,'4a Avenida, 16-48');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.630768,-90.517318,'El Amate');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.62728,-90.519598,'La 22');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.624424,-90.518832,'Escuela');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.6205,-90.521226,'La 28 B');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.616173,-90.524359,'La 32 A');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.614307,-90.525283,'La 32 A');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.610997,-90.527393,'La 39');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.608737,-90.529044,'La 40 A');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.609031,-90.531762,'LiberaciÃ³n');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.612251,-90.533996,'TrÃ©bol II');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.60866,-90.533987,'EstaciÃ³n 127 14 Avenida 3 Calle I');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.607841,-90.536246,'12a Avenida, 5-76');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.608723,-90.537244,'Avenida Petapa, 521');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.60811,-90.537899,'TrÃ©bolito');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.605485,-90.5392,'10a Avenida, 994a');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.603846,-90.540007,'Avenida Petapa, 11-80');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.599749,-90.542284,'14a Avenida, 16-72');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.598655,-90.543295,'EstaciÃ³n 115 14 Av 18 Calle');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.597341,-90.544082,'14a Avenida, 20-39');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.593828,-90.544764,'Avenida Petapa, 2314');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.589026,-90.545285,'Usac');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.583501,-90.545952,'Avenida Petapa, 3540');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.579103,-90.546446,'39 Calle, 1840');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.569886,-90.548727,'Avenida Petapa, 44');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.567498,-90.545867,'EstaciÃ³n 82 46 Calle Calz Atanasio Tzul (Dir Sur)');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.561468,-90.54676,'Calzada Atanasio Tzul, 49-25');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.558864,-90.546629,'5a Avenida A');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.55766,-90.544864,'4a Calle A / 0 Avenida');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.556773,-90.542927,'4a Calle A / 2a Avenida');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.557412,-90.540979,'3a Calle / 3a Avenida');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.556887,-90.537874,'3a Calle / 5a Avenida');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.55556,-90.537991,'5a Avenida / 4a Calle');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.555223,-90.537122,'4a Calle / 5a Avenida B');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,15,14.555223,-90.537122,'4a Calle / 5a Avenida B');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(3,15,14.555092,-90.536342,'4a Calle / 6a Avenida');
insert into Transporte(Tipo_Transporte, Ruta, Piloto) values(2,15,null);

-- Ruta 283
insert into Ruta(id_Ruta,Nombre_Ruta,Descripcion_Ruta) values(16,'Ruta 283','J. R. Barrios Z.21 - Pamplona Z.13 - Obelisco');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,16,14.596204,-90.521164,'Dennys');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,16,14.598901,-90.524195,'Aurora');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,16,14.601124,-90.526051,'Grupo Los 3');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,16,14.603335,-90.530593,'EstaciÃ³n 141 2 Calle Y 4 Avenida Z. 13');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,16,14.605796,-90.533628,'Calzada Anastasio Tzul / 6a Calle');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,16,14.598516,-90.541909,'18 Calle / Avenida Petapa');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,16,14.598655,-90.543295,'EstaciÃ³n 115 14 Av 18 Calle');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,16,14.597341,-90.544082,'14a Avenida, 20-39');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,16,14.593828,-90.544764,'Avenida Petapa, 2314');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,16,14.589026,-90.545285,'Usac');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,16,14.583501,-90.545952,'Avenida Petapa, 3540');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,16,14.579103,-90.546446,'39 Calle, 1840');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,16,14.569886,-90.548727,'Avenida Petapa, 44');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,16,14.56591,-90.549714,'Avenida Petapa, 4736');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,16,14.562188,-90.550507,'Avenida Petapa, 50-28');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,16,14.557292,-90.550643,'Avenida Petapa, 5280');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,16,14.556382,-90.548252,'5a Calle, 2191');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,16,14.554094,-90.544592,'EstaciÃ³n 059 1 Avenida Zona 21');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,16,14.552355,-90.53875,'EstaciÃ³n 063 Calz Justo Rufino Barrios 5 Av (Dir Sur)');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,16,14.551709,-90.535594,'6a Calle / Rotonda');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,16,14.549421,-90.535461,'EstaciÃ³n 066 33 Avenida 8 Calle Zona 21');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,16,14.545918,-90.536495,'EstaciÃ³n 068 33 Avenida 11 Calle Zona 21');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,16,14.541026,-90.537022,'EstaciÃ³n 069 33 Avenida Final Zona 21');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,16,14.540951,-90.536805,'EstaciÃ³n 070 33 Avenida Final Zona 21');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,16,14.547389,-90.53571,'EstaciÃ³n 067 33 Avenida 10 Calle Intecap Zona 21');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,16,14.549616,-90.535163,'33 Avenida / 8a Calle');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,16,14.55219,-90.536079,'EstaciÃ³n 064 Calz Justo Rufino Barrios 6 Av (Dir Norte)');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,16,14.552594,-90.538625,'EstaciÃ³n 062 Calz Justo Rufino Barrios 5 Av (Dir Norte)');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,16,14.552962,-90.542117,'EstaciÃ³n 060 Calz Justo Rufino Barrios 3 Avenida');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,16,14.555103,-90.545069,'EstaciÃ³n 058 Calzada Justo Rufino Barrios Y 1 Av. Z.21');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,16,14.556496,-90.547866,'5a Calle, 2516');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,16,14.557565,-90.550456,'Avenida Petapa, 52');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,16,14.56044,-90.550438,'EstaciÃ³n 093 Av. Petapa Y 53 Calle Z.12');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,16,14.562323,-90.550176,'Avenida Petapa / 50 Calle');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,16,14.565375,-90.549499,'Avenida Petapa, 4896');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,16,14.570067,-90.548317,'Avenida Petapa, 44');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,16,14.575536,-90.546486,'EstaciÃ³n 100 Av. Petapa 42 Calle Z. 12 Irtra (Dir Norte)');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,16,14.583188,-90.545697,'Avenida Petapa, 3540');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,16,14.587406,-90.545221,'Usac');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,16,14.594506,-90.544489,'Avenida Petapa, 22-27');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,16,14.598365,-90.541727,'18 Calle / Avenida Petapa');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,16,14.598077,-90.540308,'18 Calle / Calzada Atanasio Tzul');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,16,14.597211,-90.537781,'EstaciÃ³n 131 18 Calle 28 Avenida');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,16,14.597735,-90.536495,'EstaciÃ³n 132 3 Avenida 17 Calle');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,16,14.60162,-90.534718,'EstaciÃ³n 134 3 Avenida 9 Calle');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,16,14.601255,-90.532674,'5a Calle, 475');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,16,14.597708,-90.530313,'EstaciÃ³n 136 Fischmann');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,16,14.590405,-90.532275,'EstaciÃ³n 137 7 Avenida 11 Calle');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,16,14.588368,-90.532819,'EstaciÃ³n 138 7 Avenida 15 Calle');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,16,14.58674,-90.532837,'15 Calle / 7a Avenida');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,16,14.588408,-90.531421,'EstaciÃ³n 139 Aeropuerto La Aurora');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(3,16,14.595889,-90.525816,'EstaciÃ³n 140 Blvd Juan Pablo II Mercado De ArtesanÃ­as');
insert into Transporte(Tipo_Transporte, Ruta, Piloto) values(2,16,null);

-- Ruta 284
insert into Ruta(id_Ruta,Nombre_Ruta,Descripcion_Ruta) values(17,'Ruta 284','Justo Rufino Barrios Zona 21 - Venezuela Zona 21 - Terminal');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.61248,-90.519941,'5a Avenida, 2-66');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.610462,-90.520376,'5a Avenida, 449');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.61067,-90.52206,'CantÃ³n TÃ­voli');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.610628,-90.525526,'5a Calle, 856');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.608936,-90.526373,'15 Avenida, 39-39');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.60688,-90.527285,'Avenida La Castellana, 41');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.605035,-90.528123,'Avenida La Castellana I');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.609031,-90.531762,'LiberaciÃ³n');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.612251,-90.533996,'TrÃ©bol II');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.612133,-90.53454,'TrÃ©bol II');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.60866,-90.533987,'EstaciÃ³n 127 14 Avenida 3 Calle I');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.607841,-90.536246,'12a Avenida, 5-76');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.608723,-90.537244,'Avenida Petapa, 521');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.60811,-90.537899,'TrÃ©bolito');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.605485,-90.5392,'10a Avenida, 994a');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.603846,-90.540007,'Avenida Petapa, 11-80');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.603366,-90.540243,'Avenida Petapa, 12-40');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.599749,-90.542284,'14a Avenida, 16-72');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.598655,-90.543295,'EstaciÃ³n 115 14 Av 18 Calle');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.597341,-90.544082,'14a Avenida, 20-39');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.593828,-90.544764,'Avenida Petapa, 2314');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.589026,-90.545285,'Usac');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.583501,-90.545952,'Avenida Petapa, 3540');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.579103,-90.546446,'39 Calle, 1840');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.569886,-90.548727,'Avenida Petapa, 44');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.56591,-90.549714,'Avenida Petapa, 4736');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.562188,-90.550507,'Avenida Petapa, 50-28');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.558249,-90.551521,'Avenida Petapa, 5280');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.557292,-90.550643,'Avenida Petapa, 5280');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.556382,-90.548252,'5a Calle, 2191');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.554448,-90.549493,'Bellos Horizontes');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.55131,-90.550806,'AlcaldÃ­a');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.550618,-90.548524,'11 Calle');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.55014,-90.544876,'11 Calle 2');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.551054,-90.541947,'3a Avenida');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.552355,-90.53875,'EstaciÃ³n 063 Calz Justo Rufino Barrios 5 Av (Dir Sur)');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.551709,-90.535594,'6a Calle / Rotonda');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.549421,-90.535461,'EstaciÃ³n 066 33 Avenida 8 Calle Zona 21');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.545918,-90.536495,'EstaciÃ³n 068 33 Avenida 11 Calle Zona 21');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.541026,-90.537022,'EstaciÃ³n 069 33 Avenida Final Zona 21');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.540951,-90.536805,'EstaciÃ³n 070 33 Avenida Final Zona 21');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.547389,-90.53571,'EstaciÃ³n 067 33 Avenida 10 Calle Intecap Zona 21');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.549616,-90.535163,'33 Avenida / 8a Calle');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.55219,-90.536079,'EstaciÃ³n 064 Calz Justo Rufino Barrios 6 Av (Dir Norte)');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.552594,-90.538625,'EstaciÃ³n 062 Calz Justo Rufino Barrios 5 Av (Dir Norte)');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.55149,-90.542061,'53 Calle C, 2-60');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.550213,-90.544324,'11 Calle 3');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.552262,-90.550112,'AlcaldÃ­a');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.554552,-90.549139,'Bellos Horizontes');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.556496,-90.547866,'5a Calle, 2516');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.557565,-90.550456,'Avenida Petapa, 52');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.56044,-90.550438,'EstaciÃ³n 093 Av. Petapa Y 53 Calle Z.12');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.562323,-90.550176,'Avenida Petapa / 50 Calle');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.565375,-90.549499,'Avenida Petapa, 4896');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.570067,-90.548317,'Avenida Petapa, 44');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.575536,-90.546486,'EstaciÃ³n 100 Av. Petapa 42 Calle Z. 12 Irtra (Dir Norte)');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.577959,-90.546234,'Avenida Petapa, 3932');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.583188,-90.545697,'Avenida Petapa, 3540');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.587406,-90.545221,'Usac');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.594506,-90.544489,'Avenida Petapa, 22-27');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.599451,-90.541892,'Avenida Petapa, 17');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.60301,-90.540129,'13a Avenida, 12-62');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.607608,-90.53789,'TrÃ©bolito');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.609503,-90.537047,'Avenida Petapa / 5a Calle');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.608624,-90.532019,'Igss');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.606375,-90.527187,'La Castellana I');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,17,14.608394,-90.526232,'La Castellana II');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(3,17,14.610992,-90.521105,'Terminal');
insert into Transporte(Tipo_Transporte, Ruta, Piloto) values(2,17,null);

-- Ruta 285
insert into Ruta(id_Ruta,Nombre_Ruta,Descripcion_Ruta) values(18,'Ruta 285','Justo Rufino Barrios Zona 21 - Parque Central Zona 1');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,18,14.642329,-90.515724,'Archivo General');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.640867,-90.515956,'4a Avenida');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.638645,-90.516256,'4a Avenida');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.636576,-90.516524,'4a Avenida, 12-78');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.63409,-90.516899,'4a Avenida Y 15 Calle');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.632232,-90.517135,'4a Avenida, 16-48');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.630768,-90.517318,'El Amate');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.62728,-90.519598,'La 22');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.624424,-90.518832,'Escuela');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.6205,-90.521226,'La 28 B');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.616173,-90.524359,'La 32 A');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.614307,-90.525283,'La 33 A');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.610997,-90.527393,'La 39');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.608737,-90.529044,'La 40 A');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.609031,-90.531762,'LiberaciÃ³n');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.612251,-90.533996,'TrÃ©bol II');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.60866,-90.533987,'EstaciÃ³n 127 14 Avenida 3 Calle I');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.607841,-90.536246,'12a Avenida, 5-76');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.608723,-90.537244,'Avenida Petapa, 521');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.60811,-90.537899,'TrÃ©bolito');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.605485,-90.5392,'10a Avenida, 994a');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.603846,-90.540007,'Avenida Petapa, 11-80');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.603366,-90.540243,'Avenida Petapa, 12-40');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.599749,-90.542284,'14a Avenida, 16-72');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.598655,-90.543295,'EstaciÃ³n 115 14 Av 18 Calle');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.597341,-90.544082,'14a Avenida, 20-39');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.593828,-90.544764,'Avenida Petapa, 2314');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.589026,-90.545285,'Usac');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.583501,-90.545952,'Avenida Petapa, 3540');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.579103,-90.546446,'39 Calle, 1840');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.569886,-90.548727,'Avenida Petapa, 44');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.56591,-90.549714,'Avenida Petapa, 4736');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.562188,-90.550507,'Avenida Petapa, 50-28');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.558249,-90.551521,'Avenida Petapa, 5280');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.557292,-90.550643,'Avenida Petapa, 5280');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.556382,-90.548252,'5a Calle, 2191');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.554448,-90.549493,'Bellos Horizontes');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.55131,-90.550806,'AlcaldÃ­a');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.550618,-90.548524,'11 Calle');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.55014,-90.544876,'11 Calle 2');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.551054,-90.541947,'3a Avenida');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.552355,-90.53875,'EstaciÃ³n 063 Calz Justo Rufino Barrios 5 Av (Dir Sur)');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.551709,-90.535594,'6a Calle / Rotonda');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.549421,-90.535461,'EstaciÃ³n 066 33 Avenida 8 Calle Zona 21');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.545918,-90.536495,'EstaciÃ³n 068 33 Avenida 11 Calle Zona 21');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.541026,-90.537022,'EstaciÃ³n 069 33 Avenida Final Zona 21');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.540951,-90.536805,'EstaciÃ³n 070 33 Avenida Final Zona 21');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.547389,-90.53571,'EstaciÃ³n 067 33 Avenida 10 Calle Intecap Zona 21');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.549616,-90.535163,'33 Avenida / 8a Calle');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.55219,-90.536079,'EstaciÃ³n 064 Calz Justo Rufino Barrios 6 Av (Dir Norte)');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.552594,-90.538625,'EstaciÃ³n 062 Calz Justo Rufino Barrios 5 Av (Dir Norte)');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.55149,-90.542061,'53 Calle C, 2-60');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.550213,-90.544324,'11 Calle 3');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.552262,-90.550112,'AlcaldÃ­a');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.554552,-90.549139,'Bellos Horizontes');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.556496,-90.547866,'5a Calle, 2516');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.557565,-90.550456,'Avenida Petapa, 52');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.56044,-90.550438,'EstaciÃ³n 093 Av. Petapa Y 53 Calle Z.12');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.562323,-90.550176,'Avenida Petapa / 50 Calle');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.565375,-90.549499,'Avenida Petapa, 4896');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.570067,-90.548317,'Avenida Petapa, 44');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.575536,-90.546486,'EstaciÃ³n 100 Av. Petapa 42 Calle Z. 12 Irtra (Dir Norte)');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.577959,-90.546234,'Avenida Petapa, 3932');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.583188,-90.545697,'Avenida Petapa, 3540');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.587406,-90.545221,'Usac');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.594506,-90.544489,'Avenida Petapa, 22-27');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.599451,-90.541892,'Avenida Petapa, 17');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.60301,-90.540129,'13a Avenida, 12-62');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.607608,-90.53789,'TrÃ©bolito');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.609503,-90.537047,'Avenida Petapa / 5a Calle');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.610948,-90.536316,'EstaciÃ³n 123 (TrÃ©bol)');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.612074,-90.532844,'Grabados');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.611434,-90.531267,'Divina Providencia');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.613766,-90.529412,'Santa Cecilia');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.615674,-90.527961,'La 34 A');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.619638,-90.524905,'La 30');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.622839,-90.522316,'La 28');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.62381,-90.521558,'Don Bosco');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.626044,-90.520813,'La 24');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.633848,-90.518081,'La 15');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.636368,-90.517725,'3a Avenida, 13-2');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.638422,-90.517436,'3a Avenida, 1147');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,18,14.640571,-90.517071,'3a Avenida Y 9a Calle');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(3,18,14.64219,-90.5169,'3a Avenida, 710');
insert into Transporte(Tipo_Transporte, Ruta, Piloto) values(2,18,null);

-- Ruta 286
insert into Ruta(id_Ruta,Nombre_Ruta,Descripcion_Ruta) values(19,'Ruta 286','J. R. Barrios Z. 21 - TrÃ©bol');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,19,14.610948,-90.536316,'EstaciÃ³n 123 (TrÃ©bol)');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,19,14.60866,-90.533987,'EstaciÃ³n 127 14 Avenida 3 Calle I');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,19,14.607841,-90.536246,'12a Avenida, 5-76');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,19,14.608723,-90.537244,'Avenida Petapa, 521');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,19,14.60811,-90.537899,'TrÃ©bolito');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,19,14.605485,-90.5392,'10a Avenida, 994a');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,19,14.603846,-90.540007,'Avenida Petapa, 11-80');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,19,14.599749,-90.542284,'14a Avenida, 16-72');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,19,14.598655,-90.543295,'EstaciÃ³n 115 14 Av 18 Calle');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,19,14.597341,-90.544082,'14a Avenida, 20-39');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,19,14.593828,-90.544764,'Avenida Petapa, 2314');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,19,14.589026,-90.545285,'Usac');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,19,14.583501,-90.545952,'Avenida Petapa, 3540');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,19,14.579103,-90.546446,'39 Calle, 1840');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,19,14.569886,-90.548727,'Avenida Petapa, 44');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,19,14.56591,-90.549714,'Avenida Petapa, 4736');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,19,14.562188,-90.550507,'Avenida Petapa, 50-28');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,19,14.557292,-90.550643,'Avenida Petapa, 5280');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,19,14.556382,-90.548252,'5a Calle, 2191');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,19,14.554094,-90.544592,'EstaciÃ³n 059 1 Avenida Zona 21');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,19,14.552355,-90.53875,'EstaciÃ³n 063 Calz Justo Rufino Barrios 5 Av (Dir Sur)');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,19,14.551709,-90.535594,'6a Calle / Rotonda');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,19,14.549421,-90.535461,'EstaciÃ³n 066 33 Avenida 8 Calle Zona 21');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,19,14.545918,-90.536495,'EstaciÃ³n 068 33 Avenida 11 Calle Zona 21');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,19,14.541026,-90.537022,'EstaciÃ³n 069 33 Avenida Final Zona 21');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,19,14.540951,-90.536805,'EstaciÃ³n 070 33 Avenida Final Zona 21');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,19,14.547389,-90.53571,'EstaciÃ³n 067 33 Avenida 10 Calle Intecap Zona 21');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,19,14.549616,-90.535163,'33 Avenida / 8a Calle');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,19,14.55219,-90.536079,'EstaciÃ³n 064 Calz Justo Rufino Barrios 6 Av (Dir Norte)');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,19,14.552594,-90.538625,'EstaciÃ³n 062 Calz Justo Rufino Barrios 5 Av (Dir Norte)');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,19,14.552962,-90.542117,'EstaciÃ³n 060 Calz Justo Rufino Barrios 3 Avenida');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,19,14.555103,-90.545069,'EstaciÃ³n 058 Calzada Justo Rufino Barrios Y 1 Av. Z.21');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,19,14.556496,-90.547866,'5a Calle, 2516');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,19,14.557565,-90.550456,'Avenida Petapa, 52');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,19,14.56044,-90.550438,'EstaciÃ³n 093 Av. Petapa Y 53 Calle Z.12');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,19,14.562323,-90.550176,'Avenida Petapa / 50 Calle');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,19,14.565375,-90.549499,'Avenida Petapa, 4896');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,19,14.570067,-90.548317,'Avenida Petapa, 44');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,19,14.575536,-90.546486,'EstaciÃ³n 100 Av. Petapa 42 Calle Z. 12 Irtra (Dir Norte)');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,19,14.577959,-90.546234,'Avenida Petapa, 3932');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,19,14.583188,-90.545697,'Avenida Petapa, 3540');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,19,14.587406,-90.545221,'Usac');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,19,14.594506,-90.544489,'Avenida Petapa, 22-27');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,19,14.599451,-90.541892,'Avenida Petapa, 17');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,19,14.60301,-90.540129,'13a Avenida, 12-62');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,19,14.607608,-90.53789,'TrÃ©bolito');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(3,19,14.610948,-90.536316,'EstaciÃ³n 123 (TrÃ©bol)');
insert into Transporte(Tipo_Transporte, Ruta, Piloto) values(2,19,null);

-- Ruta 287
insert into Ruta(id_Ruta,Nombre_Ruta,Descripcion_Ruta) values(20,'Ruta 287','J. R. Barrios Z. 21 - Av.  Santa Cecilia - Centro Z. 1 (Parque Central)');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,20,14.540951,-90.536805,'EstaciÃ³n 070 33 Avenida Final Zona 21');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.547389,-90.53571,'EstaciÃ³n 067 33 Avenida 10 Calle Intecap Zona 21');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.549616,-90.535163,'33 Avenida / 8a Calle');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.55219,-90.536079,'EstaciÃ³n 064 Calz Justo Rufino Barrios 6 Av (Dir Norte)');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.552594,-90.538625,'EstaciÃ³n 062 Calz Justo Rufino Barrios 5 Av (Dir Norte)');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.552962,-90.542117,'EstaciÃ³n 060 Calz Justo Rufino Barrios 3 Avenida');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.555103,-90.545069,'EstaciÃ³n 058 Calzada Justo Rufino Barrios Y 1 Av. Z.21');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.556496,-90.547866,'5a Calle, 2516');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.557565,-90.550456,'Avenida Petapa, 52');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.56044,-90.550438,'EstaciÃ³n 093 Av. Petapa Y 53 Calle Z.12');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.562323,-90.550176,'Avenida Petapa / 50 Calle');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.565375,-90.549499,'Avenida Petapa, 4896');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.570067,-90.548317,'Avenida Petapa, 44');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.575536,-90.546486,'EstaciÃ³n 100 Av. Petapa 42 Calle Z. 12 Irtra (Dir Norte)');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.577959,-90.546234,'Avenida Petapa, 3932');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.583188,-90.545697,'Avenida Petapa, 3540');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.587406,-90.545221,'Usac');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.594506,-90.544489,'Avenida Petapa, 22-27');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.599451,-90.541892,'Avenida Petapa, 17');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.60301,-90.540129,'13a Avenida, 12-62');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.607608,-90.53789,'TrÃ©bolito');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.610948,-90.536316,'EstaciÃ³n 123 (TrÃ©bol)');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.612074,-90.532844,'Grabados');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.611434,-90.531267,'Divina Providencia');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.613766,-90.529412,'Santa Cecilia');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.615674,-90.527961,'La 34 A');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.619638,-90.524905,'La 30');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.622839,-90.522316,'La 28');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.62381,-90.521558,'Don Bosco');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.626044,-90.520813,'La 24');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.633848,-90.518081,'La 15');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.636368,-90.517725,'3a Avenida, 13-2');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.638422,-90.517436,'3a Avenida, 1147');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.640571,-90.517071,'3a Avenida Y 9a Calle');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.64219,-90.5169,'3a Avenida, 710');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.642564,-90.515698,'4a Avenida, 6-40');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.640867,-90.515956,'4a Avenida');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.638645,-90.516256,'4a Avenida');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.636576,-90.516524,'4a Avenida, 12-78');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.63409,-90.516899,'4a Avenida Y 15 Calle');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.632232,-90.517135,'4a Avenida, 16-48');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.630768,-90.517318,'El Amate');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.62728,-90.519598,'La 22');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.624424,-90.518832,'Escuela');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.6205,-90.521226,'La 28 B');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.616173,-90.524359,'La 32 A');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.614307,-90.525283,'La 33 A');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.610997,-90.527393,'La 39');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.608737,-90.529044,'La 40 A');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.60866,-90.533987,'EstaciÃ³n 127 14 Avenida 3 Calle I');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.607841,-90.536246,'12a Avenida, 5-76');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.608723,-90.537244,'Avenida Petapa, 521');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.60811,-90.537899,'TrÃ©bolito');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.605485,-90.5392,'10a Avenida, 994a');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.603846,-90.540007,'Avenida Petapa, 11-80');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.599749,-90.542284,'14a Avenida, 16-72');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.598655,-90.543295,'EstaciÃ³n 115 14 Av 18 Calle');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.597341,-90.544082,'14a Avenida, 20-39');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.593828,-90.544764,'Avenida Petapa, 2314');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.589026,-90.545285,'Usac');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.583501,-90.545952,'Avenida Petapa, 3540');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.579103,-90.546446,'39 Calle, 1840');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.569886,-90.548727,'Avenida Petapa, 44');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.56591,-90.549714,'Avenida Petapa, 4736');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.562188,-90.550507,'Avenida Petapa, 50-28');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.557292,-90.550643,'Avenida Petapa, 5280');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.556382,-90.548252,'5a Calle, 2191');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.554094,-90.544592,'EstaciÃ³n 059 1 Avenida Zona 21');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.552355,-90.53875,'EstaciÃ³n 063 Calz Justo Rufino Barrios 5 Av (Dir Sur)');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.551709,-90.535594,'6a Calle / Rotonda');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.549421,-90.535461,'EstaciÃ³n 066 33 Avenida 8 Calle Zona 21');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,20,14.545918,-90.536495,'EstaciÃ³n 068 33 Avenida 11 Calle Zona 21');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(3,20,14.541026,-90.537022,'EstaciÃ³n 069 33 Avenida Final Zona 21');
insert into Transporte(Tipo_Transporte, Ruta, Piloto) values(2,20,null);

-- Ruta 288
insert into Ruta(id_Ruta,Nombre_Ruta,Descripcion_Ruta) values(21,'Ruta 288','J. R. Barrios Z. 21 - Av. La Castellana - Terminal');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,21,14.61248,-90.519941,'5a Avenida, 2-66');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,21,14.610462,-90.520376,'5a Avenida, 449');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,21,14.61067,-90.52206,'CantÃ³n TÃ­voli');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,21,14.610628,-90.525526,'5a Calle, 856');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,21,14.608936,-90.526373,'15 Avenida, 39-39');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,21,14.60688,-90.527285,'Avenida La Castellana, 41');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,21,14.60503,-90.528123,'Avenida La Castellana I');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,21,14.609031,-90.531762,'LiberaciÃ³n');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,21,14.612251,-90.533996,'TrÃ©bol II');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,21,14.612133,-90.53454,'TrÃ©bol II');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,21,14.60866,-90.533987,'EstaciÃ³n 127 14 Avenida 3 Calle I');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,21,14.607841,-90.536246,'12a Avenida, 5-76');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,21,14.608723,-90.537244,'Avenida Petapa, 521');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,21,14.60811,-90.537899,'TrÃ©bolito');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,21,14.605485,-90.5392,'10a Avenida, 994a');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,21,14.603846,-90.540007,'Avenida Petapa, 11-80');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,21,14.599749,-90.542284,'14a Avenida, 16-72');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,21,14.598655,-90.543295,'EstaciÃ³n 115 14 Av 18 Calle');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,21,14.597341,-90.544082,'14a Avenida, 20-39');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,21,14.593828,-90.544764,'Avenida Petapa, 2314');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,21,14.589026,-90.545285,'Usac');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,21,14.583501,-90.545952,'Avenida Petapa, 3540');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,21,14.579103,-90.546446,'39 Calle, 1840');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,21,14.569886,-90.548727,'Avenida Petapa, 44');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,21,14.56591,-90.549714,'Avenida Petapa, 4736');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,21,14.562188,-90.550507,'Avenida Petapa, 50-28');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,21,14.557292,-90.550643,'Avenida Petapa, 5280');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,21,14.556382,-90.548252,'5a Calle, 2191');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,21,14.554094,-90.544592,'EstaciÃ³n 059 1 Avenida Zona 21');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,21,14.552355,-90.53875,'EstaciÃ³n 063 Calz Justo Rufino Barrios 5 Av (Dir Sur)');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,21,14.551709,-90.535594,'6a Calle / Rotonda');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,21,14.549421,-90.535461,'EstaciÃ³n 066 33 Avenida 8 Calle Zona 21');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,21,14.545918,-90.536495,'EstaciÃ³n 068 33 Avenida 11 Calle Zona 21');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,21,14.541026,-90.537022,'EstaciÃ³n 069 33 Avenida Final Zona 21');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,21,14.540951,-90.536805,'EstaciÃ³n 070 33 Avenida Final Zona 21');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,21,14.547389,-90.53571,'EstaciÃ³n 067 33 Avenida 10 Calle Intecap Zona 21');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,21,14.549616,-90.535163,'33 Avenida / 8a Calle');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,21,14.55219,-90.536079,'EstaciÃ³n 064 Calz Justo Rufino Barrios 6 Av (Dir Norte)');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,21,14.552594,-90.538625,'EstaciÃ³n 062 Calz Justo Rufino Barrios 5 Av (Dir Norte)');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,21,14.552962,-90.542117,'EstaciÃ³n 060 Calz Justo Rufino Barrios 3 Avenida');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,21,14.555103,-90.545069,'EstaciÃ³n 058 Calzada Justo Rufino Barrios Y 1 Av. Z.21');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,21,14.556496,-90.547866,'5a Calle, 2516');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,21,14.557565,-90.550456,'Avenida Petapa, 52');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,21,14.56044,-90.550438,'EstaciÃ³n 093 Av. Petapa Y 53 Calle Z.12');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,21,14.562323,-90.550176,'Avenida Petapa / 50 Calle');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,21,14.565375,-90.549499,'Avenida Petapa, 4896');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,21,14.570067,-90.548317,'Avenida Petapa, 44');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,21,14.575536,-90.546486,'EstaciÃ³n 100 Av. Petapa 42 Calle Z. 12 Irtra (Dir Norte)');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,21,14.577959,-90.546234,'Avenida Petapa, 3932');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,21,14.583188,-90.545697,'Avenida Petapa, 3540');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,21,14.587406,-90.545221,'Usac');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,21,14.594506,-90.544489,'Avenida Petapa, 22-27');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,21,14.599451,-90.541892,'Avenida Petapa, 17');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,21,14.60301,-90.540129,'13a Avenida, 12-62');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,21,14.607608,-90.53789,'TrÃ©bolito');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,21,14.609503,-90.537047,'Avenida Petapa / 5a Calle');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,21,14.610948,-90.536316,'EstaciÃ³n 123 (TrÃ©bol)');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,21,14.608624,-90.532019,'Igss');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,21,14.608394,-90.526232,'La Castellana II');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(3,21,14.610992,-90.521105,'Terminal');
insert into Transporte(Tipo_Transporte, Ruta, Piloto) values(2,21,null);

/*Express*/

-- Express â€“ Roosevelt â€“ Centro (R10)
insert into Ruta(id_Ruta,Nombre_Ruta,Descripcion_Ruta) values(22,'R10','Express â€“ Roosevelt â€“ Centro');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,22,14.635886,-90.618052,'El Porvenir');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,22,14.634086,-90.616279,'FÃ¡brica');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,22,14.632243,-90.614332,'Corona De Justicia');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,22,14.630114,-90.612366,'Predio');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,22,14.628941,-90.610627,'Subida A La Virgen');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,22,14.631336,-90.60813,'Farmacia Galeno');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,22,14.630173,-90.606663,'Mixco Parque');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,22,14.629016,-90.602897,'Delta');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,22,14.628303,-90.599986,'Puente Doroteo Guamuch');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,22,14.629442,-90.598895,'Licorera');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,22,14.634601,-90.590904,'Molino De Las Flores / Seminario Mayor');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,22,14.63416,-90.582315,'El Tesoro');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,22,14.633688,-90.574422,'Santa Rita');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,22,14.630637,-90.566252,'Colegio Italiano');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,22,14.625816,-90.557269,'Walmart');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,22,14.623656,-90.553245,'Tikal Futura');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,22,14.618843,-90.544293,'La Doce');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,22,14.616996,-90.541336,'Incan');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,22,14.613669,-90.535721,'TrÃ©bol I');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,22,14.612074,-90.532844,'Grabados');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,22,14.611434,-90.531267,'Divina Providencia');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,22,14.613766,-90.529412,'Santa Cecilia');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,22,14.615674,-90.527961,'La 34 A');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,22,14.619638,-90.524905,'La 30');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,22,14.622839,-90.522316,'La 28');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,22,14.62381,-90.521558,'Don Bosco');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,22,14.626044,-90.520813,'La 24');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,22,14.629544,-90.518687,'La 20');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,22,14.632035,-90.518323,'La 17');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,22,14.633848,-90.518081,'La 15');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,22,14.632861,-90.517084,'La 16');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,22,14.630768,-90.517318,'El Amate');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,22,14.62728,-90.519598,'La 22');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,22,14.624424,-90.518832,'Escuela');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,22,14.6205,-90.521226,'La 28 B');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,22,14.616173,-90.524359,'La 32 A');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,22,14.614307,-90.525283,'La 33 A');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,22,14.610997,-90.527393,'La 39');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,22,14.608737,-90.529044,'La 40 A');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,22,14.609031,-90.531762,'LiberaciÃ³n');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,22,14.612251,-90.533996,'TrÃ©bol II');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,22,14.613936,-90.535419,'TrÃ©bol I');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,22,14.615918,-90.538018,'Landivar');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,22,14.61873,-90.543503,'Cruz Verde');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,22,14.623874,-90.552923,'Gran VÃ­a Roosevelt');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,22,14.625899,-90.556765,'Peri-Rooselvelt');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,22,14.631106,-90.56641,'Itzamna');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,22,14.633984,-90.574438,'Centro EspaÃ±ol');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,22,14.634368,-90.581604,'Eskala');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,22,14.634851,-90.590577,'Molino De Las Flores / Seminario Mayor');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,22,14.635169,-90.595765,'Tinco');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,22,14.629618,-90.599196,'Pasarela Licorera');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,22,14.629307,-90.602511,'Cementerio / Delta');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,22,14.630266,-90.606105,'Bomberos');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,22,14.628878,-90.610306,'Subida A La Virgen');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,22,14.63017,-90.612279,'Predio');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,22,14.632106,-90.614151,'Corona De Justicia');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,22,14.633951,-90.616156,'FÃ¡brica');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(3,22,14.635949,-90.617956,'El Porvenir');
insert into Transporte(Tipo_Transporte, Ruta, Piloto) values(4,22,null);

-- Express â€“ Roosevelt â€“ Terminal (R11)
insert into Ruta(id_Ruta,Nombre_Ruta,Descripcion_Ruta) values(23,'R11','Express â€“ Roosevelt â€“ Terminal');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,23,14.636895,-90.619569,'Terminal R11 (Ascenso)');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,23,14.635886,-90.618052,'El Porvenir');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,23,14.634086,-90.616279,'FÃ¡brica');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,23,14.632243,-90.614332,'Corona De Justicia');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,23,14.630114,-90.612366,'Predio');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,23,14.628941,-90.610627,'Subida A La Virgen');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,23,14.631336,-90.60813,'Farmacia Galeno');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,23,14.630173,-90.606663,'Mixco Parque');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,23,14.629016,-90.602897,'Delta');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,23,14.628303,-90.599986,'Puente Doroteo Guamuch');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,23,14.629442,-90.598895,'Licorera');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,23,14.634824,-90.595505,'Tinco');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,23,14.634601,-90.590904,'Molino De Las Flores / Seminario Mayor');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,23,14.634389,-90.586995,'Bi');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,23,14.63416,-90.582315,'El Tesoro');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,23,14.633927,-90.57877,'Canadience');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,23,14.633688,-90.574422,'Santa Rita');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,23,14.630637,-90.566252,'Colegio Italiano');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,23,14.625816,-90.557269,'Walmart');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,23,14.623656,-90.553245,'Tikal Futura');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,23,14.618843,-90.544293,'La Doce');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,23,14.616996,-90.541336,'Incan');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,23,14.613669,-90.535721,'TrÃ©bol I');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,23,14.612133,-90.53454,'TrÃ©bol II');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,23,14.610124,-90.532781,'Pamplona');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,23,14.608624,-90.532019,'Igss');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,23,14.606375,-90.527187,'La Castellana I');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,23,14.608394,-90.526232,'La Castellana II');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,23,14.60999,-90.523484,'Parque De La Industria');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,23,14.610035,-90.521306,'Terminal');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,23,14.61078,-90.522817,'Quinta Calle');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,23,14.610039,-90.525749,'Torre Claro / Parque De La Industria');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,23,14.60588,-90.527716,'Avenida La Castellana II / CantÃ³n Guarda Viejo');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,23,14.605035,-90.528123,'Avenida La Castellana I');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,23,14.609031,-90.531762,'LiberaciÃ³n');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,23,14.612251,-90.533996,'TrÃ©bol II');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,23,14.613936,-90.535419,'TrÃ©bol I');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,23,14.615918,-90.538018,'Landivar');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,23,14.61873,-90.543503,'Cruz Verde');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,23,14.623874,-90.552923,'Gran VÃ­a Roosevelt');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,23,14.625899,-90.556765,'Peri-Rooselvelt');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,23,14.631106,-90.56641,'Itzamna');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,23,14.633984,-90.574438,'Centro EspaÃ±ol');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,23,14.634368,-90.581604,'Eskala');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,23,14.634851,-90.590577,'Molino De Las Flores / Seminario Mayor');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,23,14.635169,-90.595765,'Tinco');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,23,14.629618,-90.599196,'Pasarela Licorera');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,23,14.629307,-90.602511,'Cementerio / Delta');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,23,14.630266,-90.606105,'Bomberos');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,23,14.628878,-90.610306,'Subida A La Virgen');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,23,14.63017,-90.612279,'Predio');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,23,14.632106,-90.614151,'Corona De Justicia');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,23,14.633951,-90.616156,'FÃ¡brica');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,23,14.635949,-90.617956,'El Porvenir');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(3,23,14.637038,-90.619538,'Terminal R11 (Descenso)');
insert into Transporte(Tipo_Transporte, Ruta, Piloto) values(4,23,null);

-- Express â€“ Mixco â€“ Obelisco (R11A)
insert into Ruta(id_Ruta,Nombre_Ruta,Descripcion_Ruta) values(24,'R11A','Express â€“ Mixco â€“ Obelisco');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(1,24,14.63017,-90.612279,'Predio');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,24,14.632106,-90.614151,'Corona De Justicia');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,24,14.632172,-90.610981,'El Palomar');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,24,14.631458,-90.608232,'Farmacia Galeno');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,24,14.631012,-90.60634,'Mixco Parque');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,24,14.629307,-90.602511,'Cementerio / Delta');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,24,14.628303,-90.599986,'Puente Doroteo Guamuch');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,24,14.629442,-90.598895,'Licorera');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,24,14.634601,-90.590904,'Molino De Las Flores / Seminario Mayor');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,24,14.63416,-90.582315,'El Tesoro');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,24,14.633688,-90.574422,'Santa Rita');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,24,14.630637,-90.566252,'Colegio Italiano');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,24,14.625816,-90.557269,'Walmart');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,24,14.623656,-90.553245,'Tikal Futura');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,24,14.618843,-90.544293,'La Doce');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,24,14.616996,-90.541336,'Incan');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,24,14.613669,-90.535721,'TrÃ©bol I');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,24,14.612133,-90.53454,'TrÃ©bol II');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,24,14.610124,-90.532781,'Pamplona');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,24,14.606375,-90.527187,'La Castellana I');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,24,14.608394,-90.526232,'La Castellana II');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,24,14.60999,-90.523484,'Parque De La Industria');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,24,14.609436,-90.520581,'Terminal');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,24,14.608478,-90.515385,'Reforma');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,24,14.604136,-90.51627,'Igss Zona 9');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,24,14.599965,-90.517024,'Montufar');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,24,14.595142,-90.518533,'Obelisco');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,24,14.599277,-90.524506,'ZoolÃ³gico La Aurora');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,24,14.609031,-90.531762,'LiberaciÃ³n');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,24,14.612251,-90.533996,'TrÃ©bol II');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,24,14.613936,-90.535419,'TrÃ©bol I');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,24,14.615918,-90.538018,'Landivar');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,24,14.61873,-90.543503,'Cruz Verde');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,24,14.623874,-90.552923,'Gran VÃ­a Roosevelt');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,24,14.625899,-90.556765,'Peri-Rooselvelt');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,24,14.631106,-90.56641,'Itzamna');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,24,14.633984,-90.574438,'Centro EspaÃ±ol');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,24,14.634368,-90.581604,'Eskala');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,24,14.634851,-90.590577,'Molino De Las Flores / Seminario Mayor');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,24,14.635205,-90.59856,'Tinco');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,24,14.629618,-90.599196,'Pasarela Licorera');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,24,14.629307,-90.602511,'Delta Mixco');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,24,14.630266,-90.606105,'Bomberos');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(2,24,14.628878,-90.610306,'Subida A La Virgen');
insert into Parada(Tipo_Parada,Ruta,Latitud,Longitud,Descripcion) values(3,24,14.63017,-90.612279,'Predio');
insert into Transporte(Tipo_Transporte, Ruta, Piloto) values(4,24,null);

drop procedure getParadas;

DELIMITER $$

CREATE PROCEDURE getParadas()
BEGIN
    SELECT
        p.id_Parada,
        p.Latitud,
        p.Longitud,
        r.Nombre_Ruta,
        tpo.Tipo AS TipoTransporte,
        p.Descripcion,
        p.Tipo_Parada
    FROM Parada p
    JOIN Ruta r ON p.Ruta = r.id_Ruta
    LEFT JOIN Transporte tr ON r.id_Ruta = tr.Ruta
    LEFT JOIN TipoTransporte tpo ON tr.Tipo_Transporte = tpo.id_TipoTransporte;
END $$

DELIMITER ;





call getParadas();



