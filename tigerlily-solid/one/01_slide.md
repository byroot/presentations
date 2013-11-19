<!SLIDE presentation-cover>
# Liquid & Solid #

![tigerlily-cover](tigerlily-cover.jpg)

<!SLIDE>

# Tigerlily

Tigerlily édite une plateforme à destination des grands comptes, qui leur permet de gérer de façon simple et efficace leurs actions de social marketing

<!SLIDE>

# Liquid - Qu'est-ce que c'est ?

* Implémentation Ruby du moteur de template de Django
* Crée par Shopify
* Son seul intérêt: être utilisé comme bac à sable

<!SLIDE>

# Liquid - Bac à sable

    @@@ html
      <p><% User.delete_all %> Pwned !</p>


<!SLIDE>

# Sommaire

* Liquid
    * Aperçu
    * Sécurité
    * Extension
    * Performance
* Solid
    * Aperçu
    * Tags / Block
    * Template
    * ModelDrop

<!SLIDE>

# Aperçu

    @@@ html
        {% for story in story_list %}
        <h2>
          <a href="{% url_to story %}">
            {{ story.headline }}
          </a>
        </h2>
        <p>{{ story.tease|escape }}</p>
        {% endfor %}

<!SLIDE>

# Utilisation

    @@@ ruby
        template = Liquid::Template.parse('Hello {{ person }}')
        puts template.render('person' => 'Homer')

<!SLIDE>
# Sécurité

* Liquid::Drop
* Module#liquid_methods
* Object#to_liquid

<!SLIDE>
# Sécurité - Liquid::Drop

    @@@ ruby
        class ShopDrop < Liquid::Drop

          def top_sales
            Shop.current.products.find(:all, :order => 'sales', :limit => 10 )
          end

          def before_method(method_name)
            Shop.current.send(method_name) if Shop.column_names.include?(method_name)
          end

        end

<!SLIDE>
# Sécurité - Module\#liquid_methods

    @@@ ruby
        class Shop

          liquid_methods :top_sales
          
          def top_sales
            Shop.current.products.find(:all, :order => 'sales', :limit => 10 )
          end

        end

<!SLIDE>
# Sécurité - \#to_liquid

    @@@ ruby
        class Shop

          def to_liquid
            self
          end
          
          def top_sales
            Shop.current.products.find(:all, :order => 'sales', :limit => 10 )
          end

        end


<!SLIDE>
# Sécurité - \#to_liquid

    @@@ html
        <p>{{ shop.class.delete_all }} Pwned !</p>


<!SLIDE>
# Extension

* Filters
* Tags
* Block


<!SLIDE>

# Extension - Filters

    @@@ html
        <p>{{ my_list|join:", " }}</p>


<!SLIDE>

# Extension - Filters

    @@@ ruby
        module MyFilters

          def join(input, glue=' ')
            input.join(glue)
          end

        end

        Liquid::Template.register_filter(MyFilters)

<!SLIDE>

# Extension - Tags

    @@@ html
        <p>{% random 5 %}</p>
        <!-- produce -->
        <p>3</p>

<!SLIDE>

# Extension - Tags

    @@@ ruby
        class Random < Liquid::Tag
          def initialize(tag_name, max, tokens)
            super
            @max = max.to_i
          end

          def render(context)
            rand(@max).to_s
          end
        end

        Liquid::Template.register_tag('random', Random)

<!SLIDE>

# Extension - Block

    @@@ html
        {% random 5 %}
          <p>Wanna hear a joke?<p>
        {% endrandom %}

        <!-- In 20% of the cases, produce: -->

        <p>Wanna hear a joke?</p>


<!SLIDE>

# Extension - Block

    @@@ ruby
        class Random < Liquid::Block
          def initialize(tag_name, markup, tokens)
            super
            @rand = markup.to_i
          end

          def render(context)
            if rand(@rand) == 0
              super
            else
              ''
            end
          end
        end

        Liquid::Template.register_tag('random', Random)


<!SLIDE>

# Extension - Multipart Block

    @@@ html
        <p>
        {% if_already_voted_on post %}
            Remove my vote
        {% else %}
            Vote
        {% endif_already_voted_on %}
        </p>

<!SLIDE>

# Extension - Multipart Block

    @@@ ruby
        class IfAlreadyVotedOn < Liquid::Block

          def initialize(tag_name, variable, tokens)
            @variable = variable
            @blocks = []
            push_block!
            super
          end

          def render(context)
            context.stack do
              current_user = context['current_user']
              post = context[@variable]
              block = current_user.already_voted_on?(post) ? @blocks.first : @blocks.last
              return render_all(block, context)
            end
          end

          ## snip ....

<!SLIDE>

# Extension - Multipart Block

    @@@ ruby
          def unknown_tag(tag, markup, tokens)
            if tag == 'else'
              push_block!
            else
              super
            end
          end

          private

          def push_block!
            block = []
            @blocks.push(block)
            @nodelist = block
          end

        end

        Template.register_tag('if_already_voted_on', IfAlreadyVotedOn)

