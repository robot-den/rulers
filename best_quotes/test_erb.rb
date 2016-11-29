require 'erubis'

template = <<TEMPLATE
Ololo, my template!
It has <%= var %>
TEMPLATE

eruby = Erubis::Eruby.new(template)
puts eruby.src
puts '--------'
puts eruby.result(var: 'money')
