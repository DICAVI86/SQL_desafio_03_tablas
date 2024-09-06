--/1. Crea y agrega al entregable las consultas para completar el setup de acuerdo a lo pedido.

create database desafio3_diego_castillo_125;

\c desafio3_diego_castillo_125

create table usuarios (
    id serial, 
    email varchar(150), 
    name varchar(150), 
    lastname varchar(150), 
    rol varchar check (rol in ('administrador', 'usuario'))
);

create table posts (
    id serial, 
    titulo varchar(150), 
    contenido text, 
    fecha_creacion timestamp, 
    fecha_actualizacion timestamp,
    destacado boolean,
    usuario_id bigint
);

CREATE TABLE comentarios (
    id SERIAL,
    contenido VARCHAR,
    fecha_creacion TIMESTAMP,
    usuario_id BIGINT,
    post_id BIGINT
);

insert into usuarios (email, name, lastname, rol) values 
('jose@ejercicio.com', 'jose', 'correa', 'administrador'),
('pedro@ejercicio.com', 'pedro', 'infante', 'usuario'),
('pablo@ejercicio.com', 'pablo', 'solar', 'usuario'),
('santiago@ejercicio.com', 'santiago', 'carrillo', 'usuario'),
('agustin@ejercicio.com', 'agustin', 'leal', 'usuario');

insert into posts (titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id) values 
('Comer con la boca abierta', 'ABC ipsum dolor sit amet consectetur adipisicing elit.', '2024-10-03', '2024-11-12', false, 4),
('Alegar en tiempos dificiles', 'DEF ipsum dolor sit amet consectetur adipisicing elit.', '2023-06-18', '2023-07-19', false, 4),
('¿Se puede cantar debajo del agua?', 'GHI ipsum dolor sit amet consectetur adipisicing elit.', '2022-05-03', '2022-06-04', false, 1),
('Quien fue Mario Bros y como salvo a Peach', 'JKLM ipsum dolor sit amet consectetur adipisicing elit.', '2021-04-12', '2021-05-21', true, 3),
('Los dificiles dias de Roberto Paredes', 'NOPQ ipsum dolor sit amet consectetur adipisicing elit.', '2020-01-03', '2020-12-29', true, null);

insert into comentarios (contenido, fecha_creacion, usuario_id, post_id) VALUES
('Es muy bueno','2024-12-12', 1, 1),
('Es muy malo','2023-12-12', 2, 1),
('Es muy largo','2022-12-12', 3, 1),
('Es muy corto','2021-12-12', 1, 2),
('No se leer','2020-12-12', 2, 2);

select * from usuarios;
select * from posts;
select * from comentarios; 

--/2. Cruza los datos de la tabla usuarios y posts, mostrando las siguientes columnas: nombre y email del usuario junto al título y contenido del post.

SELECT u.name, u.email, p.titulo, p.contenido 
FROM usuarios u INNER JOIN posts p ON u.id = p.usuario_id;

--/3. Muestra el id, título y contenido de los posts de los administradores.
--     a. El administrador puede ser cualquier id.

SELECT p.id, p.titulo, p.contenido 
FROM posts p INNER JOIN usuarios u ON u.id = p.usuario_id 
WHERE u.rol = 'administrador';

--/4. Cuenta la cantidad de posts de cada usuario.
--     a. La tabla resultante debe mostrar el id e email del usuario junto con la cantidad de posts de cada usuario.

SELECT u.id, u.email, COUNT(p.id) AS cantidad_post 
FROM usuarios u INNER JOIN posts p ON u.id = p.usuario_id 
GROUP BY u.id, u.email;

--/5. Muestra el email del usuario que ha creado más posts.
--     a. Aquí la tabla resultante tiene un único registro y muestra solo el email.

SELECT u.email 
FROM usuarios u INNER JOIN posts p ON u.id = p.usuario_id 
GROUP BY u.email ORDER BY COUNT(p.id) DESC LIMIT 1;

--/6. Muestra la fecha del último post de cada usuario.

SELECT u.id, u.name, u.lastname, MAX(p.fecha_creacion) AS fecha_ult_post
FROM usuarios u INNER JOIN posts p ON u.id = p.usuario_id
GROUP BY u.id, u.name, u.lastname;

--/7. Muestra el título y contenido del post (artículo) con más comentarios.

SELECT p.titulo, p.contenido, COUNT(c.id) AS cant_comentarios
FROM posts p INNER JOIN comentarios c ON p.id = c.post_id
GROUP BY p.titulo, p.contenido ORDER BY cant_comentarios DESC LIMIT 1;

--/8. Muestra en una tabla el título de cada post, el contenido de cada post y el contenido de cada comentario asociado a los posts mostrados, junto con el email del usuario que lo escribió.

SELECT p.titulo, p.contenido, c.contenido, u.email
FROM posts p INNER JOIN comentarios c ON p.id = c.post_id
INNER JOIN usuarios u ON c.usuario_id = u.id;

--/9. Muestra el contenido del último comentario de cada usuario

SELECT u.id, u.email, c.contenido AS ultimo_comentario, c.fecha_creacion 
FROM usuarios u JOIN comentarios c ON u.id = c.usuario_id
WHERE c.fecha_creacion = (SELECT MAX(c1.fecha_creacion) 
                          FROM comentarios c1
                          WHERE c1.usuario_id = u.id)
ORDER BY u.id;

--/10. Muestra los emails de los usuarios que no han escrito ningún comentario.

SELECT u.email 
FROM usuarios u LEFT JOIN comentarios c ON u.id = c.usuario_id
GROUP BY u.email HAVING count(c.usuario_id) = 0;