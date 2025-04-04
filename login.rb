require 'bcrypt'
require 'json'

ARQUIVO = ENV['usuarios']

def login
  unless File.exist?(ARQUIVO)
    puts "Arquivo de usuários não encontrado."
    return
  end

  print "Digite seu nome de usuário: "
  nome = gets.chomp.strip
  print "Digite sua senha: "
  senha = gets.chomp.strip

  users = JSON.parse(File.read(ARQUIVO), symbolize_names: true)

  user = users.find { |u| u[:nome] == nome }

  if user && BCrypt::Password.new(user[:senha]) == senha
    puts "\n✅ Login bem-sucedido! Bem-vindo, #{nome}!"
  else
    puts "\n❌ Nome de usuário ou senha incorretos."
  end
end

login
