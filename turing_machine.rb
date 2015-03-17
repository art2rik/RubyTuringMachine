class TuringMachine

  public

  def initRules (rule_link) #Инициализация правила
    rule_file = File.open(rule_link)
    rules = {}

    states = rule_file.readline.to_s.split ('|') # Извлечение состояний в массив
    states.delete_at(0)
    states.each { |state| state.to_s.strip! }
    states.each { |state| rules.store state, {} }
    @state_start = states[0]

    rule_file.readlines.each do |line| #создание структуры команд

      tmp = line.to_s.split ('|')
      tmp.each { |cell| cell.to_s.strip! }

      symbol = tmp[0]
      tmp.delete_at(0)

      (0...states.size).each do |i|

        if tmp[i].to_s.strip != '' # это чтобы не вылетала программа

          commands = tmp[i].split(',').each { |cmd| cmd.strip! }

          cmd = {'state_to' => commands[0],
                 'write_to' => commands[1],
                 'move_to' => commands[2]}

          rules[states[i]].store symbol, cmd
        end
      end
    end
    rule_file.close
    @rules = rules
  end

  public

  def insertTape (tape)
    @tape = tape.strip
  end

  public

  def runProgram #Запуск программы

    state_mode = false
    pointer = 0
    state = @state_start

    while !state_mode do
      symbol = @tape[pointer]


      unless @rules.key? state #проверка на правильность перехода
        puts "Machine goes into terminal state..."
        puts "___________________________________"
        puts "Output is here:"
        state_mode = true
        break
      end

      alphabet = {}.merge(@rules.fetch state) #костыль
      unless alphabet.key? symbol #чтобы работал этот метод
        puts "You've just are broke the machine!"
        return
      end

      move_to = @rules[state][symbol]['move_to']
      write_to = @rules[state][symbol]['write_to']
      state_to = @rules[state][symbol]['state_to']


      @tape[pointer] = write_to
      state = state_to


      case move_to #перемещение считывающей головки
        when 'R'
          pointer += 1
        when 'L'
          pointer -= 1
        when 'N'
          pointer += 0
        else
          puts "Oh no... Pointer goes to Narny... Crash..."
          return
      end
    end

    return @tape
  end

end

  turing_machine = TuringMachine.new

  is_read = false;
  while !is_read do
    puts "Add rules to machine:"
    begin
      turing_machine.initRules "#{gets.chomp()}"
    rescue
      puts "Ohh.. Findexploer can't find the rule.\n" +
                                "Try again please..."
    else
      is_read = true
    end
  end
  puts "Insert tape:"
  turing_machine.insertTape "#{gets}"

  puts turing_machine.runProgram





