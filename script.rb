require 'securerandom'
require 'json'

ARQUIVO = "user.json"

def criarUsuario(tamanho = 38)
  caracteres = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
  token = Array.new(tamanho) { caracteres[SecureRandom.random_number(caracteres.length)] }.join

  puts "Qual nome de usuário deseja criar?"
  nome = gets.chomp	

  puts "\nNome de usuário: #{nome}\nToken: #{token}"
  puts "Usuário criado com sucesso!"

  user = { nome: nome, token: token }
  salvarUser(user)
end

def salvarUser(user)
  users = File.exist?(ARQUIVO) ? JSON.parse(File.read(ARQUIVO), symbolize_names: true) : []
  users << user
  File.write(ARQUIVO, JSON.pretty_generate(users))
end

def listarUsuarios
  if File.exist?(ARQUIVO)
    users = JSON.parse(File.read(ARQUIVO), symbolize_names: true)
    if users.empty?
      puts "\nNenhum usuário cadastrado."
    else
      puts "\nUsuários cadastrados:"
      users.each_with_index do |user, i|
        puts "#{i + 1}. #{user[:nome]}"
      end
    end
  else
    puts "\nNenhum usuário cadastrado."
  end
end

def deletarUsuario
  if File.exist?(ARQUIVO)
    users = JSON.parse(File.read(ARQUIVO), symbolize_names: true)
    if users.empty?
      puts "\nNenhum usuário para deletar."
      return
    end

    puts "\nUsuários cadastrados:"
    users.each_with_index do |user, i|
      puts "#{i + 1}. #{user[:nome]}"
    end

    print "Digite o número do usuário que deseja deletar: "
    index = gets.chomp.to_i

    if index.between?(1, users.size)
      deletado = users.delete_at(index - 1)
      File.write(ARQUIVO, JSON.pretty_generate(users))
      puts "\nUsuário '#{deletado[:nome]}' deletado com sucesso!"
    else
      puts "\nNúmero inválido."
    end
  else
    puts "\nNenhum arquivo encontrado."
  end
end

loop do 
  puts "\nEscolha uma opção:"
  puts "1. Criar usuário"
  puts "2. Listar usuários"
  puts "3. Deletar usuário"
  puts "4. Sair"
  print ">> "
  opcao = gets.chomp.to_i

  case opcao 
  when 1
    criarUsuario
  when 2
    listarUsuarios
  when 3
    deletarUsuario
  when 4
    puts "Saindo..."
    break
  else
    puts "Opção inválida! Tente novamente!"
  end
end
