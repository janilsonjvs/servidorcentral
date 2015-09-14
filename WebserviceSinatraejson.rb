require 'rdbi-driver-sqlite3'
require 'json'
require 'sinatra'

def listadados(d)
datas = Hash.new
	dbh	=	RDBI.connect(:SQLite3,	:database	=>	"dbcopas.db")
	sth = dbh.execute('select PAIS.NOME, COPAS.ANO_COPA from REL_COPASPAIS R INNER JOIN COPAS ON COPAS.ID=R.ID_COPAS INNER JOIN PAIS ON PAIS.ID=COPAS.LOCAL WHERE R.ID_PAIS = ' + d.to_s)

	sth.fetch(:all).each do |i|
	datas[i[0]] = i[1]
	end
	dbh.disconnect
	datas
end

def campeos
#Item 1 da lista: Lista todos os campeos	
dbh	=	RDBI.connect(:SQLite3,	:database	=>	"dbcopas.db")
rs	=	dbh.execute("SELECT PAIS.ID, PAIS.NOME, COPAS.ANO_COPA, PAIS.CONTINENTE FROM PAIS INNER JOIN REL_COPASPAIS R ON R.ID_PAIS = PAIS.ID INNER JOIN COPAS ON COPAS.ID=R.ID_COPAS GROUP BY PAIS.NOME")	
list = Hash.new
cont = Hash.new
i = 1
puts '-----------Campeos----------'
	rs.fetch(:all).each	do |row|
		list[row[1]] = listadados(row[0])
		i += 1
	end
	cont['campeos'] = list
	dbh.disconnect
	j = JSON.generate(cont)
	
end

def listacopaspais
dbh	=	RDBI.connect(:SQLite3,	:database	=>	"dbcopas.db")
rs	=	dbh.execute("SELECT PAIS.NOME, COPAS.ANO_COPA FROM COPAS INNER JOIN PAIS ON PAIS.ID = COPAS.LOCAL ORDER BY COPAS.ANO_COPA")	
lcopas = Hash.new
	rs.fetch(:all).each do |r| 
			lcopas[r[1]] = r[0]
	end
	dbh.disconnect
	lcopas
end

def copasrealizadas
#Item: 2 - todos os paises vencedores	
puts '-----------Copas Realizadas----------'
	
copasr = Hash.new
	copasr['qtdcopas'] = 'copas'
	copasr['realizadas'] =  listacopaspais
		
	j = JSON.generate(copasr)
	

end


def anoscampeao(nomepais)
#Item 3  da lista: Relação de anos que um determinado pais foi campeao
dbh	=	RDBI.connect(:SQLite3,	:database	=>	"dbcopas.db")
prep	=	dbh.prepare('SELECT ANO_COPA, PAIS.NOME FROM PAIS INNER JOIN REL_COPASPAIS R ON R.ID_PAIS=PAIS.ID INNER JOIN COPAS ON COPAS.ID=R.ID_COPAS WHERE  UPPER(PAIS.NOME)  = ?' )	
rs = prep.execute(nomepais.to_s.upcase)
lcopas = Hash.new
anos = Hash.new
i = 1
lcopas['pais'] = nomepais.to_s.upcase
	rs.fetch(:all).each do |r|
		anos[i.to_s] = r[0]
		i += 1
	end
	lcopas['anocampeonato'] = anos
	j = JSON.generate(lcopas)
	
end


def paissede(nomepais)
dbh	=	RDBI.connect(:SQLite3,	:database	=>	"dbcopas.db")
prep	=	dbh.prepare('SELECT ANO_COPA FROM COPAS INNER JOIN REL_COPASPAIS R ON R.ID_COPAS=COPAS.ID INNER JOIN PAIS ON PAIS.ID=COPAS.LOCAL WHERE UPPER(PAIS.NOME) = ? ORDER BY ANO_COPA ')	
rs = prep.execute(nomepais.to_s.upcase)
lcopas = Hash.new
anos = Hash.new
i = 1
lcopas['paissede'] = nomepais.to_s.upcase
	

		rs.fetch(:all).each do |r|
		anos[i.to_s] = r[0]
		i += 1
		end
	lcopas['anos'] = anos
	j = JSON.generate(lcopas)		
	
		
end


get '/paissede/json/:nome' do 
	paissede(params['nome'])
end

get '/anoscampeao/json/:nome' do 
	anoscampeao(params['nome'])
	
end
get '/copasrealizadas/json/' do 
	copasrealizadas
	
end
get '/campeos/json/' do 
	#campeos
	status = '404'
end