<!SLIDE>
# Performance - Parsing

* Décentes
* Linéaires

<!SLIDE>
# Performance - Parsing

    @@@ ruby
        GC.disable
        Benchmark.bm{ |x| 
            x.report('~25    tags') { Liquid::Template.parse(template25) }
            x.report('~250   tags') { Liquid::Template.parse(template250) }
            x.report('~2500  tags') { Liquid::Template.parse(template2500) }
            x.report('~25000 tags') { Liquid::Template.parse(template25000) }
        }
        GC.enable

        ~25    tags  0.000000   0.000000   0.000000 (  0.001449)
        ~250   tags  0.010000   0.000000   0.010000 (  0.009970)
        ~2500  tags  0.100000   0.000000   0.100000 (  0.098813)
        ~25000 tags  1.020000   0.010000   1.030000 (  1.028419)

<!SLIDE>
# Performance - Rendering

* Pas terribles
* Attention au GC !!!
* Implémenter un block pour faire du fragment caching


<!SLIDE>

# Solid - Qu'est-ce que c'est ?

Une bibliothèque qui aide à créer des tags liquid plus cohérents et plus facilement.


<!SLIDE>

# Solid - Tags / Blocks - Arguments

    @@@ ruby
        class TypeOfTag < Solid::Tag

          tag_name :typeof

          def display(*values)
            values.map{ |value| "<p>Type of #{value.inspect} is #{value.class.name}</p>" }.join("\n")
          end

        end

<!SLIDE>

# Solid - Tags / Blocks - Arguments

    @@@ html
        {% capture myvar %}eggspam{% endcapture %}
        {% typeof "foo", 42, 4.2, myvar, /bb|[^b]{2}/, myoption:"bar", otheroption:myvar %}
        <!-- produce -->
        <p>Type of "foo" is String</p>
        <p>Type of 42 is Fixnum</p>
        <p>Type of 4.2 is Float</p>
        <p>Type of "eggspam" is String</p>
        <p>Type of /bb|[^b]{2}/ is Regexp</p>
        <p>Type of {:myoption=>"bar", :otheroption=>"eggspam"} is Hash</p>

<!SLIDE>

# Solid - Tags / Blocks - Context attributes

    @@@ ruby
        class HelloTag < Solid::Tag

          tag_name :hello

          context_attribute :current_user

          def display
            "Hello #{current_user.name} !"
          end

        end

<!SLIDE>

# Solid - Blocks

    @@@ ruby
        class PBlock < Solid::Block

          tag_name :p

          def display(options)
            "<p class='#{options[:class]}'>#{yield}</p>"
          end

        end

<!SLIDE>

# Solid - Blocks

    @@@ html
        {% p class:"content" %}
          It works !
        {% endp %}
        <!-- produce -->
        <p class="content">It works !</p>

<!SLIDE>

# Solid - Conditional Blocks

    @@@ ruby
        class IfAlreadyVotedOn < Solid::ConditionalBlock

          tag_name :if_already_voted_on

          context_attribute :current_user

          def display(post)
            yield(current_user.already_voted_on?(post))
          end

        end

<!SLIDE>

# Solid - Conditional Blocks

    @@@ html
        <p>
        {% if_already_voted_on post %}
            Remove my vote
        {% else %}
            Vote
        {% endif_already_voted_on %}
        </p>


<!SLIDE>

# Solid - Template

* Totalement optionel
* Facilite l'introspection (Enumerable)
* Rails cache

<!SLIDE>

# Solid - ModelDrop

    @@@ ruby
        class Post < ActiveRecord::Base
          scope :published, where(:published => true)
          scope :with_comments, where('comments_count > 0')
          
          class << self
            liquid_methods :published, :with_comments
          end
        end

        SyntaxError: (eval):1: syntax error, unexpected $end
        ...Class < Liquid::Drop; self; end

<!SLIDE>

# Solid - ModelDrop

    @@@ ruby
        class PostDrop < Solid::ModelDrop

          allow_scopes :published, :with_comments

          respond :to => /sorted_by_(\w+)/, :with => :sort_by

          protected
          def sort_by(ordering)
            @scope = scope.sorted_by(ordering)
          end
          immutable_method :sort_by

        end

<!SLIDE>

# Solid - ModelDrop

    @@@ html
        {% for post in Post.published.with_comments.sorted_by_comments_count %}
            <p>{{ post.title }}</p>
        {% endfor %}

<!SLIDE>

# Solid - Goodies

Coloration syntaxique pour Ace

    @@@ javascript
        //= require ace/mode-solid

<!SLIDE>

# References

* Tigerlily: [http://tigerlilyapps.com/](http://tigerlilyapps.com/)
* Rubygem: [https://rubygems.org/gems/tigerlily-solid](https://rubygems.org/gems/tigerlily-solid)
* Github: [https://github.com/tigerlily/solid](https://github.com/tigerlily/solid)




