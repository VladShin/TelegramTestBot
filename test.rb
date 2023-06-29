require 'telegram/bot'

token = "6380177974:AAHKux1uOashgSObQ4ZWrF3mx2Ot25-PzLE"

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    case message.text
    when '/start'
      bot.api.send_message(chat_id: message.chat.id, text: "Привіт! Я бот для тестування Ruby.  ヽ(・∀・)ﾉ   \n Для початку тестування введи /test")
    when '/test'
      questions = {
        '1/20 Яка функція використовується для виводу тексту на консоль?' => 'puts',
        '2/20 Який метод використовується для додавання елемента до масиву?' => 'push',
        '3/20 Як перевірити, чи містить масив певний елемент?' => 'include',
        '4/20 Який оператор використовується для порівняння значень?' => '==',
        '5/20 Яка конструкція використовується для умовного виконання коду?' => 'if',
        '6/20 Як видалити елемент з масиву?' => 'delete',
        '7/20 Як визначити довжину масиву?' => 'length',
        '8/20 Як перетворити рядок в символи верхнього регістру?' => 'upcase',
        '9/20 Як округлити число до найближчого цілого?' => 'round',
        '10/20 Яка функція використовується для отримання введення від користувача?' => 'gets',
        '11/20 Який метод використовується для злиття двох масивів?' => 'concat',
        '12/20 Як видалити всі пробіли з рядка?' => 'gsub',
        '13/20 Як перетворити рядок в число?' => 'to_i',
        '14/20 Які логічні значення існують в Ruby?' => 'true false',
        '15/20 Яка функція використовується для визначення типу об\'єкта?' => 'class',
        '16/20 Який метод використовується для перетворення рядка в масив?' => 'split',
        '17/20 Як вивести останній елемент масиву?' => 'last',
        '18/20 Як перевірити, чи містить рядок певний підрядок?' => 'include',
        '19/20 Як визначити час виконання певного участку коду?' => 'Benchmark.measure',
        '20/20 Як з\'єднати два рядки?' => 'concatenate'
      }

      total_score = 0
      correct_answers = 0
      incorrect_answers = 0

      questions

      bot.api.send_message(chat_id: message.chat.id, text: "Починаємо тестування!   (；￣Д￣)   \n Треба відповісти на 20 питань по базовим знанням Ruby. Даний тест зможе показати наскільки добре ти знаєш основи. Поїхали!")

      questions.each do |question, correct_answer|
        bot.api.send_message(chat_id: message.chat.id, text: question)
        sleep(1)

        bot.listen do |response|
          next unless response.is_a?(Telegram::Bot::Types::Message)
          next unless response.chat.id == message.chat.id

          answer = response.text

          if answer.downcase == correct_answer.downcase
            bot.api.send_message(chat_id: message.chat.id, text: "Правильно!")
            correct_answers += 1
          else
            bot.api.send_message(chat_id: message.chat.id, text: "Неправильно. Правильна відповідь: #{correct_answer}")
            incorrect_answers += 1
          end

          break
        end
      end

      total_score = correct_answers.to_f / questions.length.to_f
      percentage = (total_score * 100).to_i

      bot.api.send_message(chat_id: message.chat.id, text: "Тест завершено!")
      bot.api.send_message(chat_id: message.chat.id, text: "Правильних відповідей: #{correct_answers}")
      bot.api.send_message(chat_id: message.chat.id, text: "Неправильних відповідей: #{incorrect_answers}")
      bot.api.send_message(chat_id: message.chat.id, text: "Загальний результат: #{percentage}%")

      if percentage <= 30
        bot.api.send_message(chat_id: message.chat.id, text: "На жаль, ти поки погано знаєш основи, треба підучити трішки.   (；⌣̀_⌣́) ")
      elsif percentage > 30 and percentage <= 75
        bot.api.send_message(chat_id: message.chat.id, text: "Ти цілком добре знаєш основи, але треба трішки підтягнути деякі питання, в цілому знання непогані.  ╰(▔∀▔)╯")
      elsif percentage > 75
        bot.api.send_message(chat_id: message.chat.id, text: "Ти добре ознайомлений з базою Ruby, так тримати!   (╯✧▽✧)╯ ")
      end

    else
      bot.api.send_message(chat_id: message.chat.id, text: "Не розумію команду. Використайте /start для початку.")
    end
  end
end
