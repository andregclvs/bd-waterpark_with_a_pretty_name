-- 1. Obter uma listagem dos utilizadores 
-- que frequentaram uma atração num intervalo de tempo;

DELIMITER //

DROP PROCEDURE IF EXISTS whoVisited //

CREATE PROCEDURE whoVisited(id INT, fromWhen DATETIME, toWhen DATETIME)
BEGIN  
	SELECT distinct U.Id "Id do Visitante", U.Nome as "Nome do Visitante" from Utilizador as U
	INNER JOIN e_visitada_por as V on U.Id = V.Utilizador_Id
	WHERE (V.Data_entrada_fila between fromWhen and toWhen) 
		and id = V.Atracao_Id;
END //

-- 2. Obter o tempo médio de espera 
-- dos utilizadores de uma atração num intervalo de tempo;
DELIMITER //

DROP PROCEDURE IF EXISTS averageWait //

CREATE PROCEDURE averageWait(id INT, fromWhen DATETIME, toWhen DATETIME)
BEGIN
    SELECT sec_to_time(avg(time_to_sec(timediff(V.Data_entrada_atracao,V.Data_entrada_fila)))) as "Média" from e_visitada_por as V
	WHERE (V.Data_entrada_fila between fromWhen and toWhen) 
		and id = V.Atracao_Id
        and (V.Data_entrada_atracao between fromWhen and toWhen)
        and V.Data_entrada_atracao is not null;
END //

-- 3. Obter o número de utilizadores em fila numa atração 
-- num intervalo de tempo;
DELIMITER //

DROP PROCEDURE IF EXISTS countWaiting //

CREATE PROCEDURE countWaiting(id INT, fromWhen DATETIME, toWhen DATETIME)
BEGIN
	SELECT count(V.Utilizador_Id) as "Nº de utilizadores em espera" from e_visitada_por as V
    where (V.data_entrada_atracao = null)
    and id = V.Atracao_Id
    and (V.Data_entrada_atracao between fromWhen and toWhen);
END //
