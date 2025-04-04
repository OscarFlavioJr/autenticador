require 'securerandom'
require 'json'
require 'bcrypt'

ARQUIVO = "user.json"

def salvarUser(user)
  usuarios = []

  if File.exist?(ARQUIVO)
    conteudo = File.read(ARQUIVO)
    usuarios = JSON.parse(conteudo, symbolize_names: true) unless conteudo.strip.empty?
  end

  usuarios << user

  File.write(ARQUIVO, JSON.pretty_generate(usuarios))
end

def criarUsuario(tamanho = 8)
  puts "Qual será o nome do usuário?"
  nome = gets.chomp.strip

  if nome.empty?
    puts "Nome inválido! Tente novamente."
    return
  end

  usuarios = []
  if File.exist?(ARQUIVO)
    conteudo = File.read(ARQUIVO)
    usuarios = JSON.parse(conteudo, symbolize_names: true) unless conteudo.strip.empty?
  end

  if usuarios.any? { |u| u[:nome].downcase == nome.downcase }
    puts "Já existe um usuário com esse nome!"
    return
  end

  puts "Deseja digitar uma senha personalizada ou gerar uma aleatória?"
  puts "1. Digitar senha"
  puts "2. Gerar senha aleatória"
  print ">> "
  escolha = gets.chomp.to_i

  senha = ""
  case escolha
  when 1
    print "Digite sua senha: "
    senha = gets.chomp

    if senha.length < 6
      puts "Senha muito curta! A senha deve ter pelo menos 6 caracteres."
      return
    end
    if senha.length > 38
      puts "Senha muito longa! A senha deve ter no máximo 38 caracteres."
      return
    end
    if senha !~ /[a-z]/
      puts "A senha deve conter pelo menos uma letra minúscula."
      return
    end
    if senha !~ /\d/
      puts "A senha deve conter pelo menos um dígito numérico."
      return
    end
    if senha !~ /[!@#$%^&*(),.?":{}|<>]/
      puts "A senha deve conter pelo menos um caractere especial."
      return
    end
    puts "Senha válida."
  when 2
    caracteres = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
    senha = Array.new(8) { caracteres[SecureRandom.random_number(caracteres.length)] }.join
    puts "Senha gerada: #{senha}"
  else
    puts "Opção inválida! Tente novamente."
    return
  end

  senha_criptografada = BCrypt::Password.create(senha)

  user = {
    nome: nome,
    senha: senha_criptografada
  }
  salvarUser(user)

  puts "\nUsuário criado com sucesso!"
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
