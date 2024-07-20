-- Primer challenge 

--"Selecciona la columna Titulo de la tabla Posteos junto con el Nombre de Usuario de los usuarios que lo publicaron para aquellos posteos que tienen Id"




SELECT  TOP 200 DisplayName, Location, Reputation -- selecciono las primeras 200 filas de resultado
FROM Users -- Llamo a mi tabla principal
ORDER BY Reputation desc; -- ordeno que se enliste de forma desc (de mayor a menor)






-- 2 challenge 


--Selecciona la columna Title de la tabla Posts junto con el DisplayName de los usuarios que lo publicaron para aquellos posts que tienen un propietario. Para lograr esto une las tablas Posts y Users utilizando OwnerUserId para obtener el nombre del usuario que publicó cada post. Presenta los resultados en una tabla mostrando las columnas Title y DisplayName


SELECT TOP 200
        Posts.Title,Users.DisplayName    -- Seleccionamos columnas y tablas
    Posts              
JOIN -- las uno 
    Users 
ON -- ordeno "de esta forma"
    Posts.OwnerUserId = Users.Id   
WHERE 
    Posts.OwnerUserId IS NOT NULL -- Filtro con NULL para asegurarme de que el post tiene un Id




-- 3 challenge


--Calcula el promedio de Score de los Posts por cada usuario y muestra el DisplayName del usuario junto con el promedio de Score. Para esto agrupa los posts por OwnerUserId, calcula el promedio de Score para cada usuario y muestra el resultado junto con el nombre del usuario. Presenta los resultados en una tabla mostrando las columnas DisplayName y el promedio de Score


SELECT TOP 200
	AVG(Posts.Score) AS PuntajePromedio, -- calculo el promedio con la funcion AVG, y renombro el resultado con AS
    Users.DisplayName -- llamo al nombre de usuario

FROM Posts -- seleciono tabla principal 

JOIN Users -- las uno

ON Posts.OwnerUserId = Users.Id -- desde desde el id de la tabla posts, uniendolo con el id de Users

GROUP BY DisplayName -- agrupa por nombre





-- 4 challenge


--Encuentra el DisplayName de los usuarios que han realizado más de 100 comentarios en total. Para esto utiliza una subconsulta para calcular el total de comentarios por usuario y luego filtra aquellos usuarios que hayan realizado más de 100 comentarios en total. Presenta los resultados en una tabla mostrando el DisplayName de los usuarios



SELECT TOP 200 -- selecciono las primeras 200 filas
	Users.DisplayName -- la tabla y columna que usare

FROM
	Users 

-- creo una subconsulta para agrupar los id y luego filtrar los que tengan mas de 100 comentarios
WHERE Users.Id IN ( -- siempre y cuando Id

	SELECT Posts.OwnerUserId
                                --En resumen:Subselecciono para filtrar unifico la Id de comentarios de la tabla posts y el Id Users se relacionen y se unan
	FROM Posts
	GROUP BY OwnerUserId -- cuento 
	HAVING COUNT (Posts.CommentCount)>100)





-- 5 challenge


--Actualiza la columna Location de la tabla Users cambiando todas las ubicaciones vacías por "Desconocido". Utiliza una consulta de actualización para cambiar las ubicaciones vacías. Muestra un mensaje indicando que la actualización se realizó correctamente.




BEGIN TRANSACTION;

UPDATE Users
SET Location = 'Desconocido'
WHERE Location IS NULL OR Location = '';

-- Verifica cuántas filas fueron afectadas por el UPDATE
IF @@ROWCOUNT > 0
BEGIN
    PRINT 'La actualización se realizó correctamente.';
    -- Aquí puedes agregar más operaciones que dependan de la actualización exitosa
END
ELSE
BEGIN
    PRINT 'No se actualizaron filas.';
    -- Podrías realizar alguna otra acción si no se actualizaron filas
END

COMMIT;




-- 6 challenge


--  Elimina todos los comentarios realizados por usuarios con menos de 100 de reputación. Utiliza una consulta de eliminación para eliminar todos los comentarios realizados y muestra un mensaje indicando cuántos comentarios fueron eliminados
    



BEGIN TRANSACTION;

-- Elimina los comentarios realizados por usuarios con menos de 100 de reputación
DELETE FROM Comments
WHERE UserId IN (
    SELECT Id
    FROM Users
    WHERE Reputation < 100
);

-- Verifica cuántos comentarios fueron eliminados
DECLARE @DeletedComments INT;
SET @DeletedComments = @@ROWCOUNT;

-- Muestra un mensaje indicando cuántos comentarios fueron eliminados
PRINT CAST(@DeletedComments AS VARCHAR) + ' comentarios fueron eliminados.';

COMMIT;




-- 7 challenge

--Para cada usuario, muestra el número total de publicaciones (Posts), comentarios (Comments) y medallas (Badges) que han realizado. Utiliza uniones (JOIN) para combinar la información de las tablas Posts, Comments y Badges por usuario. Presenta los resultados en una tabla mostrando el DisplayName del usuario junto con el total de publicaciones, comentarios y medallas



SELECT Users.DisplayName, 
       COALESCE(PostsCount.TotalPosts, 0) AS TotalPosts,
       COALESCE(CommentsCount.TotalComments, 0) AS TotalComments,
       COALESCE(BadgesCount.TotalBadges, 0) AS TotalBadges
FROM Users
LEFT JOIN (
    SELECT Id, COUNT(*) AS TotalPosts
    FROM Posts
    GROUP BY Id
) AS PostsCount ON Users.Id = PostsCount.Id
LEFT JOIN (
    SELECT UserId, COUNT(*) AS TotalComments
    FROM Comments
    GROUP BY UserId
) AS CommentsCount ON Users.Id = CommentsCount.UserId
LEFT JOIN (
    SELECT UserId, COUNT(*) AS TotalBadges
    FROM Badges
    GROUP BY UserId
) AS BadgesCount ON Users.Id = BadgesCount.UserId




-- 8 challenge

--Muestra las 10 publicaciones más populares basadas en la puntuación (Score) de la tabla Posts. Ordena las publicaciones por puntuación de forma descendente y selecciona solo las 10 primeras. Presenta los resultados en una tabla mostrando el Title de la publicación y su puntuación



SELECT TOP 10 Title, Score
FROM Posts
ORDER BY Score DESC;




-- 9 challenge

-- Muestra los 5 comentarios más recientes de la tabla Comments. Ordena los comentarios por fecha de creación de forma descendente y selecciona solo los 5 primeros. Presenta los resultados en una tabla mostrando el Text del comentario y la fecha de creación


SELECT TOP 5 Text, CreationDate
FROM Comments
ORDER BY CreationDate DESC;
