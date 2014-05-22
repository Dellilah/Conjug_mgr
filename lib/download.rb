module Download
  require 'net/http'

  def download_conjugation(page)
    verbs = Array.new
    verbs.push()
    @verbs_conj = Array.new

    url = URI.parse("http://leconjugueur.lefigaro.fr/frlistedeverbe.php")
    @verbs_list = Nokogiri::HTML(open(url))
    a = @verbs_list.css('#pop a')
    a.each do |v|
      verbs.push(v.text)
    end

    for i in 1..10
      @verbs_conj[i-1] = Hash.new
      verb = verbs[((page.to_i - 1)*10)+i]
      @verbs_conj[i-1] = download_verb_conjugation(verb)
    end

  end

  def download_verb_conjugation(verb)
    ret = Hash.new
    ret[:infinitive] = verb
    @tenses.each do |key|
      ret[key] = Hash.new
    end
    v = verb.gsub(/[âäàéèêëîïôöûç]/, 'é' =>'e', 'è' =>'e', 'ë' =>'e', 'ê' =>'e','ä' => 'a','â' => 'a','à' => 'a',
      'ô' =>'o','ö' =>'o','û' =>'u','ç' =>'c', 'î' =>'i','ï' =>'i')
    url = "http://leconjugueur.lefigaro.fr/conjugaison/verbe/#{v}.html"
    url_trans = "http://pl.pons.com/t%C5%82umaczenie/francuski-polski/#{v}"
    puts url_trans
    @translation = Nokogiri::HTML(open(url_trans))
    ret[:translation] = @translation.css('div.dd-inner div.target a')[0].text

    @conjugation = Nokogiri::HTML(open(url))
    @conjugation.search('br').each do |n|
      n.replace("\n")
    end
    groupe = @conjugation.css('div.verbe nav b').text

    a = case groupe
      when "premier groupe" then 1
      when "deuxième groupe" then 2
      when "troisième groupe" then 3
      else 3
    end

    ret[:group] = a

    #all blocks with conjugation
    blocks = @conjugation.css('div.conjugBloc').to_a

    @tenses.each_with_index do |tense, key|

      # here we've got all forms for a particular tense
      forms = blocks[key].css('p').to_a[1].text.split("\n")


      @forms.each_with_index do |form, key2|
        if forms[key2].length < 5
         temp = "-"
        else
          # Usuwanie form "je, j', tu..." oraz "que, qu'il"
          temp = forms[key2]
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
        ret[tense][form] = temp
      end
    end
    return ret
  end

end


