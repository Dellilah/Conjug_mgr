module Download
  require 'net/http'

  def download_conjugation(page)
    verbs = Array.new
    @verbs_conj = Array.new

    flag = 1
    i = 53

    url = URI.parse("http://leconjugueur.lefigaro.fr/frlistedeverbe.php")
    @verbs_list = Nokogiri::HTML(open(url))
    while flag == 1 do
      a = @verbs_list.css('li a')[i]
      if a
        verbs.push(a.text)
        i += 1
      else
        flag = 0
      end

    end

    verbs.shift

    verbs.each_with_index do |verb, i|
      @verbs_conj[i] = Hash.new
      verb = verbs[((page.to_i - 1)*3)+i]
      @verbs_conj[i] = download_verb_conjugation(verb)

      if i > page.to_i*3
        break
      end
    end
  end

  def download_verb_conjugation(verb)
    tenses = {présent: 6, passé_composé: 7, imparfait: 8, plus_que_parfait: 9, passé_simple: 10,  passé_antérieur: 11, futur_simple: 12,
            futur_antérieur: 13, subjonctif_présent: 15,
        subjonctif_passé: 16, subjonctif_imparfait: 17, subjonctif_plus_que_parfait: 18, conditionnel_présent: 20, conditionnel_passé_première: 21, conditionnel_passé_deuxième: 22}
    forms = {je: 3, tu: 6, il: 9, nous: 12, vous: 15, ils: 18}
    ret = Hash.new
    ret[:infinitive] = verb
    tenses.each do |key, tense|
      ret[key] = Hash.new
    end
    v = verb.gsub(/[âäàéèêëîïôöûç]/, 'é' =>'e', 'è' =>'e', 'ë' =>'e', 'ê' =>'e','ä' => 'a','â' => 'a','à' => 'a',
      'ô' =>'o','ö' =>'o','û' =>'u','ç' =>'c', 'î' =>'i','ï' =>'i')
    url = "http://leconjugueur.lefigaro.fr/conjugaison/verbe/#{v}.html"
    url_trans = "http://pl.pons.eu/francuski-polski/#{v}"
    @translation = Nokogiri::HTML(open(url_trans))
    ret[:translation] = @translation.css('div.target a').children[1].text

    @conjugation = Nokogiri::HTML(open(url))
    groupe = @conjugation.css('td b').to_a
    groupe = groupe[1].children[0].text

    a = case groupe
      when "premier groupe" then 1
      when "deuxième groupe" then 2
      when "troisième groupe" then 3
      else 3
    end

    ret[:group] = a

    t = @conjugation.css('td').to_a
    tenses.each do |key, tense|
      forms.each do |key2, form|
        if t[tense].children.length < 18
         temp = "-"
        else
          # Usuwanie form "je, j', tu..." oraz "que, qu'il"
          temp = t[tense].children[form-1].text + t[tense].children[form].text
          temp.gsub!("que ", "")
          temp.gsub!("qu'", "")
          if temp.include? "'"
            temp = temp.split("'").pop
          else
            temp = temp.split(" ")
            temp.shift
            temp = temp.join(" ")
          end
        end

        ret[key][key2] = temp
      end
    end
    return ret
  end
end


